/*
 * Copyright (C) 2021 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <err.h>
#include <errno.h>
#include <inttypes.h>
#include <string.h>

#include <filesystem>
#include <regex>
#include <sstream>
#include <string>
#include <tuple>

#include <android-base/file.h>

#include <unwindstack/Unwinder.h>

#include "MemoryOffline.h"
#include "utils/MemoryFake.h"

#include "OfflineUnwindUtils.h"

namespace unwindstack {

std::string GetOfflineFilesDirectory() {
  return android::base::GetExecutableDirectory() + "/offline_files/";
}

std::string DumpFrames(const Unwinder& unwinder) {
  std::string str;
  for (size_t i = 0; i < unwinder.NumFrames(); i++) {
    str += unwinder.FormatFrame(i) + "\n";
  }
  return str;
}

bool AddMemory(std::string file_name, MemoryOfflineParts* parts, std::string& error_msg) {
  MemoryOffline* memory = new MemoryOffline;
  if (!memory->Init(file_name.c_str(), 0)) {
    std::stringstream err_stream;
    err_stream << "Failed to add stack '" << file_name << "' to stack memory.";
    error_msg = err_stream.str();
    return false;
  }
  parts->Add(memory);

  return true;
}

bool OfflineUnwindUtils::Init(const std::string& offline_files_dir, ArchEnum arch,
                              std::string& error_msg, bool add_stack, bool set_maps) {
  // Change to offline files directory so we can read the ELF files
  cwd_ = std::filesystem::current_path();
  offline_dir_ = GetOfflineFilesDirectory() + offline_files_dir;
  std::filesystem::current_path(std::filesystem::path(offline_dir_));

  if (!android::base::ReadFileToString((offline_dir_ + "maps.txt"), &map_buffer)) {
    std::stringstream err_stream;
    err_stream << "Failed to read from '" << offline_dir_ << "maps.txt' into memory.";
    error_msg = err_stream.str();
    return false;
  }
  if (set_maps) {
    if (!ResetMaps(error_msg)) return false;
  }

  if (!SetRegs(arch, error_msg)) return false;

  if (add_stack) {
    if (!SetProcessMemory(error_msg)) return false;
  }
  if (process_memory_ == nullptr) {
    process_memory_.reset(new MemoryFake);
  }
  return true;
}

bool OfflineUnwindUtils::ResetMaps(std::string& error_msg) {
  maps_.reset(new BufferMaps(map_buffer.c_str()));
  if (!maps_->Parse()) {
    error_msg = "Failed to parse offline maps.";
    return false;
  }
  return true;
}

bool OfflineUnwindUtils::SetProcessMemory(std::string& error_msg) {
  std::string stack_name(offline_dir_ + "stack.data");
  struct stat st;
  if (stat(stack_name.c_str(), &st) == 0 && S_ISREG(st.st_mode)) {
    auto stack_memory = std::make_unique<MemoryOffline>();
    if (!stack_memory->Init((offline_dir_ + "stack.data").c_str(), 0)) {
      std::stringstream err_stream;
      err_stream << "Failed to initialize stack memory from " << offline_dir_ << "stack.data.";
      error_msg = err_stream.str();
      return false;
    }
    process_memory_.reset(stack_memory.release());
  } else {
    std::unique_ptr<MemoryOfflineParts> stack_memory(new MemoryOfflineParts);
    for (size_t i = 0;; i++) {
      stack_name = offline_dir_ + "stack" + std::to_string(i) + ".data";
      if (stat(stack_name.c_str(), &st) == -1 || !S_ISREG(st.st_mode)) {
        if (i == 0) {
          error_msg = "No stack data files found.";
          return false;
        }
        break;
      }
      if (!AddMemory(stack_name, stack_memory.get(), error_msg)) return false;
    }
    process_memory_.reset(stack_memory.release());
  }
  return true;
}

bool OfflineUnwindUtils::SetJitProcessMemory(std::string& error_msg) {
  MemoryOfflineParts* memory = new MemoryOfflineParts;

  // Construct process memory from all descriptor, stack, entry, and jit files
  for (const auto& file : std::filesystem::directory_iterator(offline_dir_)) {
    std::string filename = file.path().string();
    if (std::regex_match(filename,
                         std::regex("^(.+)\\/(descriptor|stack|entry|jit)(\\d*)\\.data$"))) {
      if (!AddMemory(filename, memory, error_msg)) return false;
    }
  }

  process_memory_.reset(memory);
  return true;
}

bool OfflineUnwindUtils::SetRegs(ArchEnum arch, std::string& error_msg) {
  switch (arch) {
    case ARCH_ARM: {
      RegsArm* regs = new RegsArm;
      regs_.reset(regs);
      if (!ReadRegs<uint32_t>(regs, arm_regs_, error_msg)) return false;
      break;
    }
    case ARCH_ARM64: {
      RegsArm64* regs = new RegsArm64;
      regs_.reset(regs);
      if (!ReadRegs<uint64_t>(regs, arm64_regs_, error_msg)) return false;
      break;
    }
    case ARCH_X86: {
      RegsX86* regs = new RegsX86;
      regs_.reset(regs);
      if (!ReadRegs<uint32_t>(regs, x86_regs_, error_msg)) return false;
      break;
    }
    case ARCH_X86_64: {
      RegsX86_64* regs = new RegsX86_64;
      regs_.reset(regs);
      if (!ReadRegs<uint64_t>(regs, x86_64_regs_, error_msg)) return false;
      break;
    }
    default:
      error_msg = "Unknown architechture " + std::to_string(arch);
      return false;
  }

  return true;
}

template <typename AddressType>
bool OfflineUnwindUtils::ReadRegs(RegsImpl<AddressType>* regs,
                                  const std::unordered_map<std::string, uint32_t>& name_to_reg,
                                  std::string& error_msg) {
  std::stringstream err_stream;
  FILE* fp = fopen((offline_dir_ + "regs.txt").c_str(), "r");
  if (fp == nullptr) {
    err_stream << "Error opening file '" << offline_dir_ << "regs.txt': " << strerror(errno);
    error_msg = err_stream.str();
    return false;
  }

  while (!feof(fp)) {
    uint64_t value;
    char reg_name[100];
    if (fscanf(fp, "%s %" SCNx64 "\n", reg_name, &value) != 2) {
      err_stream << "Failed to read in register name/values from '" << offline_dir_ << "regs.txt'.";
      error_msg = err_stream.str();
      return false;
    }
    std::string name(reg_name);
    if (!name.empty()) {
      // Remove the : from the end.
      name.resize(name.size() - 1);
    }
    auto entry = name_to_reg.find(name);
    if (entry == name_to_reg.end()) {
      err_stream << "Unknown register named " << reg_name;
      error_msg = err_stream.str();
      return false;
    }
    (*regs)[entry->second] = value;
  }
  fclose(fp);
  return true;
}

std::unordered_map<std::string, uint32_t> OfflineUnwindUtils::arm_regs_ = {
    {"r0", ARM_REG_R0},  {"r1", ARM_REG_R1}, {"r2", ARM_REG_R2},   {"r3", ARM_REG_R3},
    {"r4", ARM_REG_R4},  {"r5", ARM_REG_R5}, {"r6", ARM_REG_R6},   {"r7", ARM_REG_R7},
    {"r8", ARM_REG_R8},  {"r9", ARM_REG_R9}, {"r10", ARM_REG_R10}, {"r11", ARM_REG_R11},
    {"ip", ARM_REG_R12}, {"sp", ARM_REG_SP}, {"lr", ARM_REG_LR},   {"pc", ARM_REG_PC},
};

std::unordered_map<std::string, uint32_t> OfflineUnwindUtils::arm64_regs_ = {
    {"x0", ARM64_REG_R0},      {"x1", ARM64_REG_R1},   {"x2", ARM64_REG_R2},
    {"x3", ARM64_REG_R3},      {"x4", ARM64_REG_R4},   {"x5", ARM64_REG_R5},
    {"x6", ARM64_REG_R6},      {"x7", ARM64_REG_R7},   {"x8", ARM64_REG_R8},
    {"x9", ARM64_REG_R9},      {"x10", ARM64_REG_R10}, {"x11", ARM64_REG_R11},
    {"x12", ARM64_REG_R12},    {"x13", ARM64_REG_R13}, {"x14", ARM64_REG_R14},
    {"x15", ARM64_REG_R15},    {"x16", ARM64_REG_R16}, {"x17", ARM64_REG_R17},
    {"x18", ARM64_REG_R18},    {"x19", ARM64_REG_R19}, {"x20", ARM64_REG_R20},
    {"x21", ARM64_REG_R21},    {"x22", ARM64_REG_R22}, {"x23", ARM64_REG_R23},
    {"x24", ARM64_REG_R24},    {"x25", ARM64_REG_R25}, {"x26", ARM64_REG_R26},
    {"x27", ARM64_REG_R27},    {"x28", ARM64_REG_R28}, {"x29", ARM64_REG_R29},
    {"sp", ARM64_REG_SP},      {"lr", ARM64_REG_LR},   {"pc", ARM64_REG_PC},
    {"pst", ARM64_REG_PSTATE},
};

std::unordered_map<std::string, uint32_t> OfflineUnwindUtils::x86_regs_ = {
    {"eax", X86_REG_EAX}, {"ebx", X86_REG_EBX}, {"ecx", X86_REG_ECX},
    {"edx", X86_REG_EDX}, {"ebp", X86_REG_EBP}, {"edi", X86_REG_EDI},
    {"esi", X86_REG_ESI}, {"esp", X86_REG_ESP}, {"eip", X86_REG_EIP},
};

std::unordered_map<std::string, uint32_t> OfflineUnwindUtils::x86_64_regs_ = {
    {"rax", X86_64_REG_RAX}, {"rbx", X86_64_REG_RBX}, {"rcx", X86_64_REG_RCX},
    {"rdx", X86_64_REG_RDX}, {"r8", X86_64_REG_R8},   {"r9", X86_64_REG_R9},
    {"r10", X86_64_REG_R10}, {"r11", X86_64_REG_R11}, {"r12", X86_64_REG_R12},
    {"r13", X86_64_REG_R13}, {"r14", X86_64_REG_R14}, {"r15", X86_64_REG_R15},
    {"rdi", X86_64_REG_RDI}, {"rsi", X86_64_REG_RSI}, {"rbp", X86_64_REG_RBP},
    {"rsp", X86_64_REG_RSP}, {"rip", X86_64_REG_RIP},
};

}  // namespace unwindstack

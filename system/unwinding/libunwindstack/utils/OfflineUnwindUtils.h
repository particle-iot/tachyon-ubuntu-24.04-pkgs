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

#ifndef _LIBUNWINDSTACK_UTILS_OFFLINE_UNWIND_UTILS_H
#define _LIBUNWINDSTACK_UTILS_OFFLINE_UNWIND_UTILS_H

#include <string>

#include <unwindstack/MachineArm.h>
#include <unwindstack/MachineArm64.h>
#include <unwindstack/MachineX86.h>
#include <unwindstack/MachineX86_64.h>
#include <unwindstack/Maps.h>
#include <unwindstack/RegsArm.h>
#include <unwindstack/RegsArm64.h>
#include <unwindstack/RegsX86.h>
#include <unwindstack/RegsX86_64.h>
#include <unwindstack/Unwinder.h>

#include "MemoryOffline.h"

namespace unwindstack {

std::string GetOfflineFilesDirectory();

std::string DumpFrames(const Unwinder& unwinder);

bool AddMemory(std::string file_name, MemoryOfflineParts* parts, std::string& error_msg);

class OfflineUnwindUtils {
 protected:
  bool Init(const std::string& offline_files_dir, ArchEnum arch, std::string& error_msg,
            bool add_stack = true, bool set_maps = true);

  bool ResetMaps(std::string& error_msg);

  bool SetProcessMemory(std::string& error_msg);

  bool SetJitProcessMemory(std::string& error_msg);

  bool SetRegs(ArchEnum arch, std::string& error_msg);

  template <typename AddressType>
  bool ReadRegs(RegsImpl<AddressType>* regs,
                const std::unordered_map<std::string, uint32_t>& name_to_reg,
                std::string& error_msg);

  static std::unordered_map<std::string, uint32_t> arm_regs_;
  static std::unordered_map<std::string, uint32_t> arm64_regs_;
  static std::unordered_map<std::string, uint32_t> x86_regs_;
  static std::unordered_map<std::string, uint32_t> x86_64_regs_;

  std::string cwd_;
  std::string offline_dir_;
  std::string map_buffer;
  std::unique_ptr<Regs> regs_;
  std::unique_ptr<Maps> maps_;
  std::shared_ptr<Memory> process_memory_;
};

}  // namespace unwindstack

#endif  // _LIBUNWINDSTACK_UTILS_OFFLINE_UNWIND_UTILS_H
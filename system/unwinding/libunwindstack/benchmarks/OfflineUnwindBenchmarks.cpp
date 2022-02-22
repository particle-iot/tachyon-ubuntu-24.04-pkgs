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

#include <cstddef>
#include <cstdint>
#include <filesystem>
#include <sstream>

#include <benchmark/benchmark.h>

#include <unwindstack/Unwinder.h>

#include "Utils.h"
#include "utils/OfflineUnwindUtils.h"

namespace unwindstack {

class OfflineUnwindBenchmark : public OfflineUnwindUtils, public benchmark::Fixture {
 public:
  void TearDown(benchmark::State& state) override {
    std::filesystem::current_path(cwd_);
    mem_tracker_.SetBenchmarkCounters(state);
  }
 protected:
  MemoryTracker mem_tracker_;
};

static void VerifyFrames(const Unwinder unwinder, const std::string& expected_frame_info,
                         std::stringstream& err_stream, benchmark::State& state) {
  std::string frame_info(DumpFrames(unwinder));
  if (frame_info != expected_frame_info) {
    if (err_stream.rdbuf()->in_avail() == 0) {
      err_stream << "Failed to unwind properly. ";
    }
    err_stream << "Unwinder contained frames:\n"
               << frame_info << "\nExpected frames:\n"
               << expected_frame_info;
    state.SkipWithError(err_stream.str().c_str());
  }
}

BENCHMARK_F(OfflineUnwindBenchmark, BM_offline_straddle_arm64)(benchmark::State& state) {
  std::string error_msg;
  if (!Init("straddle_arm64/", ARCH_ARM64, error_msg,
            /*add_stack=*/true, /*set_maps=*/false)) {
    state.SkipWithError(error_msg.c_str());
    return;
  }

  Unwinder unwinder(0, nullptr, nullptr);
  std::stringstream err_stream;
  for (auto _ : state) {
    state.PauseTiming();
    // Need to init unwinder with new copy of regs each iteration because unwinding changes
    // the attributes of the regs object.
    std::unique_ptr<Regs> regs_copy(regs_->Clone());
    // Ensure unwinder does not used cached map data in next iteration
    if (!ResetMaps(error_msg)) {
      state.SkipWithError(error_msg.c_str());
      return;
    }

    mem_tracker_.StartTrackingAllocations();
    state.ResumeTiming();

    unwinder = Unwinder(128, maps_.get(), regs_copy.get(), process_memory_);
    unwinder.Unwind();

    state.PauseTiming();
    mem_tracker_.StopTrackingAllocations();
    if (unwinder.NumFrames() != 6U) {
      err_stream << "Failed to unwind properly.Expected 6 frames, but unwinder contained "
                 << unwinder.NumFrames() << " frames.\n";
      break;
    }
    state.ResumeTiming();
  }

  std::string expected_frame_info =
      "  #00 pc 0000000000429fd8  libunwindstack_test (SignalInnerFunction+24)\n"
      "  #01 pc 000000000042a078  libunwindstack_test (SignalMiddleFunction+8)\n"
      "  #02 pc 000000000042a08c  libunwindstack_test (SignalOuterFunction+8)\n"
      "  #03 pc 000000000042d8fc  libunwindstack_test "
      "(unwindstack::RemoteThroughSignal(int, unsigned int)+20)\n"
      "  #04 pc 000000000042d8d8  libunwindstack_test "
      "(unwindstack::UnwindTest_remote_through_signal_Test::TestBody()+32)\n"
      "  #05 pc 0000000000455d70  libunwindstack_test (testing::Test::Run()+392)\n";
  VerifyFrames(unwinder, expected_frame_info, err_stream, state);
}

BENCHMARK_F(OfflineUnwindBenchmark, BM_offline_straddle_arm64_cached_maps)
(benchmark::State& state) {
  std::string error_msg;
  // Initialize maps in Init and do not reset unwinder's maps each time so the unwinder
  // uses the cached maps from the first iteration of the loop.
  if (!Init("straddle_arm64/", ARCH_ARM64, error_msg,
            /*add_stack=*/true, /*set_maps=*/true)) {
    state.SkipWithError(error_msg.c_str());
    return;
  }

  Unwinder unwinder(0, nullptr, nullptr);
  std::stringstream err_stream;
  for (auto _ : state) {
    state.PauseTiming();
    // Need to init unwinder with new copy of regs each iteration because unwinding changes
    // the attributes of the regs object.
    std::unique_ptr<Regs> regs_copy(regs_->Clone());

    mem_tracker_.StartTrackingAllocations();
    state.ResumeTiming();

    unwinder = Unwinder(128, maps_.get(), regs_copy.get(), process_memory_);
    unwinder.Unwind();

    state.PauseTiming();
    mem_tracker_.StopTrackingAllocations();
    if (unwinder.NumFrames() != 6U) {
      err_stream << "Failed to unwind properly. Expected 6 frames, but unwinder contained "
                 << unwinder.NumFrames() << " frames.\n";
      break;
    }
    state.ResumeTiming();
  }

  std::string expected_frame_info =
      "  #00 pc 0000000000429fd8  libunwindstack_test (SignalInnerFunction+24)\n"
      "  #01 pc 000000000042a078  libunwindstack_test (SignalMiddleFunction+8)\n"
      "  #02 pc 000000000042a08c  libunwindstack_test (SignalOuterFunction+8)\n"
      "  #03 pc 000000000042d8fc  libunwindstack_test "
      "(unwindstack::RemoteThroughSignal(int, unsigned int)+20)\n"
      "  #04 pc 000000000042d8d8  libunwindstack_test "
      "(unwindstack::UnwindTest_remote_through_signal_Test::TestBody()+32)\n"
      "  #05 pc 0000000000455d70  libunwindstack_test (testing::Test::Run()+392)\n";
  VerifyFrames(unwinder, expected_frame_info, err_stream, state);
}

BENCHMARK_F(OfflineUnwindBenchmark, BM_offline_jit_debug_x86)(benchmark::State& state) {
  std::string error_msg;
  if (!Init("jit_debug_x86/", ARCH_X86, error_msg,
            /*add_stack=*/true, /*set_maps=*/false)) {
    state.SkipWithError(error_msg.c_str());
    return;
  }

  if (!SetJitProcessMemory(error_msg)) {
    state.SkipWithError(error_msg.c_str());
    return;
  }

  Unwinder unwinder(0, nullptr, nullptr);
  std::stringstream err_stream;
  for (auto _ : state) {
    state.PauseTiming();
    std::unique_ptr<Regs> regs_copy(regs_->Clone());
    if (!ResetMaps(error_msg)) {
      state.SkipWithError(error_msg.c_str());
      return;
    }

    mem_tracker_.StartTrackingAllocations();
    state.ResumeTiming();

    std::unique_ptr<JitDebug> jit_debug = CreateJitDebug(regs_copy->Arch(), process_memory_);
    unwinder = Unwinder(128, maps_.get(), regs_copy.get(), process_memory_);
    unwinder.SetJitDebug(jit_debug.get());
    unwinder.Unwind();

    state.PauseTiming();
    mem_tracker_.StopTrackingAllocations();

    if (unwinder.NumFrames() != 69U) {
      err_stream << "Failed to unwind properly. Expected 6 frames, but unwinder contained "
                 << unwinder.NumFrames() << " frames.\n";
      break;
    }
    state.ResumeTiming();
  }

  std::string expected_frame_info =
      "  #00 pc 00068fb8  libarttestd.so (art::CauseSegfault()+72)\n"
      "  #01 pc 00067f00  libarttestd.so (Java_Main_unwindInProcess+10032)\n"
      "  #02 pc 000021a8  137-cfi.odex (boolean Main.unwindInProcess(boolean, int, "
      "boolean)+136)\n"
      "  #03 pc 0000fe80  anonymous:ee74c000 (boolean Main.bar(boolean)+64)\n"
      "  #04 pc 006ad4d2  libartd.so (art_quick_invoke_stub+338)\n"
      "  #05 pc 00146ab5  libartd.so "
      "(art::ArtMethod::Invoke(art::Thread*, unsigned int*, unsigned int, art::JValue*, char "
      "const*)+885)\n"
      "  #06 pc 0039cf0d  libartd.so "
      "(art::interpreter::ArtInterpreterToCompiledCodeBridge(art::Thread*, art::ArtMethod*, "
      "art::ShadowFrame*, unsigned short, art::JValue*)+653)\n"
      "  #07 pc 00392552  libartd.so "
      "(art::interpreter::Execute(art::Thread*, art::CodeItemDataAccessor const&, "
      "art::ShadowFrame&, art::JValue, bool)+354)\n"
      "  #08 pc 0039399a  libartd.so "
      "(art::interpreter::EnterInterpreterFromEntryPoint(art::Thread*, art::CodeItemDataAccessor "
      "const&, art::ShadowFrame*)+234)\n"
      "  #09 pc 00684362  libartd.so (artQuickToInterpreterBridge+1058)\n"
      "  #10 pc 006b35bd  libartd.so (art_quick_to_interpreter_bridge+77)\n"
      "  #11 pc 0000fe03  anonymous:ee74c000 (int Main.compare(Main, Main)+51)\n"
      "  #12 pc 006ad4d2  libartd.so (art_quick_invoke_stub+338)\n"
      "  #13 pc 00146ab5  libartd.so "
      "(art::ArtMethod::Invoke(art::Thread*, unsigned int*, unsigned int, art::JValue*, char "
      "const*)+885)\n"
      "  #14 pc 0039cf0d  libartd.so "
      "(art::interpreter::ArtInterpreterToCompiledCodeBridge(art::Thread*, art::ArtMethod*, "
      "art::ShadowFrame*, unsigned short, art::JValue*)+653)\n"
      "  #15 pc 00392552  libartd.so "
      "(art::interpreter::Execute(art::Thread*, art::CodeItemDataAccessor const&, "
      "art::ShadowFrame&, art::JValue, bool)+354)\n"
      "  #16 pc 0039399a  libartd.so "
      "(art::interpreter::EnterInterpreterFromEntryPoint(art::Thread*, art::CodeItemDataAccessor "
      "const&, art::ShadowFrame*)+234)\n"
      "  #17 pc 00684362  libartd.so (artQuickToInterpreterBridge+1058)\n"
      "  #18 pc 006b35bd  libartd.so (art_quick_to_interpreter_bridge+77)\n"
      "  #19 pc 0000fd3b  anonymous:ee74c000 (int Main.compare(java.lang.Object, "
      "java.lang.Object)+107)\n"
      "  #20 pc 006ad4d2  libartd.so (art_quick_invoke_stub+338)\n"
      "  #21 pc 00146ab5  libartd.so "
      "(art::ArtMethod::Invoke(art::Thread*, unsigned int*, unsigned int, art::JValue*, char "
      "const*)+885)\n"
      "  #22 pc 0039cf0d  libartd.so "
      "(art::interpreter::ArtInterpreterToCompiledCodeBridge(art::Thread*, art::ArtMethod*, "
      "art::ShadowFrame*, unsigned short, art::JValue*)+653)\n"
      "  #23 pc 00392552  libartd.so "
      "(art::interpreter::Execute(art::Thread*, art::CodeItemDataAccessor const&, "
      "art::ShadowFrame&, art::JValue, bool)+354)\n"
      "  #24 pc 0039399a  libartd.so "
      "(art::interpreter::EnterInterpreterFromEntryPoint(art::Thread*, art::CodeItemDataAccessor "
      "const&, art::ShadowFrame*)+234)\n"
      "  #25 pc 00684362  libartd.so (artQuickToInterpreterBridge+1058)\n"
      "  #26 pc 006b35bd  libartd.so (art_quick_to_interpreter_bridge+77)\n"
      "  #27 pc 0000fbdb  anonymous:ee74c000 (int "
      "java.util.Arrays.binarySearch0(java.lang.Object[], int, int, java.lang.Object, "
      "java.util.Comparator)+331)\n"
      "  #28 pc 006ad6a2  libartd.so (art_quick_invoke_static_stub+418)\n"
      "  #29 pc 00146acb  libartd.so "
      "(art::ArtMethod::Invoke(art::Thread*, unsigned int*, unsigned int, art::JValue*, char "
      "const*)+907)\n"
      "  #30 pc 0039cf0d  libartd.so "
      "(art::interpreter::ArtInterpreterToCompiledCodeBridge(art::Thread*, art::ArtMethod*, "
      "art::ShadowFrame*, unsigned short, art::JValue*)+653)\n"
      "  #31 pc 00392552  libartd.so "
      "(art::interpreter::Execute(art::Thread*, art::CodeItemDataAccessor const&, "
      "art::ShadowFrame&, art::JValue, bool)+354)\n"
      "  #32 pc 0039399a  libartd.so "
      "(art::interpreter::EnterInterpreterFromEntryPoint(art::Thread*, art::CodeItemDataAccessor "
      "const&, art::ShadowFrame*)+234)\n"
      "  #33 pc 00684362  libartd.so (artQuickToInterpreterBridge+1058)\n"
      "  #34 pc 006b35bd  libartd.so (art_quick_to_interpreter_bridge+77)\n"
      "  #35 pc 0000f624  anonymous:ee74c000 (boolean Main.foo()+164)\n"
      "  #36 pc 006ad4d2  libartd.so (art_quick_invoke_stub+338)\n"
      "  #37 pc 00146ab5  libartd.so "
      "(art::ArtMethod::Invoke(art::Thread*, unsigned int*, unsigned int, art::JValue*, char "
      "const*)+885)\n"
      "  #38 pc 0039cf0d  libartd.so "
      "(art::interpreter::ArtInterpreterToCompiledCodeBridge(art::Thread*, art::ArtMethod*, "
      "art::ShadowFrame*, unsigned short, art::JValue*)+653)\n"
      "  #39 pc 00392552  libartd.so "
      "(art::interpreter::Execute(art::Thread*, art::CodeItemDataAccessor const&, "
      "art::ShadowFrame&, art::JValue, bool)+354)\n"
      "  #40 pc 0039399a  libartd.so "
      "(art::interpreter::EnterInterpreterFromEntryPoint(art::Thread*, art::CodeItemDataAccessor "
      "const&, art::ShadowFrame*)+234)\n"
      "  #41 pc 00684362  libartd.so (artQuickToInterpreterBridge+1058)\n"
      "  #42 pc 006b35bd  libartd.so (art_quick_to_interpreter_bridge+77)\n"
      "  #43 pc 0000eedb  anonymous:ee74c000 (void Main.runPrimary()+59)\n"
      "  #44 pc 006ad4d2  libartd.so (art_quick_invoke_stub+338)\n"
      "  #45 pc 00146ab5  libartd.so "
      "(art::ArtMethod::Invoke(art::Thread*, unsigned int*, unsigned int, art::JValue*, char "
      "const*)+885)\n"
      "  #46 pc 0039cf0d  libartd.so "
      "(art::interpreter::ArtInterpreterToCompiledCodeBridge(art::Thread*, art::ArtMethod*, "
      "art::ShadowFrame*, unsigned short, art::JValue*)+653)\n"
      "  #47 pc 00392552  libartd.so "
      "(art::interpreter::Execute(art::Thread*, art::CodeItemDataAccessor const&, "
      "art::ShadowFrame&, art::JValue, bool)+354)\n"
      "  #48 pc 0039399a  libartd.so "
      "(art::interpreter::EnterInterpreterFromEntryPoint(art::Thread*, art::CodeItemDataAccessor "
      "const&, art::ShadowFrame*)+234)\n"
      "  #49 pc 00684362  libartd.so (artQuickToInterpreterBridge+1058)\n"
      "  #50 pc 006b35bd  libartd.so (art_quick_to_interpreter_bridge+77)\n"
      "  #51 pc 0000ac21  anonymous:ee74c000 (void Main.main(java.lang.String[])+97)\n"
      "  #52 pc 006ad6a2  libartd.so (art_quick_invoke_static_stub+418)\n"
      "  #53 pc 00146acb  libartd.so "
      "(art::ArtMethod::Invoke(art::Thread*, unsigned int*, unsigned int, art::JValue*, char "
      "const*)+907)\n"
      "  #54 pc 0039cf0d  libartd.so "
      "(art::interpreter::ArtInterpreterToCompiledCodeBridge(art::Thread*, art::ArtMethod*, "
      "art::ShadowFrame*, unsigned short, art::JValue*)+653)\n"
      "  #55 pc 00392552  libartd.so "
      "(art::interpreter::Execute(art::Thread*, art::CodeItemDataAccessor const&, "
      "art::ShadowFrame&, art::JValue, bool)+354)\n"
      "  #56 pc 0039399a  libartd.so "
      "(art::interpreter::EnterInterpreterFromEntryPoint(art::Thread*, art::CodeItemDataAccessor "
      "const&, art::ShadowFrame*)+234)\n"
      "  #57 pc 00684362  libartd.so (artQuickToInterpreterBridge+1058)\n"
      "  #58 pc 006b35bd  libartd.so (art_quick_to_interpreter_bridge+77)\n"
      "  #59 pc 006ad6a2  libartd.so (art_quick_invoke_static_stub+418)\n"
      "  #60 pc 00146acb  libartd.so "
      "(art::ArtMethod::Invoke(art::Thread*, unsigned int*, unsigned int, art::JValue*, char "
      "const*)+907)\n"
      "  #61 pc 005aac95  libartd.so "
      "(art::InvokeWithArgArray(art::ScopedObjectAccessAlreadyRunnable const&, art::ArtMethod*, "
      "art::ArgArray*, art::JValue*, char const*)+85)\n"
      "  #62 pc 005aab5a  libartd.so "
      "(art::InvokeWithVarArgs(art::ScopedObjectAccessAlreadyRunnable const&, _jobject*, "
      "_jmethodID*, char*)+362)\n"
      "  #63 pc 0048a3dd  libartd.so "
      "(art::JNI::CallStaticVoidMethodV(_JNIEnv*, _jclass*, _jmethodID*, char*)+125)\n"
      "  #64 pc 0018448c  libartd.so "
      "(art::CheckJNI::CallMethodV(char const*, _JNIEnv*, _jobject*, _jclass*, _jmethodID*, char*, "
      "art::Primitive::Type, art::InvokeType)+1964)\n"
      "  #65 pc 0017cf06  libartd.so "
      "(art::CheckJNI::CallStaticVoidMethodV(_JNIEnv*, _jclass*, _jmethodID*, char*)+70)\n"
      "  #66 pc 00001d8c  dalvikvm32 "
      "(_JNIEnv::CallStaticVoidMethod(_jclass*, _jmethodID*, ...)+60)\n"
      "  #67 pc 00001a80  dalvikvm32 (main+1312)\n"
      "  #68 pc 00018275  libc.so\n";
  VerifyFrames(unwinder, expected_frame_info, err_stream, state);
}

}  // namespace unwindstack

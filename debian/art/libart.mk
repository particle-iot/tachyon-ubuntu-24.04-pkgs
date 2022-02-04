NAME = libart

SOURCES_runtime = \
  aot_class_linker.cc \
  art_field.cc \
  art_method.cc \
  backtrace_helper.cc \
  barrier.cc \
  base/locks.cc \
  base/mem_map_arena_pool.cc \
  base/mutex.cc \
  base/quasi_atomic.cc \
  base/timing_logger.cc \
  cha.cc \
  class_linker.cc \
  class_loader_context.cc \
  class_root.cc \
  class_table.cc \
  common_throws.cc \
  compiler_filter.cc \
  debug_print.cc \
  debugger.cc \
  dex/dex_file_annotations.cc \
  dex_register_location.cc \
  dex_to_dex_decompiler.cc \
  elf_file.cc \
  exec_utils.cc \
  fault_handler.cc \
  gc/allocation_record.cc \
  gc/allocator/dlmalloc.cc \
  gc/allocator/rosalloc.cc \
  gc/accounting/bitmap.cc \
  gc/accounting/card_table.cc \
  gc/accounting/heap_bitmap.cc \
  gc/accounting/mod_union_table.cc \
  gc/accounting/remembered_set.cc \
  gc/accounting/space_bitmap.cc \
  gc/collector/concurrent_copying.cc \
  gc/collector/garbage_collector.cc \
  gc/collector/immune_region.cc \
  gc/collector/immune_spaces.cc \
  gc/collector/mark_sweep.cc \
  gc/collector/partial_mark_sweep.cc \
  gc/collector/semi_space.cc \
  gc/collector/sticky_mark_sweep.cc \
  gc/gc_cause.cc \
  gc/heap.cc \
  gc/reference_processor.cc \
  gc/reference_queue.cc \
  gc/scoped_gc_critical_section.cc \
  gc/space/bump_pointer_space.cc \
  gc/space/dlmalloc_space.cc \
  gc/space/image_space.cc \
  gc/space/large_object_space.cc \
  gc/space/malloc_space.cc \
  gc/space/region_space.cc \
  gc/space/rosalloc_space.cc \
  gc/space/space.cc \
  gc/space/zygote_space.cc \
  gc/task_processor.cc \
  gc/verification.cc \
  hidden_api.cc \
  hidden_api_jni.cc \
  hprof/hprof.cc \
  image.cc \
  index_bss_mapping.cc \
  indirect_reference_table.cc \
  instrumentation.cc \
  intern_table.cc \
  interpreter/interpreter.cc \
  interpreter/interpreter_cache.cc \
  interpreter/interpreter_common.cc \
  interpreter/interpreter_intrinsics.cc \
  interpreter/interpreter_switch_impl0.cc \
  interpreter/interpreter_switch_impl1.cc \
  interpreter/interpreter_switch_impl2.cc \
  interpreter/interpreter_switch_impl3.cc \
  interpreter/lock_count_data.cc \
  interpreter/shadow_frame.cc \
  interpreter/unstarted_runtime.cc \
  java_frame_root_info.cc \
  jit/debugger_interface.cc \
  jit/jit.cc \
  jit/jit_code_cache.cc \
  jit/jit_memory_region.cc \
  jit/profiling_info.cc \
  jit/profile_saver.cc \
  jni/check_jni.cc \
  jni/java_vm_ext.cc \
  jni/jni_env_ext.cc \
  jni/jni_id_manager.cc \
  jni/jni_internal.cc \
  linear_alloc.cc \
  managed_stack.cc \
  method_handles.cc \
  mirror/array.cc \
  mirror/class.cc \
  mirror/class_ext.cc \
  mirror/dex_cache.cc \
  mirror/emulated_stack_frame.cc \
  mirror/executable.cc \
  mirror/field.cc \
  mirror/method.cc \
  mirror/method_handle_impl.cc \
  mirror/method_handles_lookup.cc \
  mirror/method_type.cc \
  mirror/object.cc \
  mirror/stack_trace_element.cc \
  mirror/string.cc \
  mirror/throwable.cc \
  mirror/var_handle.cc \
  monitor.cc \
  monitor_objects_stack_visitor.cc \
  native_bridge_art_interface.cc \
  native_stack_dump.cc \
  native/dalvik_system_DexFile.cc \
  native/dalvik_system_BaseDexClassLoader.cc \
  native/dalvik_system_VMDebug.cc \
  native/dalvik_system_VMRuntime.cc \
  native/dalvik_system_VMStack.cc \
  native/dalvik_system_ZygoteHooks.cc \
  native/java_lang_Class.cc \
  native/java_lang_Object.cc \
  native/java_lang_String.cc \
  native/java_lang_StringFactory.cc \
  native/java_lang_System.cc \
  native/java_lang_Thread.cc \
  native/java_lang_Throwable.cc \
  native/java_lang_VMClassLoader.cc \
  native/java_lang_invoke_MethodHandleImpl.cc \
  native/java_lang_ref_FinalizerReference.cc \
  native/java_lang_ref_Reference.cc \
  native/java_lang_reflect_Array.cc \
  native/java_lang_reflect_Constructor.cc \
  native/java_lang_reflect_Executable.cc \
  native/java_lang_reflect_Field.cc \
  native/java_lang_reflect_Method.cc \
  native/java_lang_reflect_Parameter.cc \
  native/java_lang_reflect_Proxy.cc \
  native/java_util_concurrent_atomic_AtomicLong.cc \
  native/libcore_util_CharsetUtils.cc \
  native/org_apache_harmony_dalvik_ddmc_DdmServer.cc \
  native/org_apache_harmony_dalvik_ddmc_DdmVmInternal.cc \
  native/sun_misc_Unsafe.cc \
  non_debuggable_classes.cc \
  nterp_helpers.cc \
  oat.cc \
  oat_file.cc \
  oat_file_assistant.cc \
  oat_file_manager.cc \
  oat_quick_method_header.cc \
  object_lock.cc \
  offsets.cc \
  parsed_options.cc \
  plugin.cc \
  quick_exception_handler.cc \
  read_barrier.cc \
  reference_table.cc \
  reflection.cc \
  reflective_handle_scope.cc \
  reflective_value_visitor.cc \
  runtime.cc \
  runtime_callbacks.cc \
  runtime_common.cc \
  runtime_intrinsics.cc \
  runtime_options.cc \
  scoped_thread_state_change.cc \
  signal_catcher.cc \
  stack.cc \
  stack_map.cc \
  string_builder_append.cc \
  thread.cc \
  thread_list.cc \
  thread_pool.cc \
  ti/agent.cc \
  trace.cc \
  transaction.cc \
  var_handles.cc \
  vdex_file.cc \
  verifier/class_verifier.cc \
  verifier/instruction_flags.cc \
  verifier/method_verifier.cc \
  verifier/reg_type.cc \
  verifier/reg_type_cache.cc \
  verifier/register_line.cc \
  verifier/verifier_deps.cc \
  verify_object.cc \
  well_known_classes.cc \
  \
  arch/context.cc \
  arch/instruction_set_features.cc \
  arch/memcmp16.cc \
  arch/arm/instruction_set_features_arm.cc \
  arch/arm/registers_arm.cc \
  arch/arm64/instruction_set_features_arm64.cc \
  arch/arm64/registers_arm64.cc \
  arch/mips/instruction_set_features_mips.cc \
  arch/mips/registers_mips.cc \
  arch/mips64/instruction_set_features_mips64.cc \
  arch/mips64/registers_mips64.cc \
  arch/x86/instruction_set_features_x86.cc \
  arch/x86/registers_x86.cc \
  arch/x86_64/registers_x86_64.cc \
  entrypoints/entrypoint_utils.cc \
  entrypoints/jni/jni_entrypoints.cc \
  entrypoints/math_entrypoints.cc \
  entrypoints/quick/quick_alloc_entrypoints.cc \
  entrypoints/quick/quick_cast_entrypoints.cc \
  entrypoints/quick/quick_deoptimization_entrypoints.cc \
  entrypoints/quick/quick_dexcache_entrypoints.cc \
  entrypoints/quick/quick_entrypoints_enum.cc \
  entrypoints/quick/quick_field_entrypoints.cc \
  entrypoints/quick/quick_fillarray_entrypoints.cc \
  entrypoints/quick/quick_jni_entrypoints.cc \
  entrypoints/quick/quick_lock_entrypoints.cc \
  entrypoints/quick/quick_math_entrypoints.cc \
  entrypoints/quick/quick_string_builder_append_entrypoints.cc \
  entrypoints/quick/quick_thread_entrypoints.cc \
  entrypoints/quick/quick_throw_entrypoints.cc \
  entrypoints/quick/quick_trampoline_entrypoints.cc \

# Sources for a host library
SOURCES_runtime += \
  monitor_linux.cc \
  runtime_linux.cc \
  thread_linux.cc \

# Architecture specific sources, which come from runtime/Android.bp
SOURCES_runtime_arm = \
  interpreter/mterp/mterp.cc \
  interpreter/mterp/nterp_stub.cc \
  arch/arm/context_arm.cc \
  arch/arm/entrypoints_init_arm.cc \
  arch/arm/instruction_set_features_assembly_tests.S \
  arch/arm/jni_entrypoints_arm.S \
  arch/arm/memcmp16_arm.S \
  arch/arm/quick_entrypoints_arm.S \
  arch/arm/quick_entrypoints_cc_arm.cc \
  arch/arm/thread_arm.cc \
  arch/arm/fault_handler_arm.cc \

SOURCES_runtime_arm64 = \
  interpreter/mterp/mterp.cc \
  interpreter/mterp/nterp_stub.cc \
  arch/arm64/context_arm64.cc \
  arch/arm64/entrypoints_init_arm64.cc \
  arch/arm64/jni_entrypoints_arm64.S \
  arch/arm64/memcmp16_arm64.S \
  arch/arm64/quick_entrypoints_arm64.S \
  arch/arm64/thread_arm64.cc \
  monitor_pool.cc \
  arch/arm64/fault_handler_arm64.cc \

SOURCES_runtime_x86 = \
  interpreter/mterp/mterp.cc \
  interpreter/mterp/nterp_stub.cc \
  arch/x86/context_x86.cc \
  arch/x86/entrypoints_init_x86.cc \
  arch/x86/jni_entrypoints_x86.S \
  arch/x86/memcmp16_x86.S \
  arch/x86/quick_entrypoints_x86.S \
  arch/x86/thread_x86.cc \
  arch/x86/fault_handler_x86.cc \

SOURCES_runtime_x86_64 = \
  interpreter/mterp/mterp.cc \
  interpreter/mterp/nterp_stub.cc \
  arch/x86_64/context_x86_64.cc \
  arch/x86_64/entrypoints_init_x86_64.cc \
  arch/x86_64/jni_entrypoints_x86_64.S \
  arch/x86_64/memcmp16_x86_64.S \
  arch/x86_64/quick_entrypoints_x86_64.S \
  arch/x86_64/thread_x86_64.cc \
  monitor_pool.cc \
  arch/x86/fault_handler_x86.cc \

SOURCES_runtime_mips = \
  interpreter/mterp/mterp.cc \
  interpreter/mterp/nterp_stub.cc \
  arch/mips/context_mips.cc \
  arch/mips/entrypoints_init_mips.cc \
  arch/mips/jni_entrypoints_mips.S \
  arch/mips/memcmp16_mips.S \
  arch/mips/quick_entrypoints_mips.S \
  arch/mips/thread_mips.cc \
  arch/mips/fault_handler_mips.cc \

SOURCES_runtime_mips64 = \
  interpreter/mterp/mterp.cc \
  interpreter/mterp/nterp_stub.cc \
  arch/mips64/context_mips64.cc \
  arch/mips64/entrypoints_init_mips64.cc \
  arch/mips64/jni_entrypoints_mips64.S \
  arch/mips64/memcmp16_mips64.S \
  arch/mips64/quick_entrypoints_mips64.S \
  arch/mips64/thread_mips64.cc \
  monitor_pool.cc \
  arch/mips64/fault_handler_mips64.cc \


include debian/art/detect-arch.mk
SOURCES_runtime += $(SOURCES_runtime_$(CPU))

# From libartbase/Android.bp
SOURCES_libartbase = \
  arch/instruction_set.cc \
  base/allocator.cc \
  base/arena_allocator.cc \
  base/arena_bit_vector.cc \
  base/bit_vector.cc \
  base/enums.cc \
  base/file_magic.cc \
  base/file_utils.cc \
  base/hex_dump.cc \
  base/hiddenapi_flags.cc \
  base/logging.cc \
  base/malloc_arena_pool.cc \
  base/membarrier.cc \
  base/memfd.cc \
  base/memory_region.cc \
  base/mem_map.cc \
  base/os_linux.cc \
  base/runtime_debug.cc \
  base/safe_copy.cc \
  base/scoped_arena_allocator.cc \
  base/scoped_flock.cc \
  base/socket_peer_is_trusted.cc \
  base/time_utils.cc \
  base/unix_file/fd_file.cc \
  base/unix_file/random_access_file_utils.cc \
  base/utils.cc \
  base/zip_archive.cc \
  base/mem_map_unix.cc \

# From libdexfile/Android.bp
SOURCES_libdexfile = \
  dex/art_dex_file_loader.cc \
  dex/compact_dex_file.cc \
  dex/compact_offset_table.cc \
  dex/descriptors_names.cc \
  dex/dex_file.cc \
  dex/dex_file_exception_helpers.cc \
  dex/dex_file_layout.cc \
  dex/dex_file_loader.cc \
  dex/dex_file_tracking_registrar.cc \
  dex/dex_file_verifier.cc \
  dex/dex_instruction.cc \
  dex/modifiers.cc \
  dex/primitive.cc \
  dex/signature.cc \
  dex/standard_dex_file.cc \
  dex/type_lookup_table.cc \
  dex/utf.cc \
  external/dex_file_ext.cc \
  external/dex_file_supp.cc \

SOURCES := $(foreach source, $(SOURCES_libartbase), art/libartbase/$(source)) \
           $(foreach source, $(SOURCES_libdexfile), art/libdexfile/$(source)) \
           $(foreach source, $(SOURCES_runtime), art/runtime/$(source)) \
           art/libartpalette/system/palette_fake.cc \
           art/libprofile/profile/profile_boot_info.cc \
           art/libprofile/profile/profile_compilation_info.cc \


# Add generated operator_out.cc and mterp.S
SOURCES += \
  debian/out/art/operator_out.cc \
  debian/out/art/mterp.S

# from runtime/Android.bp
SOURCES_OPERATOR = \
  base/callee_save_type.h \
  base/locks.h \
  class_loader_context.h \
  class_status.h \
  debugger.h \
  gc_root.h \
  gc/allocator_type.h \
  gc/allocator/rosalloc.h \
  gc/collector_type.h \
  gc/collector/gc_type.h \
  gc/heap.h \
  gc/space/region_space.h \
  gc/space/space.h \
  gc/weak_root_state.h \
  image.h \
  instrumentation.h \
  indirect_reference_table.h \
  jdwp_provider.h \
  jni_id_type.h \
  lock_word.h \
  oat_file.h \
  object_callbacks.h \
  process_state.h \
  reflective_value_visitor.h \
  stack.h \
  suspend_reason.h \
  thread.h \
  thread_state.h \
  ti/agent.h \
  trace.h \
  verifier/verifier_enums.h \

SOURCES_OPERATOR := $(foreach source, $(SOURCES_OPERATOR), runtime/$(source))

# from libartbase/Android.bp, and libdexfile/Android.bp
SOURCES_OPERATOR += \
  libartbase/arch/instruction_set.h \
  libartbase/base/allocator.h \
  libartbase/base/unix_file/fd_file.h \
  \
  libdexfile/dex/dex_file.h \
  libdexfile/dex/dex_file_layout.h \
  libdexfile/dex/dex_instruction.h \
  libdexfile/dex/dex_instruction_utils.h \
  libdexfile/dex/invoke_type.h \
  libdexfile/dex/method_reference.h \

SOURCES_OPERATOR := $(foreach source, $(SOURCES_OPERATOR), art/$(source))

# If directly compile all sources together, it will take a huge amount of time
# and potentially huge amount of memory. Not good for devel-time.
# On the other hand, individual compiling every source allows incremental
# compilation and multi-thread accelration.
SOURCES_CXX = $(filter %.cc,$(SOURCES))
OBJECTS_CXX = $(SOURCES_CXX:.cc=.o)
SOURCES_ASSEMBLY = $(filter %.S,$(SOURCES))
OBJECTS_ASSEMBLY = $(SOURCES_ASSEMBLY:.S=.o)

CFLAGS += \
  -fcommon \
  -fno-rtti \
  -fstrict-aliasing \
  -fvisibility=protected \

CXXFLAGS += -std=gnu++17 \
  -fno-omit-frame-pointer \
  -fno-rtti \
  -fstrict-aliasing \
  -fvisibility=protected \
  -Wa,--noexecstack \
  -Wno-invalid-offsetof \
  -Wno-invalid-partial-specialization \

CPPFLAGS += \
  -D__STDC_CONSTANT_MACROS \
  -D__STDC_FORMAT_MACROS \
  -D_FILE_OFFSET_BITS=64 \
  -D_LARGEFILE_SOURCE=1 \
  -DART_BASE_ADDRESS_MAX_DELTA=0x1000000 \
  -DART_BASE_ADDRESS_MIN_DELTA=-0x1000000 \
  -DART_BASE_ADDRESS=0x60000000 \
  -DART_DEFAULT_COMPACT_DEX_LEVEL=fast \
  -DART_DEFAULT_GC_TYPE_IS_CMS \
  -DART_ENABLE_ADDRESS_SANITIZER=1 \
  -DART_ENABLE_CODEGEN_${CPU} \
  -DART_FRAME_SIZE_LIMIT=1736 \
  -DART_READ_BARRIER_TYPE_IS_BAKER=1 \
  -DART_STACK_OVERFLOW_GAP_arm=8192 \
  -DART_STACK_OVERFLOW_GAP_arm64=8192 \
  -DART_STACK_OVERFLOW_GAP_mips=16384 \
  -DART_STACK_OVERFLOW_GAP_mips64=16384 \
  -DART_STACK_OVERFLOW_GAP_x86_64=8192 \
  -DART_STACK_OVERFLOW_GAP_x86=8192 \
  -DART_USE_READ_BARRIER=1 \
  -DBUILDING_LIBART=1 \
  -DIMT_SIZE=43 \
  -DUSE_D8_DESUGAR=1 \
  -I. \
  -I/usr/include/android \
  -Iart \
  -Ilibnativehelper/include_jni \
  -Iart/cmdline \
  -Iart/libartbase \
  -Iart/libartbase/arch \
  -Iart/libartpalette/include \
  -Iart/libdexfile \
  -Iart/libdexfile/external/include \
  -Iart/libelffile \
  -Iart/libnativebridge/include \
  -Iart/libnativeloader/include \
  -Iart/libprofile \
  -Iart/runtime \
  -Iart/sigchainlib \
  -Iart/tools/cpp-define-generator \
  -Idebian/out/art \
  -Ilibnativehelper/header_only_include \
  -Ilibnativehelper/include \
  -Ilibnativehelper/include_jni \
  -Ilibnativehelper/platform_include \
  -Isystem/core/base/include \
  -Isystem/core/libbacktrace/include \
  -Isystem/core/liblog/include \
  -Isystem/core/libunwindstack/include \
  -Isystem/core/libziparchive/include \
  -Umips \

CC_ASSEMBLY = clang
ifeq ($(CPU),arm)
  # Clang does not support the `ADRL` instruction. See <https://bugs.llvm.org/show_bug.cgi?id=24350>
  CC_ASSEMBLY = gcc
endif

debian/out/art/$(NAME).a: $(OBJECTS_CXX) $(OBJECTS_ASSEMBLY)
	mkdir --parents debian/out/art
	ar -rcs $@ $^

$(OBJECTS_CXX): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

$(OBJECTS_ASSEMBLY): %.o: %.S
	$(CC_ASSEMBLY) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

debian/out/art/operator_out.cc: $(SOURCES_OPERATOR)
	mkdir --parents debian/out/art
	python3 art/tools/generate_operator_out.py art/libartbase $^ > $@

debian/out/art/mterp.S: art/runtime/interpreter/mterp/$(CPU)/*.S
	mkdir --parents debian/out/art
	python3 art/runtime/interpreter/mterp/gen_mterp.py $@ $^

debian/out/art/asm_defines.h: debian/out/art/asm_defines.output
	mkdir --parents debian/out/art
	python3 art/tools/cpp-define-generator/make_header.py $^ > $@

debian/out/art/asm_defines.output: art/tools/cpp-define-generator/asm_defines.cc
	mkdir --parents debian/out/art
	$(CXX) -S -o $@ $^ $(CPPFLAGS) $(CXXFLAGS)

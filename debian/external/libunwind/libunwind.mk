include debian/art/detect-arch.mk

NAME = libunwind

ARCH_SOURCES = \
  is_fpreg.c \
  regname.c \
  Gcreate_addr_space.c \
  Gget_proc_info.c \
  Gget_save_loc.c \
  Gglobal.c \
  Ginit.c \
  Ginit_local.c \
  Ginit_remote.c \
  Gregs.c \
  Gresume.c \
  Gstep.c \
  Lcreate_addr_space.c \
  Lget_proc_info.c \
  Lget_save_loc.c \
  Lglobal.c \
  Linit.c \
  Linit_local.c \
  Linit_remote.c \
  Lregs.c \
  Lresume.c \
  Lstep.c \

arm_SOURCES = $(foreach source, $(ARCH_SOURCES), src/arm/$(source)) \
  src/arm/getcontext.S \
  src/arm/Gis_signal_frame.c \
  src/arm/Gex_tables.c \
  src/arm/Lis_signal_frame.c \
  src/arm/Lex_tables.c \
  src/elf32.c \

arm64_SOURCES = $(foreach source, $(ARCH_SOURCES), src/aarch64/$(source)) \
  src/aarch64/Gis_signal_frame.c \
  src/aarch64/Lis_signal_frame.c \
  src/elf64.c \

mips_SOURCES = $(foreach source, $(ARCH_SOURCES), src/mips/$(source)) \
  src/mips/getcontext-android.S \
  src/mips/Gis_signal_frame.c \
  src/mips/Lis_signal_frame.c \

mips64_SOURCES := $(mips_SOURCES) src/elf64.c
mips_SOURCES += src/elf32.c
x86_SOURCES = $(foreach source, $(ARCH_SOURCES), src/x86/$(source)) \
  src/x86/getcontext-linux.S \
  src/x86/Gos-linux.c \
  src/x86/Los-linux.c \
  src/elf32.c \

x86_64_SOURCES = $(foreach source, $(ARCH_SOURCES), src/x86_64/$(source)) \
  src/x86_64/getcontext.S \
  src/x86_64/Gstash_frame.c \
  src/x86_64/Gtrace.c \
  src/x86_64/Gos-linux.c \
  src/x86_64/Lstash_frame.c \
  src/x86_64/Ltrace.c \
  src/x86_64/Los-linux.c \
  src/x86_64/setcontext.S \
  src/elf64.c \

arm_INCLUDES = -Iexternal/libunwind/include/tdep-arm
arm64_INCLUDES = -Iexternal/libunwind/include/tdep-aarch64
mips_INCLUDES = -Iexternal/libunwind/include/tdep-mips
mips64_INCLUDES = $(mips_INCLUDES)
x86_INCLUDES = -Iexternal/libunwind/include/tdep-x86
x86_64_INCLUDES = -Iexternal/libunwind/include/tdep-x86_64

SOURCES = \
  src/mi/init.c \
  src/mi/flush_cache.c \
  src/mi/mempool.c \
  src/mi/strerror.c \
  src/mi/backtrace.c \
  src/mi/dyn-cancel.c \
  src/mi/dyn-info-list.c \
  src/mi/dyn-register.c \
  src/mi/map.c \
  src/mi/Lmap.c \
  src/mi/Ldyn-extract.c \
  src/mi/Lfind_dynamic_proc_info.c \
  src/mi/Lget_proc_info_by_ip.c \
  src/mi/Lget_proc_name.c \
  src/mi/Lput_dynamic_unwind_info.c \
  src/mi/Ldestroy_addr_space.c \
  src/mi/Lget_reg.c \
  src/mi/Lset_reg.c \
  src/mi/Lget_fpreg.c \
  src/mi/Lset_fpreg.c \
  src/mi/Lset_caching_policy.c \
  src/mi/Gdyn-extract.c \
  src/mi/Gdyn-remote.c \
  src/mi/Gfind_dynamic_proc_info.c \
  src/mi/Gget_accessors.c \
  src/mi/Gget_proc_info_by_ip.c \
  src/mi/Gget_proc_name.c \
  src/mi/Gput_dynamic_unwind_info.c \
  src/mi/Gdestroy_addr_space.c \
  src/mi/Gget_reg.c \
  src/mi/Gset_reg.c \
  src/mi/Gget_fpreg.c \
  src/mi/Gset_fpreg.c \
  src/mi/Gset_caching_policy.c \
  src/dwarf/Lexpr.c \
  src/dwarf/Lfde.c \
  src/dwarf/Lparser.c \
  src/dwarf/Lpe.c \
  src/dwarf/Lstep_dwarf.c \
  src/dwarf/Lfind_proc_info-lsb.c \
  src/dwarf/Lfind_unwind_table.c \
  src/dwarf/Gexpr.c \
  src/dwarf/Gfde.c \
  src/dwarf/Gfind_proc_info-lsb.c \
  src/dwarf/Gfind_unwind_table.c \
  src/dwarf/Gparser.c \
  src/dwarf/Gpe.c \
  src/dwarf/Gstep_dwarf.c \
  src/dwarf/global.c \
  src/os-common.c \
  src/os-linux.c \
  src/Los-common.c \
  src/ptrace/_UPT_accessors.c \
  src/ptrace/_UPT_access_fpreg.c \
  src/ptrace/_UPT_access_mem.c \
  src/ptrace/_UPT_access_reg.c \
  src/ptrace/_UPT_create.c \
  src/ptrace/_UPT_destroy.c \
  src/ptrace/_UPT_find_proc_info.c \
  src/ptrace/_UPT_get_dyn_info_list_addr.c \
  src/ptrace/_UPT_put_unwind_info.c \
  src/ptrace/_UPT_get_proc_name.c \
  src/ptrace/_UPT_reg_offset.c \
  src/ptrace/_UPT_resume.c \

SOURCES += $($(CPU)_SOURCES)
SOURCES := $(foreach source, $(SOURCES), external/libunwind/$(source))

SOURCES_C = $(filter %.c,$(SOURCES))
OBJECTS_C = $(SOURCES_C:.c=.o)
SOURCES_ASSEMBLY = $(filter %.S,$(SOURCES))
OBJECTS_ASSEMBLY = $(SOURCES_ASSEMBLY:.S=.o)

CFLAGS += -DHAVE_CONFIG_H -DNDEBUG -D_GNU_SOURCE -Werror -Wno-unused-parameter -fcommon -Wno-header-guard -Wno-absolute-value -Wno-inline-asm
CPPFLAGS += -Iexternal/libunwind/include -Iexternal/libunwind/src $($(CPU)_INCLUDES) -Idebian/include/external/libunwind/

debian/out/external/libunwind/$(NAME).a: $(OBJECTS_C) $(OBJECTS_ASSEMBLY)
	mkdir --parents debian/out/external/libunwind
	ar -rcs $@ $^

$(OBJECTS_C): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

$(OBJECTS_ASSEMBLY): %.o: %.S
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

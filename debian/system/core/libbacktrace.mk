include /usr/share/dpkg/architecture.mk

NAME = libbacktrace

libbacktrace_SOURCES = \
  Backtrace.cpp \
  BacktraceCurrent.cpp \
  BacktraceMap.cpp \
  BacktracePtrace.cpp \
  ThreadEntry.cpp \
  UnwindMap.cpp \
  UnwindStack.cpp \
  UnwindStackMap.cpp \

libunwindstack_SOURCES := \
  ArmExidx.cpp \
  DwarfCfa.cpp \
  DwarfEhFrameWithHdr.cpp \
  DwarfMemory.cpp \
  DwarfOp.cpp \
  DwarfSection.cpp \
  Elf.cpp \
  ElfInterface.cpp \
  ElfInterfaceArm.cpp \
  Global.cpp \
  JitDebug.cpp \
  Log.cpp \
  MapInfo.cpp \
  Maps.cpp \
  Memory.cpp \
  LocalUnwinder.cpp \
  Regs.cpp \
  RegsArm.cpp \
  RegsArm64.cpp \
  RegsX86.cpp \
  RegsX86_64.cpp \
  RegsMips.cpp \
  RegsMips64.cpp \
  Unwinder.cpp \
  Symbols.cpp \

# these might still be needed by libart/dexdump/dexlist
libunwindstack_dexfile_SOURCES := \
  DexFile.cpp \
  DexFiles.cpp \

ifeq ($(DEB_HOST_ARCH), amd64)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsX86_64.S
endif
ifeq ($(DEB_HOST_ARCH), i386)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsX86.S
endif
ifeq ($(DEB_HOST_ARCH), armel)
  # TODO port me!
endif
ifeq ($(DEB_HOST_ARCH), armhf)
  # TODO port me!
endif
ifeq ($(DEB_HOST_ARCH), arm64)
  # TODO port me!
endif
ifeq ($(DEB_HOST_ARCH), mipsel)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsMips.S
endif
ifeq ($(DEB_HOST_ARCH), mips64el)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsMips64.S
endif

SOURCES = \
  $(foreach source, $(filter %.cpp, $(libbacktrace_SOURCES)), libbacktrace/$(source)) \
  $(foreach source, $(filter %.cpp, $(libunwindstack_SOURCES)), libunwindstack/$(source)) \
  $(foreach source, $(filter %.cpp, $(libunwindstack_dexfile_SOURCES)), libunwindstack/$(source)) \

SOURCES := $(foreach source, $(SOURCES), system/core/$(source))
OBJECTS_CXX = $(SOURCES:.cpp=.o)
SOURCES_ASSEMBLY := $(foreach source, $(SOURCES_ASSEMBLY), system/core/$(source))
OBJECTS_ASSEMBLY := $(SOURCES_ASSEMBLY:.S=.o)

CXXFLAGS += -std=gnu++2a -fno-omit-frame-pointer
CPPFLAGS += \
  -I/usr/include/android \
  -I/usr/include/android/lzma \
  -Iart/libdexfile/external/include \
  -Iexternal/libunwind/include \
  -Idebian/include/external/libunwind \
  -Isystem/core/include \
  -Isystem/core/base/include \
  -Isystem/core/demangle/include \
  -Isystem/core/liblog/include \
  -Isystem/core/libprocinfo/include \
  -Isystem/core/libunwindstack/include \

debian/out/system/core/$(NAME).a: $(OBJECTS_CXX) $(OBJECTS_ASSEMBLY)
	mkdir --parents debian/out/system/core
	ar -rcs $@ $^

$(OBJECTS_CXX): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

$(OBJECTS_ASSEMBLY): %.o: %.S
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS) -D__ASSEMBLY__

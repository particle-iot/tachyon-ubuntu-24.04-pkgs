include /usr/share/dpkg/architecture.mk

NAME = libbacktrace

# system/unwinding/libbacktrace/Android.bp
libbacktrace_SOURCES = \
  Backtrace.cpp \
  BacktraceCurrent.cpp \
  BacktraceMap.cpp \
  BacktracePtrace.cpp \
  ThreadEntry.cpp \
  UnwindStack.cpp \
  UnwindStackMap.cpp \

# system/unwinding/libunwindstack/Android.bp
libunwindstack_SOURCES := \
  ArmExidx.cpp \
  DexFiles.cpp \
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
  MapInfo.cpp \
  Maps.cpp \
  Memory.cpp \
  MemoryMte.cpp \
  MemoryXz.cpp \
  LocalUnwinder.cpp \
  Regs.cpp \
  RegsArm.cpp \
  RegsArm64.cpp \
  RegsX86.cpp \
  RegsX86_64.cpp \
  RegsMips.cpp \
  RegsMips64.cpp \
  Symbols.cpp \
  ThreadEntry.cpp \
  ThreadUnwinder.cpp \
  Unwinder.cpp \
  \
  LogStdout.cpp \

ifeq ($(DEB_HOST_ARCH), amd64)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsX86_64.S
endif
ifeq ($(DEB_HOST_ARCH), i386)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsX86.S
endif

SOURCES = \
  $(foreach source, $(filter %.cpp, $(libbacktrace_SOURCES)), libbacktrace/$(source)) \
  $(foreach source, $(filter %.cpp, $(libunwindstack_SOURCES)), libunwindstack/$(source)) \

SOURCES := $(foreach source, $(SOURCES), system/unwinding/$(source))
OBJECTS_CXX = $(SOURCES:.cpp=.o)
SOURCES_ASSEMBLY := $(foreach source, $(SOURCES_ASSEMBLY), system/unwinding/$(source))
OBJECTS_ASSEMBLY := $(SOURCES_ASSEMBLY:.S=.o)

CXXFLAGS += -std=gnu++2a -fno-omit-frame-pointer
CPPFLAGS += \
  -Iexternal/lzma/C \
  -Isystem/libbase/include \
  -Isystem/libprocinfo/include \
  -Isystem/logging/liblog/include \
  -Isystem/unwinding/libbacktrace/include \
  -Isystem/unwinding/libunwindstack/include \

LDFLAGS += \
  -Ldebian/out/system \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -lbase \
  -llog \
  -lpthread \
  -shared

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifneq ($(filter armel mipsel,$(DEB_HOST_ARCH)),)
  LDFLAGS += -latomic
endif

build: $(OBJECTS_CXX) $(OBJECTS_ASSEMBLY)
	$(CXX) $^ -o debian/out/system/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/system/$(NAME).so

$(OBJECTS_CXX): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

$(OBJECTS_ASSEMBLY): %.o: %.S
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS) -D__ASSEMBLY__

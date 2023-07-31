include /usr/share/dpkg/architecture.mk

NAME = libbacktrace

# system/unwinding/libunwindstack/Android.bp
libunwindstack_SOURCES := \
  AndroidUnwinder.cpp \
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
  Regs.cpp \
  RegsArm.cpp \
  RegsArm64.cpp \
  RegsX86.cpp \
  RegsX86_64.cpp \
  RegsRiscv64.cpp \
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
else ifeq ($(DEB_HOST_ARCH), i386)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsX86.S
else ifeq ($(DEB_HOST_ARCH), mips64el)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsMips64.S
else ifeq ($(DEB_HOST_ARCH), mipsel)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsMips.S
endif

SOURCES = \
  $(foreach source, $(filter %.cpp, $(libunwindstack_SOURCES)), libunwindstack/$(source)) \

SOURCES := $(foreach source, $(SOURCES), system/unwinding/$(source))
OBJECTS_CXX = $(SOURCES:.cpp=.o)
SOURCES_ASSEMBLY := $(foreach source, $(SOURCES_ASSEMBLY), system/unwinding/$(source))
OBJECTS_ASSEMBLY := $(SOURCES_ASSEMBLY:.S=.o)

CXXFLAGS += -fno-omit-frame-pointer
CPPFLAGS += \
  -Iexternal/lzma/C \
  -Isystem/libbase/include \
  -Isystem/libprocinfo/include \
  -Isystem/logging/liblog/include \
  -Isystem/unwinding/libunwindstack/include \

LDFLAGS += \
  -Ldebian/out/external \
  -Ldebian/out/system \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -lbase \
  -llog \
  -llzma \
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

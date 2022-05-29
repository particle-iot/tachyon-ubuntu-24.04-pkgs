include /usr/share/dpkg/architecture.mk

NAME = libutils

SOURCES = \
  CallStack.cpp \
  FileMap.cpp \
  JenkinsHash.cpp \
  Looper.cpp \
  misc.cpp \
  NativeHandle.cpp \
  Printer.cpp \
  ProcessCallStack.cpp \
  RefBase.cpp \
  SharedBuffer.cpp \
  StopWatch.cpp \
  String16.cpp \
  String8.cpp \
  StrongPointer.cpp \
  SystemClock.cpp \
  Threads.cpp \
  Timers.cpp \
  Tokenizer.cpp \
  Unicode.cpp \
  VectorImpl.cpp \

SOURCES := $(foreach source, $(SOURCES), system/core/libutils/$(source))
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -DLIBUTILS_NATIVE=1 \
  -I/usr/include/android \
  -Isystem/core/cutils/include \
  -Isystem/core/include \
  -Isystem/core/libcutils/include \
  -Isystem/core/libprocessgroup/include \
  -Isystem/libbase/include \
  -Isystem/logging/liblog/include \
  -Isystem/unwinding/libbacktrace/include \

LDFLAGS += \
  -Ldebian/out/system/core \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -lbacktrace \
  -lcutils \
  -llog \
  -lpthread \
  -shared

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifneq ($(filter armel mipsel,$(DEB_HOST_ARCH)),)
  LDFLAGS += -latomic
endif

build: $(OBJECTS)
	$(CXX) $^ -o debian/out/system/core/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/system/core/$(NAME).so

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

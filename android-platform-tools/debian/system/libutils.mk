include /usr/share/dpkg/architecture.mk

NAME = libutils

# system/core/libutils/Android.bp
SOURCES = \
  FileMap.cpp \
  JenkinsHash.cpp \
  LightRefBase.cpp \
  NativeHandle.cpp \
  Printer.cpp \
  RefBase.cpp \
  SharedBuffer.cpp \
  StopWatch.cpp \
  String8.cpp \
  String16.cpp \
  StrongPointer.cpp \
  SystemClock.cpp \
  Threads.cpp \
  Timers.cpp \
  Tokenizer.cpp \
  Unicode.cpp \
  VectorImpl.cpp \
  misc.cpp \
  \
  Looper.cpp \
#  Errors.cpp \

SOURCES := $(foreach source, $(SOURCES), system/core/libutils/$(source))
SOURCES += system/incremental_delivery/incfs/util/map_ptr.cpp
OBJECTS = $(SOURCES:.cpp=.o)

CPPFLAGS += \
  -Isystem/core/cutils/include \
  -Isystem/core/include \
  -Isystem/core/libcutils/include \
  -Isystem/core/libprocessgroup/include \
  -Isystem/incremental_delivery/incfs/util/include \
  -Isystem/libbase/include \
  -Isystem/logging/liblog/include \

LDFLAGS += \
  -Ldebian/out/system \
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
	$(CXX) $^ -o debian/out/system/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/system/$(NAME).so

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

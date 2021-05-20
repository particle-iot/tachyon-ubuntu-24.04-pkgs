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
  PropertyMap.cpp \
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

CXXFLAGS += -std=gnu++17
CPPFLAGS += \
            -Isystem/core/include \
            -Isystem/core/base/include \
            -Isystem/core/cutils/include \
            -Isystem/core/libprocessgroup/include \
            -Isystem/core/libbacktrace/include \
            -Isystem/core/liblog/include \
            -Isystem/core/libcutils/include \
            -I/usr/include/android \
            -DLIBUTILS_NATIVE=1 \

debian/out/system/core/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/system/core
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

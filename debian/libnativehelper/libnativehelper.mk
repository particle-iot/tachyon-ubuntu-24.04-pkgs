NAME = libnativehelper

SOURCES = \
  JNIHelp.cpp \
  JniConstants.cpp \
  toStringArray.cpp \
  JniInvocation.cpp \

SOURCES := $(foreach source, $(SOURCES), libnativehelper/$(source))
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -std=c++17
CPPFLAGS += \
  -Ilibnativehelper/include_jni \
  -Ilibnativehelper/include \
  -Ilibnativehelper/header_only_include \
  -Ilibnativehelper/platform_include \
  -I/usr/include/android \
  -Isystem/core/liblog/include \
  -Isystem/core/base/include \

debian/out/libnativehelper/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/libnativehelper
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

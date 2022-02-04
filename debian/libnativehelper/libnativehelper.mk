NAME = libnativehelper

SOURCES = \
  JNIHelp.cpp \
  JniConstants.cpp \
  toStringArray.cpp \
  JniInvocation.cpp \

SOURCES := $(foreach source, $(SOURCES), libnativehelper/$(source))
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -I/usr/include/android \
  -Ilibnativehelper/header_only_include \
  -Ilibnativehelper/include \
  -Ilibnativehelper/include_jni \
  -Ilibnativehelper/platform_include \
  -Isystem/core/base/include \
  -Isystem/core/liblog/include \

debian/out/libnativehelper/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/libnativehelper
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

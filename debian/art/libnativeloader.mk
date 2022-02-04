NAME = libnativeloader

SOURCES = art/libnativeloader/native_loader.cpp
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -I/usr/include/android \
  -Iart/libnativebridge/include \
  -Iart/libnativeloader/include \
  -Ilibnativehelper/header_only_include \
  -Ilibnativehelper/include \
  -Ilibnativehelper/include_jni \
  -Isystem/core/base/include \
  -Isystem/core/include \

debian/out/art/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/art
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

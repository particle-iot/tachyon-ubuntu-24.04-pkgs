NAME = libnativeloader

SOURCES = art/libnativeloader/native_loader.cpp
OBJECTS = $(SOURCES:.cpp=.o)

CPPFLAGS += \
  -I/usr/include/android \
  -Isystem/core/include \
  -Isystem/core/base/include \
  -Iart/libnativebridge/include \
  -Iart/libnativeloader/include \
  -Ilibnativehelper/include_jni \
  -Ilibnativehelper/include \
  -Ilibnativehelper/header_only_include \

CXXFLAGS += -std=gnu++2a

debian/out/art/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/art
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

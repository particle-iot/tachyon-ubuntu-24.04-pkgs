NAME = libnativebridge

SOURCES = art/libnativebridge/native_bridge.cc
OBJECTS = $(SOURCES:.cc=.o)

CPPFLAGS += \
  -I/usr/include/android \
  -Ilibnativehelper/include_jni \
  -Isystem/core/include \
  -Isystem/core/base/include \
  -Iart/libnativebridge/include \
  -Isystem/core/liblog/include \

CXXFLAGS += -std=gnu++2a

debian/out/art/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/art
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

NAME = libnativebridge

SOURCES = art/libnativebridge/native_bridge.cc
OBJECTS = $(SOURCES:.cc=.o)

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -I/usr/include/android \
  -Iart/libnativebridge/include \
  -Ilibnativehelper/include_jni \
  -Isystem/core/include \
  -Isystem/libbase/include \
  -Isystem/logging/liblog/include \

debian/out/art/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/art
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

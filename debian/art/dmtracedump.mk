NAME = dmtracedump

SOURCES = art/tools/dmtracedump/tracedump.cc

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -I/usr/include/android \
  -Iart/tools/dmtracedump \
  -Umips \

debian/out/art/$(NAME): $(SOURCES)
	mkdir --parents debian/out/art
	$(CXX) -o $@ $^ $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)

NAME = dmtracedump

SOURCES = art/tools/dmtracedump/tracedump.cc

CPPFLAGS += -Iart/tools/dmtracedump -I/usr/include/android -Umips
CXXFLAGS += -pie

debian/out/art/$(NAME): $(SOURCES)
	mkdir --parents debian/out/art
	$(CXX) -o $@ $^ $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)

NAME = libsigchain

SOURCES = art/sigchainlib/sigchain.cc
OBJECTS = $(SOURCES:.cc=.o)

CPPFLAGS += -Iart/sigchainlib -I/usr/include/android -Umips
CXXFLAGS += -std=gnu++17

debian/out/art/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/art
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

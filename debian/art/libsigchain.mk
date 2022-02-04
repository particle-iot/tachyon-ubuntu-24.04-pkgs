NAME = libsigchain

SOURCES = art/sigchainlib/sigchain.cc
OBJECTS = $(SOURCES:.cc=.o)

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -I/usr/include/android \
  -Iart/sigchainlib \
  -Umips

debian/out/art/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/art
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

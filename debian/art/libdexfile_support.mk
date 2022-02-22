NAME = libdexfile_support

SOURCES = art/libdexfile/external/dex_file_supp.cc
OBJECTS = $(SOURCES:.cc=.o)

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -I/usr/include/android \
  -Iart/libartbase \
  -Iart/libdexfile \
  -Iart/libdexfile/external/include \
  -Isystem/libbase/include \
  -Isystem/logging/liblog/include \
  -Umips \

debian/out/art/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/art
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

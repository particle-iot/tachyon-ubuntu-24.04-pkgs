NAME = libziparchive

SOURCES = \
  zip_archive.cc \
  zip_archive_stream_entry.cc \
  zip_writer.cc \

SOURCES := $(foreach source, $(SOURCES), system/core/libziparchive/$(source))
OBJECTS = $(SOURCES:.cc=.o)

CXXFLAGS += -std=gnu++17
CPPFLAGS += \
  -DZLIB_CONST -D_FILE_OFFSET_BITS=64 \
  -Isystem/core/include \
  -Isystem/core/base/include \
  -Isystem/core/libziparchive/include \
  -Isystem/core/liblog/include \
  -I/usr/include/android \

debian/out/system/core/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/system/core
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

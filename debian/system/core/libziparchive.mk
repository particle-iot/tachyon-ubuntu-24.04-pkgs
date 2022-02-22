NAME = libziparchive

SOURCES = \
  zip_archive.cc \
  zip_archive_stream_entry.cc \
  zip_cd_entry_map.cc \
  zip_error.cpp \
  zip_writer.cc \

SOURCES := $(foreach source, $(SOURCES), system/libziparchive/$(source))
OBJECTS_CC = $(SOURCES:.cc=.o)
SOURCES_CPP = $(filter %.cpp,$(SOURCES))
OBJECTS_CPP = $(SOURCES_CPP:.cpp=.o)

CXXFLAGS += -std=gnu++17
CPPFLAGS += \
  -DZLIB_CONST \
  -D_FILE_OFFSET_BITS=64 \
  -I/usr/include/android \
  -Isystem/core/include \
  -Isystem/libbase/include \
  -Isystem/libziparchive/include \
  -Isystem/logging/liblog/include \

debian/out/system/core/$(NAME).a: $(OBJECTS_CC) $(OBJECTS_CPP)
	mkdir --parents debian/out/system/core
	ar -rcs $@ $^

$(OBJECTS_CC): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

$(OBJECTS_CPP): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

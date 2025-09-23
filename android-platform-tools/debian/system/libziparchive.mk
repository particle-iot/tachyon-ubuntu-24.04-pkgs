NAME = libziparchive

# system/libziparchive/Android.bp
SOURCES = \
  zip_archive.cc \
  zip_archive_stream_entry.cc \
  zip_cd_entry_map.cc \
  zip_error.cpp \
  zip_writer.cc \

SOURCES := $(foreach source, $(SOURCES), system/libziparchive/$(source))
SOURCES_CC = $(filter %.cc,$(SOURCES))
OBJECTS_CC = $(SOURCES_CC:.cc=.o)
SOURCES_CPP = $(filter %.cpp,$(SOURCES))
OBJECTS_CPP = $(SOURCES_CPP:.cpp=.o)

CPPFLAGS += \
  -DINCFS_SUPPORT_DISABLED=1 \
  -DZLIB_CONST \
  -D_FILE_OFFSET_BITS=64 \
  -Isystem/core/include \
  -Isystem/libbase/include \
  -Isystem/libziparchive/incfs_support/include \
  -Isystem/libziparchive/include \
  -Isystem/logging/liblog/include \

LDFLAGS += \
  -Ldebian/out/system \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -lbase \
  -llog \
  -lpthread \
  -lz \
  -shared

build: $(OBJECTS_CC) $(OBJECTS_CPP)
	$(CXX) $^ -o debian/out/system/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/system/$(NAME).so

$(OBJECTS_CC): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

$(OBJECTS_CPP): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

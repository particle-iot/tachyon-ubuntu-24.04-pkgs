NAME = libsparse

# system/core/libsparse/Android.bp
SOURCES = \
  backed_block.cpp \
  output_file.cpp \
  sparse.cpp \
  sparse_crc32.cpp \
  sparse_err.cpp \
  sparse_read.cpp \

SOURCES := $(foreach source, $(SOURCES), system/core/libsparse/$(source))
OBJECTS := $(SOURCES:.cpp=.o)

CPPFLAGS += \
  -Isystem/core/include \
  -Isystem/core/libsparse/include \
  -Isystem/libbase/include \

LDFLAGS += \
  -Ldebian/out/system \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -lbase \
  -lz \
  -shared

build: $(OBJECTS)
	$(CXX) $^ -o debian/out/system/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/system/$(NAME).so

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

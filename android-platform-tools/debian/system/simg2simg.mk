NAME = simg2simg

SOURCES = \
  simg2simg.cpp \
  sparse_crc32.cpp \

SOURCES := $(foreach source, $(SOURCES), system/core/libsparse/$(source))
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -fpermissive
CPPFLAGS += \
  -Isystem/core/libsparse/include \

LDFLAGS += \
  -Ldebian/out/system \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -lbase \
  -llog \
  -lpthread \
  -lsparse \
  -pie \

# force GCC, clang fails on:
# libsparse/simg2simg.cpp:75:11: error: assigning to 'struct sparse_file **' from incompatible type 'void *'
#  out_s = calloc(sizeof(struct sparse_file*), files);
debian/out/system/$(NAME): $(OBJECTS)
	$(CXX) -o $@ $^ $(LDFLAGS)

$(OBJECTS): %.o: %.cpp
	g++ -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

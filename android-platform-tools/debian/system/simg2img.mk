NAME = simg2img

SOURCES = \
  simg2img.cpp \
  sparse_crc32.cpp \

SOURCES := $(foreach source, $(SOURCES), system/core/libsparse/$(source))
OBJECTS = $(SOURCES:.cpp=.o)

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

debian/out/system/$(NAME): $(OBJECTS)
	$(CXX) -o $@ $^ $(LDFLAGS)

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

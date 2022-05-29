NAME = img2simg

SOURCES = img2simg.cpp

SOURCES := $(foreach source, $(SOURCES), system/core/libsparse/$(source))
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++17
CPPFLAGS += \
  -Isystem/core/libsparse/include \

LDFLAGS += \
  -Ldebian/out/system/core \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -lbase \
  -llog \
  -lpthread \
  -lsparse \

debian/out/system/core/$(NAME): $(OBJECTS)
	$(CXX) -o $@ $^ $(LDFLAGS)

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

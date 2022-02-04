NAME = etc1tool

SOURCES = development/tools/etc1tool/etc1tool.cpp

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -I/usr/include/android \
  -Idevelopment/include \
  -Iframeworks/native/opengl/include \

LDFLAGS += -lpng
STATIC_LIBS = debian/out/frameworks/native/libETC1.a

debian/out/development/$(NAME): $(SOURCES)
	mkdir --parents debian/out/development
	$(CXX) -o $@ $^ $(CXXFLAGS) $(CPPFLAGS) $(STATIC_LIBS) $(LDFLAGS)

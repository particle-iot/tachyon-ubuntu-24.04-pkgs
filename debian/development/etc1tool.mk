NAME = etc1tool

SOURCES = development/tools/etc1tool/etc1tool.cpp

CPPFLAGS += -Idevelopment/include -I/usr/include/android -Iframeworks/native/opengl/include
CXXFLAGS += -pie

LDFLAGS += -lpng
STATIC_LIBS = debian/out/frameworks/native/libETC1.a

debian/out/development/$(NAME): $(SOURCES)
	mkdir --parents debian/out/development
	$(CXX) -o $@ $^ $(CXXFLAGS) $(CPPFLAGS) $(STATIC_LIBS) $(LDFLAGS)

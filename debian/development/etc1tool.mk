NAME = etc1tool

# development/tools/etc1tool/Android.bp
SOURCES = development/tools/etc1tool/etc1tool.cpp

CPPFLAGS += \
  -I/usr/include/android \
  -Idevelopment/include \
  -Iframeworks/native/opengl/include \

LDFLAGS += -lpng -pie
STATIC_LIBS = debian/out/frameworks/native/libETC1.a

debian/out/development/$(NAME): $(SOURCES)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(CPPFLAGS) $(STATIC_LIBS) $(LDFLAGS)

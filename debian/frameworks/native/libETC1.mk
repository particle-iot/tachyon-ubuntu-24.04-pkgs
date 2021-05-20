NAME = libETC1

SOURCES = frameworks/native/opengl/libs/ETC1/etc1.cpp
OBJECTS = $(SOURCES:.cpp=.o)

CPPFLAGS += -Iframeworks/native/opengl/include

debian/out/frameworks/native/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/frameworks/native
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

NAME = libsparse

SOURCES = \
  backed_block.cpp \
  output_file.cpp \
  sparse.cpp \
  sparse_crc32.cpp \
  sparse_err.cpp \
  sparse_read.cpp \

SOURCES := $(foreach source, $(SOURCES), system/core/libsparse/$(source))
OBJECTS := $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -I/usr/include/android \
  -Isystem/core/include \
  -Isystem/core/libsparse/include \
  -Isystem/libbase/include \

debian/out/system/core/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/system/core
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

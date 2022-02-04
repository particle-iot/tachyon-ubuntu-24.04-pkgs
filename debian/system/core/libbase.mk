NAME = libbase

SOURCES = \
  abi_compatibility.cpp \
  chrono_utils.cpp \
  cmsg.cpp \
  file.cpp \
  liblog_symbols.cpp \
  logging.cpp \
  mapped_file.cpp \
  parsebool.cpp \
  parsenetaddress.cpp \
  process.cpp \
  properties.cpp \
  stringprintf.cpp \
  strings.cpp \
  threads.cpp \
  test_utils.cpp \
  \
  errors_unix.cpp

SOURCES := $(foreach source, $(SOURCES), system/core/base/$(source))
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -D_FILE_OFFSET_BITS=64 \
  -I/usr/include/android \
  -Isystem/core/base/include \
  -Isystem/core/include \

debian/out/system/core/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/system/core
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

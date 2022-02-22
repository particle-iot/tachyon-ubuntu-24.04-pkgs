NAME = libbase

SOURCES = \
  abi_compatibility.cpp \
  chrono_utils.cpp \
  cmsg.cpp \
  file.cpp \
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

SOURCES_fmtlib = \
  src/format.cc \

SOURCES := \
  $(foreach source, $(SOURCES), system/libbase/$(source)) \
  $(foreach source, $(SOURCES_fmtlib), external/fmtlib/$(source))
OBJECTS_CC = $(SOURCES:.cc=.o)
SOURCES_CPP = $(filter %.cpp,$(SOURCES))
OBJECTS_CPP = $(SOURCES_CPP:.cpp=.o)

CXXFLAGS += -std=gnu++2a -fno-exceptions
CPPFLAGS += \
  -D_FILE_OFFSET_BITS=64 \
  -I/usr/include/android \
  -Iexternal/fmtlib/include \
  -Isystem/core/include \
  -Isystem/libbase/include \
  -Isystem/logging/liblog/include \

debian/out/system/core/$(NAME).a: $(OBJECTS_CC) $(OBJECTS_CPP)
	mkdir --parents debian/out/system/core
	ar -rcs $@ $^

$(OBJECTS_CPP): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

$(OBJECTS_CC): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

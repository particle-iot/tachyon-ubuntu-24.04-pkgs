NAME = libbase

# system/libbase/Android.bp
SOURCES = \
  abi_compatibility.cpp \
  chrono_utils.cpp \
  cmsg.cpp \
  file.cpp \
  hex.cpp \
  logging.cpp \
  mapped_file.cpp \
  parsebool.cpp \
  parsenetaddress.cpp \
  posix_strerror_r.cpp \
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
SOURCES_CC = $(filter %.cc,$(SOURCES))
OBJECTS_CC = $(SOURCES_CC:.cc=.o)
SOURCES_CPP = $(filter %.cpp,$(SOURCES))
OBJECTS_CPP = $(SOURCES_CPP:.cpp=.o)

CPPFLAGS += \
  -D_FILE_OFFSET_BITS=64 \
  -Iexternal/fmtlib/include \
  -Isystem/core/include \
  -Isystem/libbase/include \
  -Isystem/logging/liblog/include \

LDFLAGS += \
  -Ldebian/out/system \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -llog \
  -lpthread \
  -shared

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifneq ($(filter armel mipsel,$(DEB_HOST_ARCH)),)
  LDFLAGS += -latomic
endif

build: $(OBJECTS_CC) $(OBJECTS_CPP)
	$(CXX) $^ -o debian/out/system/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/system/$(NAME).so

$(OBJECTS_CPP): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

$(OBJECTS_CC): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

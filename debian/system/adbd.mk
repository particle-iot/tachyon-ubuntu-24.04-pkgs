NAME = adbd

# packages/modules/adb/Android.bp
SOURCES = \
  daemon/main.cpp \
  \
  proto/adb_known_hosts.pb.cc \
  proto/app_processes.pb.cc \
  proto/key_type.pb.cc \
  proto/pairing.pb.cc \

SOURCES := $(foreach source, $(SOURCES), packages/modules/adb/$(source))
SOURCES_CPP = $(filter %.cpp,$(SOURCES))
OBJECTS_CPP = $(SOURCES_CPP:.cpp=.$(NAME).o)
SOURCES_CC = $(filter %.cc,$(SOURCES))
OBJECTS_CC = $(SOURCES_CC:.cc=.$(NAME).o)

CXXFLAGS += -fpermissive
CPPFLAGS += \
  -D_GNU_SOURCE \
  -DADB_VERSION='"$(DEB_VERSION)"' \
  -DADB_HOST=0 \
  -Ipackages/modules/adb \
  -Isystem/core/base/include \
  -Isystem/core/include \
  -Isystem/libbase/include \
  \
  -I/usr/include/android \

LDFLAGS += \
  -Ldebian/out/system \
  -L/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -lbase \
  -lbrotlidec \
  -lbrotlienc \
  -lcrypto \
  -lcutils \
  -llog \
  -llz4 \
  -lprotobuf \
  -lpthread \
  -lresolv \
  -lssl \
  -lsystemd \
  -lusb-1.0 \
  -lzstd \
  -pie \

STATIC_LIBS = \
  debian/out/system/libadbd.a \
  debian/out/system/libcrypto_utils.a \

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifneq ($(filter armel mipsel,$(DEB_HOST_ARCH)),)
  LDFLAGS += -latomic
endif

debian/out/system/$(NAME): $(OBJECTS_CC) $(OBJECTS_CPP) $(STATIC_LIBS)
	$(CXX) -o $@ $^ $(LDFLAGS)

$(OBJECTS_CPP): %.$(NAME).o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

$(OBJECTS_CC): %.$(NAME).o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

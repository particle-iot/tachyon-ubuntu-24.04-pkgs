NAME = adb

# packages/modules/adb/Android.bp
SOURCES = \
  client/adb_client.cpp \
  client/bugreport.cpp \
  client/commandline.cpp \
  client/file_sync_client.cpp \
  client/main.cpp \
  client/console.cpp \
  client/adb_install.cpp \
  client/line_printer.cpp \
  client/fastdeploycallbacks.cpp \
  client/incremental.cpp \
  client/incremental_server.cpp \
  client/incremental_utils.cpp \
  shell_service_protocol.cpp \
  \
  proto/adb_known_hosts.pb.cc \
  proto/app_processes.pb.cc \
  proto/key_type.pb.cc \
  proto/pairing.pb.cc \
#  fastdeploy/proto/ApkEntry.pb.cc \
#  client/fastdeploy.cpp \

SOURCES := $(foreach source, $(SOURCES), packages/modules/adb/$(source))
SOURCES_CPP = $(filter %.cpp,$(SOURCES))
OBJECTS_CPP = $(SOURCES_CPP:.cpp=.o)
SOURCES_CC = $(filter %.cc,$(SOURCES))
OBJECTS_CC = $(SOURCES_CC:.cc=.o)

CXXFLAGS += -fpermissive
CPPFLAGS += \
  -D_GNU_SOURCE \
  -DADB_HOST=1 \
  -DADB_VERSION='"$(DEB_VERSION)"' \
  -Ifastdeploy/proto \
  -Ipackages/modules/adb \
  -Ipackages/modules/adb/proto \
  -Ipackages/modules/adb/tls/include \
  -Isystem/core/include \
  -Isystem/libbase/include \
  -Isystem/libziparchive/include \
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
  -lssl \
  -lusb-1.0 \
  -lziparchive \
  -lzstd \
  -pie \

STATIC_LIBS = \
  debian/out/system/libadb.a \
  debian/out/system/libcrypto_utils.a \

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifneq ($(filter armel mipsel,$(DEB_HOST_ARCH)),)
  LDFLAGS += -latomic
endif

debian/out/system/$(NAME): $(OBJECTS_CC) $(OBJECTS_CPP) $(STATIC_LIBS)
	$(CXX) -o $@ $^ $(LDFLAGS)

$(OBJECTS_CPP): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

$(OBJECTS_CC): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

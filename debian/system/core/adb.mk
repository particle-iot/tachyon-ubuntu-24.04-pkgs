NAME = adb

SOURCES = \
  client/adb_client.cpp \
  client/bugreport.cpp \
  client/commandline.cpp \
  client/file_sync_client.cpp \
  client/main.cpp \
  client/console.cpp \
  client/adb_install.cpp \
  client/line_printer.cpp \
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

SOURCES := $(foreach source, $(SOURCES), packages/modules/adb/$(source))
SOURCES_CPP = $(filter %.cpp,$(SOURCES))
OBJECTS_CPP = $(SOURCES_CPP:.cpp=.o)
SOURCES_CC = $(filter %.cc,$(SOURCES))
OBJECTS_CC = $(SOURCES_CC:.cc=.o)

CXXFLAGS += -std=gnu++2a -fpermissive
CPPFLAGS += \
  -D_GNU_SOURCE \
  -DADB_HOST=1 \
  -DADB_VERSION='"$(DEB_VERSION)"' \
  -I/usr/include \
  -I/usr/include/android \
  -Iexternal/boringssl/include \
  -Ifastdeploy/proto \
  -Ipackages/modules/adb \
  -Ipackages/modules/adb/proto \
  -Ipackages/modules/adb/tls/include \
  -Isystem/core/include \
  -Isystem/libbase/include \
  -Isystem/libziparchive/include \

LDFLAGS += -lpthread -lusb-1.0 -lz -lprotobuf -lzstd -llz4 -lbrotlienc -lbrotlidec
STATIC_LIBS = \
  debian/out/system/core/libadb.a \
  debian/out/system/core/libbase.a \
  debian/out/system/core/libcrypto_utils.a \
  debian/out/system/core/libcutils.a \
  debian/out/system/core/liblog.a \
  debian/out/system/core/libziparchive.a \
  debian/out/external/boringssl/libssl.a \
  debian/out/external/boringssl/libcrypto.a \

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifneq ($(filter armel mipsel,$(DEB_HOST_ARCH)),)
  LDFLAGS += -latomic
endif

debian/out/system/core/$(NAME): $(OBJECTS_CC) $(OBJECTS_CPP)
	mkdir --parents debian/out/system/core
	$(CXX) -o $@ $^ $(CXXFLAGS) $(CPPFLAGS) $(STATIC_LIBS) $(LDFLAGS)

$(OBJECTS_CPP): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

$(OBJECTS_CC): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

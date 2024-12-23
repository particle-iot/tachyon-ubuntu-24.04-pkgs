NAME = adb

# packages/modules/adb/Android.bp
ADB_SRC_FILES = \
  adb.cpp \
  adb_io.cpp \
  adb_listeners.cpp \
  adb_trace.cpp \
  services.cpp \
  sockets.cpp \
  socket_spec.cpp \
  transport.cpp \
  transport_fd.cpp \
  types.cpp \
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
#  adb_mdns.cpp \
#  client/fastdeploy.cpp \

# packages/modules/adb/Android.bp
LIBADB_host_SRC_FILES := \
  client/auth.cpp \
  client/adb_wifi.cpp \
  client/usb_libusb.cpp \
  client/transport_local.cpp \
  client/mdns_utils.cpp \
  client/transport_usb.cpp \
  client/pairing/pairing_client.cpp \
  \
  client/usb_linux.cpp \

LOCAL_SRC_FILES := \
  $(ADB_SRC_FILES) \
  $(LIBADB_host_SRC_FILES) \

LIBDIAGNOSE_USB_SRC_FILES = diagnose_usb/diagnose_usb.cpp

GEN := dummy.cpp

SOURCES := \
  $(foreach source, $(LOCAL_SRC_FILES), packages/modules/adb/$(source)) \
  $(foreach source, $(LIBDIAGNOSE_USB_SRC_FILES), system/core/$(source)) \
  $(foreach source, $(GEN), debian/out/system/$(source)) \

SOURCES_CPP = $(filter %.cpp,$(SOURCES))
OBJECTS_CPP = $(SOURCES_CPP:.cpp=.o)
SOURCES_CC = $(filter %.cc,$(SOURCES))
OBJECTS_CC = $(SOURCES_CC:.cc=.o)

CPPFLAGS += \
  -D_GNU_SOURCE \
  -DPLATFORM_TOOLS_VERSION='"$(PLATFORM_TOOLS_VERSION)"' \
  -DADB_HOST=1 \
  -DADB_VERSION='"$(DEB_VERSION)"' \
  -DANDROID_BASE_UNIQUE_FD_DISABLE_IMPLICIT_CONVERSION=1 \
  -Ifastdeploy/proto \
  -Ipackages/modules/adb \
  -Ipackages/modules/adb/crypto/include \
  -Ipackages/modules/adb/pairing_connection/include \
  -Ipackages/modules/adb/proto \
  -Ipackages/modules/adb/tls/include \
  -Isystem/core/diagnose_usb/include \
  -Isystem/core/include \
  -Isystem/core/libcrypto_utils/include \
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

debian/out/system/dummy.cpp:
	rm -f $@
	echo '#include <adb_wifi.h>' >> $@
	echo '#include <adb_mdns.h>' >> $@
	echo 'void init_mdns_transport_discovery(void) {}' >> $@
	echo 'std::string mdns_check() {return std::string("");}' >> $@
	echo 'void mdns_cleanup() {}' >> $@
	echo 'std::string mdns_list_discovered_services() {return std::string("");}' >> $@
	echo 'std::optional<MdnsInfo> mdns_get_connect_service_info(const std::string& name) {return std::nullopt;}' >> $@
	echo 'std::optional<MdnsInfo> mdns_get_pairing_service_info(const std::string& name) {return std::nullopt;}' >> $@
	echo 'bool adb_secure_connect_by_service_name(const std::string& instance_name) {return false;}' >> $@

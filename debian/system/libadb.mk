NAME := libadb

# packages/modules/adb/Android.bp
LIBADB_SRC_FILES := \
  adb.cpp \
  adb_io.cpp \
  adb_listeners.cpp \
  adb_trace.cpp \
  adb_unique_fd.cpp \
  adb_utils.cpp \
  fdevent/fdevent.cpp \
  services.cpp \
  sockets.cpp \
  socket_spec.cpp \
  sysdeps/env.cpp \
  sysdeps/errno.cpp \
  transport.cpp \
  transport_fd.cpp \
  types.cpp \
#  adb_mdns.cpp \

LIBADB_posix_srcs := \
  sysdeps_unix.cpp \
  sysdeps/posix/network.cpp \

# packages/modules/adb/Android.bp
LIBADB_linux_SRC_FILES := \
  fdevent/fdevent_epoll.cpp \
  client/usb_linux.cpp \

# packages/modules/adb/Android.bp
LIBADB_host_SRC_FILES := \
  client/auth.cpp \
  client/adb_wifi.cpp \
  client/usb_libusb.cpp \
  client/transport_local.cpp \
  client/mdns_utils.cpp \
  client/transport_usb.cpp \
  client/pairing/pairing_client.cpp \

# packages/modules/adb/pairing_auth/Android.bp
LIBADB_pairing_auth_SRC_FILES := \
  pairing_auth/aes_128_gcm.cpp \
  pairing_auth/pairing_auth.cpp \

# packages/modules/adb/pairing_connection/Android.bp
LIBADB_pairing_connection_SRC_FILES := \
  pairing_connection/pairing_connection.cpp \
  pairing_connection/pairing_server.cpp \

# packages/modules/adb/crypto/Android.bp
LIBADB_crypto_SRC_FILES := \
  crypto/key.cpp \
  crypto/rsa_2048_key.cpp \
  crypto/x509_generator.cpp \
#  client/openscreen/mdns_service_info.cpp \
#  client/openscreen/mdns_service_watcher.cpp \
#  client/openscreen/platform/logging.cpp \
#  client/openscreen/platform/task_runner.cpp \
#  client/openscreen/platform/udp_socket.cpp \
#  client/mdnsresponder_client.cpp \
#  client/transport_mdns.cpp \

# packages/modules/adb/tls/Android.bp
LIBADB_tls_SRC_FILES := \
  tls/adb_ca_list.cpp \
  tls/tls_connection.cpp \

LOCAL_SRC_FILES := \
  $(LIBADB_SRC_FILES) \
  $(LIBADB_posix_srcs) \
  $(LIBADB_linux_SRC_FILES) \
  $(LIBADB_host_SRC_FILES) \
  $(LIBADB_pairing_auth_SRC_FILES) \
  $(LIBADB_pairing_connection_SRC_FILES) \
  $(LIBADB_crypto_SRC_FILES) \
  $(LIBADB_tls_SRC_FILES) \

LIBDIAGNOSE_USB_SRC_FILES = diagnose_usb/diagnose_usb.cpp

GEN := dummy.cpp

SOURCES := \
  $(foreach source, $(LOCAL_SRC_FILES), packages/modules/adb/$(source)) \
  $(foreach source, $(LIBDIAGNOSE_USB_SRC_FILES), system/core/$(source)) \
  $(foreach source, $(GEN), debian/out/system/$(source)) \

OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += \
  -Wexit-time-destructors \
  -Wno-non-virtual-dtor \
  -Wno-unused-parameter \
  -Wno-missing-field-initializers \
  -Wvla \

CPPFLAGS += \
  -DPLATFORM_TOOLS_VERSION='"$(PLATFORM_TOOLS_VERSION)"' \
  -DADB_HOST=1 \
  -DADB_VERSION='"$(DEB_VERSION)"' \
  -DANDROID_BASE_UNIQUE_FD_DISABLE_IMPLICIT_CONVERSION=1 \
  -Ipackages/modules/adb \
  -Ipackages/modules/adb/crypto/include \
  -Ipackages/modules/adb/pairing_auth/include \
  -Ipackages/modules/adb/pairing_connection/include \
  -Ipackages/modules/adb/proto \
  -Ipackages/modules/adb/tls/include \
  -Isystem/core/diagnose_usb/include \
  -Isystem/core/include \
  -Isystem/core/libcrypto_utils/include \
  -Isystem/core/libcutils/include \
  -Isystem/libbase/include \
  \
  -I/usr/include/android \

debian/out/system/$(NAME).a: $(OBJECTS)
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
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

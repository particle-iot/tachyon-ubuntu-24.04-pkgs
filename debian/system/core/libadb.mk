NAME := libadb

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

LIBADB_posix_srcs := \
  sysdeps_unix.cpp \
  sysdeps/posix/network.cpp \

LIBADB_linux_SRC_FILES := \
  fdevent/fdevent_epoll.cpp \
  client/usb_linux.cpp \
  client/auth.cpp \
  client/adb_wifi.cpp \
  client/usb_libusb.cpp \
  client/transport_local.cpp \
  client/transport_usb.cpp \
  client/pairing/pairing_client.cpp \
  \
  pairing_auth/aes_128_gcm.cpp \
  pairing_auth/pairing_auth.cpp \
  pairing_connection/pairing_connection.cpp \
  pairing_connection/pairing_server.cpp \
  crypto/key.cpp \
  crypto/rsa_2048_key.cpp \
  crypto/x509_generator.cpp \

LIBADB_tls_SRC_FILES := \
  tls/adb_ca_list.cpp \
  tls/tls_connection.cpp \

LOCAL_SRC_FILES := \
  $(LIBADB_SRC_FILES) \
  $(LIBADB_posix_srcs) \
  $(LIBADB_linux_SRC_FILES) \
  $(LIBADB_tls_SRC_FILES) \

LIBDIAGNOSE_USB_SRC_FILES = diagnose_usb/diagnose_usb.cpp

GEN := debian/out/system/core/dummy.cpp

SOURCES := \
  $(foreach source, $(LOCAL_SRC_FILES), packages/modules/adb/$(source)) \
  $(foreach source, $(LIBDIAGNOSE_USB_SRC_FILES), system/core/$(source)) \
  $(GEN)
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++2a \
  -Wexit-time-destructors \
  -Wno-non-virtual-dtor \
  -Wno-unused-parameter \
  -Wno-missing-field-initializers \
  -Wthread-safety \
  -Wvla \

CPPFLAGS += \
  -DPLATFORM_TOOLS_VERSION='"$(PLATFORM_TOOLS_VERSION)"' \
  -DADB_HOST=1 \
  -DADB_VERSION='"$(DEB_VERSION)"' \
  -I/usr/include \
  -I/usr/include/android \
  -Iexternal/boringssl/include \
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

debian/out/system/core/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/system/core
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

debian/out/system/core/dummy.cpp:
	mkdir --parents debian/out/system/core
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

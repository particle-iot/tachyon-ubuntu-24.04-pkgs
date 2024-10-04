NAME := libadbd

# packages/modules/adb/Android.bp
LIBADBD_SRC_FILES := \
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

# packages/modules/adb/Android.bp
LIBADBD_posix_srcs := \
  sysdeps_unix.cpp \
  sysdeps/posix/network.cpp \

# packages/modules/adb/Android.bp
LIBADBD_linux_SRC_FILES := \
  fdevent/fdevent_epoll.cpp \

# packages/modules/adb/Android.bp
LIBADBD_core_SRC_FILES := \
  daemon/adb_wifi.cpp \
  daemon/auth.cpp \
  daemon/jdwp_service.cpp \
  daemon/logging.cpp \
  daemon/transport_local.cpp \
  daemon/usb.cpp \
  daemon/usb_ffs.cpp \

# packages/modules/adb/pairing_auth/Android.bp
LIBADBD_pairing_auth_SRC_FILES := \
  pairing_auth/aes_128_gcm.cpp \
  pairing_auth/pairing_auth.cpp \

# packages/modules/adb/pairing_connection/Android.bp
LIBADBD_pairing_connection_SRC_FILES := \
  pairing_connection/pairing_connection.cpp \

# packages/modules/adb/crypto/Android.bp
LIBADBD_crypto_SRC_FILES := \
  crypto/key.cpp \
  crypto/rsa_2048_key.cpp \
  crypto/x509_generator.cpp \

# packages/modules/adb/tls/Android.bp
LIBADBD_tls_SRC_FILES := \
  tls/adb_ca_list.cpp \
  tls/tls_connection.cpp \

# packages/modules/adb/libs/adbconnection/Android.bp
LIBADBD_adbconnection_server_SRC_FILES := \
  libs/adbconnection/adbconnection_server.cpp \

# packages/modules/adb/Android.bp
LIBADBD_services_SRC_FILES := \
  daemon/file_sync_service.cpp \
  daemon/services.cpp \
  daemon/shell_service.cpp \
  shell_service_protocol.cpp \

# packages/modules/adb/libs/libadbd_fs/Android.bp
LIBADBD_fs_SRC_FILES := \
  libs/libadbd_fs/adbd_fs.cpp \

LOCAL_SRC_FILES := \
  $(LIBADBD_SRC_FILES) \
  $(LIBADBD_posix_srcs) \
  $(LIBADBD_linux_SRC_FILES) \
  $(LIBADBD_core_SRC_FILES) \
  $(LIBADBD_pairing_auth_SRC_FILES) \
  $(LIBADBD_pairing_connection_SRC_FILES) \
  $(LIBADBD_crypto_SRC_FILES) \
  $(LIBADBD_tls_SRC_FILES) \
  $(LIBADBD_adbconnection_server_SRC_FILES) \
  $(LIBADBD_services_SRC_FILES) \
  $(LIBADBD_fs_SRC_FILES) \

LIBDIAGNOSE_USB_SRC_FILES = diagnose_usb/diagnose_usb.cpp
LIBASYNCIO_SRC_FILES = libasyncio/AsyncIO.cpp

LIBADBD_AUTH_SRC_FILES = libs/adbd_auth/adbd_auth.cpp

SOURCES := \
  $(foreach source, $(LOCAL_SRC_FILES), packages/modules/adb/$(source)) \
  $(foreach source, $(LIBDIAGNOSE_USB_SRC_FILES), system/core/$(source)) \
  $(foreach source, $(LIBASYNCIO_SRC_FILES), system/core/$(source)) \
  $(foreach source, $(LIBADBD_AUTH_SRC_FILES), frameworks/native/$(source)) \

OBJECTS = $(SOURCES:.cpp=.$(NAME).o)

CXXFLAGS += \
  -Wexit-time-destructors \
  -Wno-narrowing \
  -Wno-non-virtual-dtor \
  -Wno-unused-parameter \
  -Wno-missing-field-initializers \
  -Wvla \

CPPFLAGS += \
  -DPLATFORM_TOOLS_VERSION='"$(PLATFORM_TOOLS_VERSION)"' \
  -DADB_HOST=0 \
  -DADB_VERSION='"$(DEB_VERSION)"' \
  -DANDROID_BASE_UNIQUE_FD_DISABLE_IMPLICIT_CONVERSION=1 \
  -DPAGE_SIZE=4096 \
  -Iframeworks/native/libs/adbd_auth/include/ \
  -Ipackages/modules/adb \
  -Ipackages/modules/adb/crypto/include \
  -Ipackages/modules/adb/daemon/include \
  -Ipackages/modules/adb/libs/libadbd_fs/include \
  -Ipackages/modules/adb/libs/adbconnection/include \
  -Ipackages/modules/adb/pairing_auth/include \
  -Ipackages/modules/adb/pairing_connection/include \
  -Ipackages/modules/adb/proto \
  -Ipackages/modules/adb/tls/include \
  -Isystem/core/diagnose_usb/include \
  -Isystem/core/include \
  -Isystem/core/libasyncio/include \
  -Isystem/core/libcrypto_utils/include \
  -Isystem/core/libcutils/include \
  -Isystem/libbase/include \
  -Isystem/logging/liblog/include \
  \
  -I/usr/include/android \

debian/out/system/$(NAME).a: $(OBJECTS)
	ar -rcs $@ $^

$(OBJECTS): %.$(NAME).o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

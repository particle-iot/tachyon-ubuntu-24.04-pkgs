NAME = adbd

# packages/modules/adb/Android.bp
ADBD_SRC_FILES = \
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
  daemon/adb_wifi.cpp \
  daemon/auth.cpp \
  daemon/jdwp_service.cpp \
  daemon/logging.cpp \
  daemon/main.cpp \
  daemon/transport_local.cpp \
  daemon/usb.cpp \
  daemon/usb_ffs.cpp \
#  adb_mdns.cpp \

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

LIBDIAGNOSE_USB_SRC_FILES = diagnose_usb/diagnose_usb.cpp
LIBASYNCIO_SRC_FILES = libasyncio/AsyncIO.cpp

LIBADBD_AUTH_SRC_FILES = libs/adbd_auth/adbd_auth.cpp

LOCAL_SRC_FILES := \
  $(ADBD_SRC_FILES) \
  $(LIBADBD_adbconnection_server_SRC_FILES) \
  $(LIBADBD_services_SRC_FILES) \
  $(LIBADBD_fs_SRC_FILES) \

SOURCES := \
  $(foreach source, $(LOCAL_SRC_FILES), packages/modules/adb/$(source)) \
  $(foreach source, $(LIBDIAGNOSE_USB_SRC_FILES), system/core/$(source)) \
  $(foreach source, $(LIBASYNCIO_SRC_FILES), system/core/$(source)) \
  $(foreach source, $(LIBADBD_AUTH_SRC_FILES), frameworks/native/$(source)) \

OBJECTS = $(SOURCES:.cpp=.$(NAME).o)

CXXFLAGS += \
  -Wno-narrowing \

CPPFLAGS += \
  -D_GNU_SOURCE \
  -DPLATFORM_TOOLS_VERSION='"$(PLATFORM_TOOLS_VERSION)"' \
  -DADB_HOST=0 \
  -DADB_VERSION='"$(DEB_VERSION)"' \
  -DANDROID_BASE_UNIQUE_FD_DISABLE_IMPLICIT_CONVERSION=1 \
  -DPAGE_SIZE=4096 \
  -Iframeworks/native/libs/adbd_auth/include/ \
  -Ipackages/modules/adb \
  -Ipackages/modules/adb/crypto/include \
  -Ipackages/modules/adb/libs/libadbd_fs/include \
  -Ipackages/modules/adb/libs/adbconnection/include \
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
  -lresolv \
  -lssl \
  -lsystemd \
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

debian/out/system/$(NAME): $(OBJECTS) $(STATIC_LIBS)
	$(CXX) -o $@ $^ $(LDFLAGS)

$(OBJECTS): %.$(NAME).o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

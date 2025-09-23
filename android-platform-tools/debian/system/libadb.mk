NAME := libadb

# packages/modules/adb/Android.bp
LIBADB_SRC_FILES := \
  adb_unique_fd.cpp \
  adb_utils.cpp \
  fdevent/fdevent.cpp \
  sysdeps/env.cpp \
  sysdeps/errno.cpp \
  \
  proto/adb_known_hosts.pb.cc \
  proto/app_processes.pb.cc \
  proto/key_type.pb.cc \
  proto/pairing.pb.cc \
#  fastdeploy/proto/ApkEntry.pb.cc \

LIBADB_posix_srcs := \
  sysdeps_unix.cpp \
  sysdeps/posix/network.cpp \

# packages/modules/adb/Android.bp
LIBADB_linux_SRC_FILES := \
  fdevent/fdevent_epoll.cpp \

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
  $(LIBADB_pairing_auth_SRC_FILES) \
  $(LIBADB_pairing_connection_SRC_FILES) \
  $(LIBADB_crypto_SRC_FILES) \
  $(LIBADB_tls_SRC_FILES) \

LIBDIAGNOSE_USB_SRC_FILES = diagnose_usb/diagnose_usb.cpp

SOURCES := \
  $(foreach source, $(LOCAL_SRC_FILES), packages/modules/adb/$(source)) \
  $(foreach source, $(LIBDIAGNOSE_USB_SRC_FILES), system/core/$(source)) \
  $(foreach source, $(GEN), debian/out/system/$(source)) \

SOURCES_CPP = $(filter %.cpp,$(SOURCES))
OBJECTS_CPP = $(SOURCES_CPP:.cpp=.o)
SOURCES_CC = $(filter %.cc,$(SOURCES))
OBJECTS_CC = $(SOURCES_CC:.cc=.o)

CXXFLAGS += \
  -Wexit-time-destructors \
  -Wno-non-virtual-dtor \
  -Wno-unused-parameter \
  -Wno-missing-field-initializers \
  -Wvla \

CPPFLAGS += \
  -DPLATFORM_TOOLS_VERSION='"$(PLATFORM_TOOLS_VERSION)"' \
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

debian/out/system/$(NAME).a: $(OBJECTS_CC) $(OBJECTS_CPP)
	ar -rcs $@ $^

$(OBJECTS_CPP): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

$(OBJECTS_CC): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

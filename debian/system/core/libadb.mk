NAME := libadb

LIBADB_SRC_FILES := \
  adb.cpp \
  adb_io.cpp \
  adb_listeners.cpp \
  adb_trace.cpp \
  adb_unique_fd.cpp \
  adb_utils.cpp \
  fdevent/fdevent.cpp \
  fdevent/fdevent_poll.cpp \
  services.cpp \
  sockets.cpp \
  socket_spec.cpp \
  sysdeps/errno.cpp \
  transport.cpp \
  transport_fd.cpp \
  transport_local.cpp \
  transport_usb.cpp \
  types.cpp \

LIBADB_posix_srcs := \
  sysdeps_unix.cpp \
  sysdeps/posix/network.cpp \

LIBADB_linux_SRC_FILES := \
  fdevent/fdevent_epoll.cpp \
  client/auth.cpp \
  client/usb_dispatch.cpp \
  client/usb_libusb.cpp \
  client/usb_linux.cpp \

LOCAL_SRC_FILES := \
  $(LIBADB_SRC_FILES) \
  $(LIBADB_posix_srcs) \
  $(LIBADB_linux_SRC_FILES) \

LIBDIAGNOSE_USB_SRC_FILES = diagnose_usb/diagnose_usb.cpp

GEN := debian/out/system/core/transport_mdns_unsupported.cpp

SOURCES := $(foreach source, $(LOCAL_SRC_FILES), adb/$(source)) $(LIBDIAGNOSE_USB_SRC_FILES)
SOURCES := $(foreach source, $(SOURCES), system/core/$(source)) $(GEN)
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -DPLATFORM_TOOLS_VERSION='"$(PLATFORM_TOOLS_VERSION)"' \
  -DADB_HOST=1 -DADB_VERSION='"$(DEB_VERSION)"' \
  -I/usr/include/android \
  -Iexternal/boringssl/include \
  -Isystem/core/adb \
  -Isystem/core/base/include \
  -Isystem/core/diagnose_usb/include \
  -Isystem/core/include \
  -Isystem/core/libcrypto_utils/include \
  -Isystem/core/libcutils/include \

debian/out/system/core/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/system/core
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

debian/out/system/core/transport_mdns_unsupported.cpp:
	mkdir --parents debian/out/system/core
	echo 'void init_mdns_transport_discovery(void) {}' > $@

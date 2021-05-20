NAME = fastboot

fastboot_SOURCES = \
  bootimg_utils.cpp \
  fastboot.cpp \
  fastboot_driver.cpp \
  fs.cpp \
  main.cpp \
  socket.cpp \
  tcp.cpp \
  udp.cpp \
  usb_linux.cpp \
  util.cpp \

fs_mgr_liblp_SOURCES := \
  builder.cpp \
  images.cpp \
  partition_opener.cpp \
  property_fetcher.cpp \
  reader.cpp \
  utility.cpp \
  writer.cpp \

SOURCES := \
  $(foreach source, $(fastboot_SOURCES), system/core/fastboot/$(source)) \
  $(foreach source, $(fs_mgr_liblp_SOURCES), system/core/fs_mgr/liblp/$(source))
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++2a -fpermissive -pie
CPPFLAGS += \
   -DPLATFORM_TOOLS_VERSION='"$(PLATFORM_TOOLS_VERSION)"' \
   -D_FILE_OFFSET_BITS=64 \
   -Isystem/core/include \
   -Isystem/tools/mkbootimg/include/bootimg \
   -Isystem/core/adb \
   -Isystem/core/base/include \
   -Isystem/core/demangle/include \
   -Isystem/core/diagnose_usb/include \
   -Isystem/core/fs_mgr/include \
   -Isystem/core/fs_mgr/include_fstab \
   -Isystem/core/fs_mgr/liblp/include \
   -Isystem/core/libsparse/include \
   -Isystem/core/libziparchive/include \
   -Iexternal/boringssl/include \
   -Iexternal/avb \
   -Isystem/core/libcutils/include \
   -Isystem/core/libsparse/include \
   -Isystem/core/base/include \
   -Isystem/extras/ext4_utils/include \
   -I/usr/include/android \

LDFLAGS += -lpthread -lusb-1.0 -lz
STATIC_LIBS = \
  debian/out/system/core/libadb.a \
  debian/out/system/core/libcutils.a \
  debian/out/system/extras/libext4_utils.a \
  debian/out/external/selinux/libselinux.a \
  debian/out/external/selinux/libsepol.a \
  debian/out/system/core/libziparchive.a \
  debian/out/system/core/libsparse.a \
  debian/out/system/core/libbase.a \
  debian/out/system/core/liblog.a \
  debian/out/external/boringssl/libcrypto.a \

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifneq ($(filter armel mipsel,$(DEB_HOST_ARCH)),)
  LDFLAGS += -latomic
endif

debian/out/system/core/$(NAME): $(OBJECTS)
	mkdir --parents debian/out/system/core
	$(CXX) -o $@ $^ $(CXXFLAGS) $(CPPFLAGS) $(STATIC_LIBS) $(LDFLAGS)

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

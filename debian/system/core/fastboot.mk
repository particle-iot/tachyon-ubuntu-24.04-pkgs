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
  vendor_boot_img_utils.cpp \

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

CXXFLAGS += -std=gnu++2a -fpermissive
CPPFLAGS += \
   -D_FILE_OFFSET_BITS=64 \
   -DPLATFORM_TOOLS_VERSION='"$(PLATFORM_TOOLS_VERSION)"' \
   -I/usr/include/android \
   -Iexternal/avb \
   -Iexternal/boringssl/include \
   -Iexternal/fmtlib/include \
   -Ipackages/modules/adb \
   -Isystem/core/demangle/include \
   -Isystem/core/diagnose_usb/include \
   -Isystem/core/fs_mgr/include \
   -Isystem/core/fs_mgr/include_fstab \
   -Isystem/core/fs_mgr/liblp/include \
   -Isystem/core/fs_mgr/libstorage_literals \
   -Isystem/core/include \
   -Isystem/core/libcutils/include \
   -Isystem/core/libsparse/include \
   -Isystem/extras/ext4_utils/include \
   -Isystem/libbase/include \
   -Isystem/libziparchive/include \
   -Isystem/tools/mkbootimg/include/bootimg \

LDFLAGS += -lpthread -lusb-1.0 -lz -lprotobuf
STATIC_LIBS = \
  debian/out/system/core/libadb.a \
  debian/out/system/core/libbase.a \
  debian/out/system/core/libcutils.a \
  debian/out/system/core/liblog.a \
  debian/out/system/core/libsparse.a \
  debian/out/system/core/libziparchive.a \
  debian/out/system/extras/libext4_utils.a \
  debian/out/external/boringssl/libssl.a \
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

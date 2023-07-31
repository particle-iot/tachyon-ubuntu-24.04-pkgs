NAME = fastboot

fastboot_SOURCES = \
  bootimg_utils.cpp \
  fastboot_driver.cpp \
  fastboot.cpp \
  filesystem.cpp \
  fs.cpp \
  main.cpp \
  socket.cpp \
  storage.cpp \
  super_flash_helper.cpp \
  tcp.cpp \
  udp.cpp \
  util.cpp \
  vendor_boot_img_utils.cpp \
  task.cpp \
  \
  usb_linux.cpp \

fs_mgr_liblp_SOURCES := \
  builder.cpp \
  super_layout_builder.cpp \
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

CXXFLAGS += -fpermissive
CPPFLAGS += \
  -D_FILE_OFFSET_BITS=64 \
  -DPLATFORM_TOOLS_VERSION='"$(PLATFORM_TOOLS_VERSION)"' \
  -Iexternal/avb \
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
  \
  -I/usr/include/android \

LDFLAGS += \
  -Ldebian/out/system \
  -L/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -lbase \
  -lcrypto \
  -lcutils \
  -llog \
  -lpthread \
  -lprotobuf \
  -lsparse \
  -lusb-1.0 \
  -lziparchive \
  -pie \

STATIC_LIBS = \
  debian/out/system/libadb.a \
  debian/out/system/extras/libext4_utils.a \

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifneq ($(filter armel mipsel,$(DEB_HOST_ARCH)),)
  LDFLAGS += -latomic
endif

debian/out/system/$(NAME): $(OBJECTS) $(STATIC_LIBS)
	$(CXX) -o $@ $^ $(LDFLAGS)

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

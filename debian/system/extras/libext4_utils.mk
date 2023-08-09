NAME = libext4_utils

# system/extras/ext4_utils/Android.bp
ext4_utils_SOURCES = \
  ext4_utils.cpp \
  wipe.cpp \
  ext4_sb.cpp \

ext4_utils_SOURCES := $(foreach source, $(ext4_utils_SOURCES), system/extras/ext4_utils/$(source))

# system/extras/squashfs_utils/Android.bp
squashfs_utils_SOURCES = \
  squashfs_utils.c \

squashfs_utils_SOURCES := $(foreach source, $(squashfs_utils_SOURCES), system/extras/squashfs_utils/$(source))

SOURCES = $(ext4_utils_SOURCES) $(squashfs_utils_SOURCES)

SOURCES_C = $(filter %.c,$(SOURCES))
OBJECTS_C = $(SOURCES_C:.c=.o)
SOURCES_CXX = $(filter %.cpp,$(SOURCES))
OBJECTS_CXX = $(SOURCES_CXX:.cpp=.o)

CPPFLAGS += \
  -D_GNU_SOURCE \
  -D_LARGEFILE64_SOURCE \
  -DFEC_NO_KLOG \
  -DSQUASHFS_NO_KLOG \
  -I/usr/include/android \
  -I/usr/include/squashfuse \
  -Isystem/core/libcutils/include \
  -Isystem/core/libsparse/include \
  -Isystem/extras/ext4_utils/include \
  -Isystem/extras/libfec/include \
  -Isystem/extras/squashfs_utils \
  -Isystem/libbase/include \

debian/out/system/extras/libext4_utils.a: $(OBJECTS_C) $(OBJECTS_CXX)
	ar -rcs $@ $^

$(OBJECTS_C): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

$(OBJECTS_CXX): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CPPFLAGS) $(CXXFLAGS)

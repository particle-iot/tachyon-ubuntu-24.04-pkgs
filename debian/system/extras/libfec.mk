NAME = libfec

SOURCES = \
  fec_open.cpp \
  fec_read.cpp \
  fec_verity.cpp \
  fec_process.cpp \

SOURCES := $(foreach source, $(SOURCES), system/extras/libfec/$(source))
OBJECTS := $(SOURCES:.cpp=.o)

CXXFLAGS += -fno-strict-aliasing -std=gnu++17
CPPFLAGS += \
            -Isystem/extras/ext4_utils/include \
            -Isystem/extras/libfec/include \
            -Isystem/extras/squashfs_utils \
            -I/usr/include/android \
            -Iexternal/selinux/libselinux/include \
            -Iexternal/boringssl/include \
            -Isystem/core/libsparse/include \
            -Isystem/core/base/include \
            -Isystem/core/libutils/include \
            -Isystem/core/libcrypto_utils/include \
            -Idebian/include/external/fec \
            -D_GNU_SOURCE -DFEC_NO_KLOG -D_LARGEFILE64_SOURCE \

debian/out/system/extras/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/system/extras
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

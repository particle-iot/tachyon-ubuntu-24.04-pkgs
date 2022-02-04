NAME = libfec

SOURCES = \
  fec_open.cpp \
  fec_read.cpp \
  fec_verity.cpp \
  fec_process.cpp \

SOURCES := $(foreach source, $(SOURCES), system/extras/libfec/$(source))
OBJECTS := $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++2a -fno-strict-aliasing
CPPFLAGS += \
  -D_GNU_SOURCE \
  -D_LARGEFILE64_SOURCE \
  -DFEC_NO_KLOG \
  -I/usr/include/android \
  -Idebian/include/external/fec \
  -Iexternal/boringssl/include \
  -Iexternal/selinux/libselinux/include \
  -Isystem/core/base/include \
  -Isystem/core/libcrypto_utils/include \
  -Isystem/core/libsparse/include \
  -Isystem/core/libutils/include \
  -Isystem/extras/ext4_utils/include \
  -Isystem/extras/libfec/include \
  -Isystem/extras/squashfs_utils \

debian/out/system/extras/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/system/extras
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

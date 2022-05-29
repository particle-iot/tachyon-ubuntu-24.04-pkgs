NAME = liblzma

sources = \
  7zCrc.c \
  7zCrcOpt.c \
  7zStream.c \
  Alloc.c \
  Bra.c \
  Bra86.c \
  BraIA64.c \
  CpuArch.c \
  Delta.c \
  LzFind.c \
  Lzma2Dec.c \
  Lzma2Enc.c \
  LzmaDec.c \
  LzmaEnc.c \
  Sha256.c \
  Xz.c \
  XzCrc64.c \
  XzCrc64Opt.c \
  XzDec.c \
  XzEnc.c \
  XzIn.c \

SOURCES := $(foreach source, $(sources), debian/external/lzma/$(source))
OBJECTS := $(SOURCES:.c=.o)

CPPFLAGS += \
  -D_7ZIP_ST \
  -Idebian/include/external/lzma \

LDFLAGS += \
  -Ldebian/out/system/core \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -shared

build: $(OBJECTS)
	mkdir -p debian/out/system/core
	$(CXX) $^ -o debian/out/system/core/$(NAME).so.0 $(LDFLAGS)
	cd debian/out/system/core && ln -s $(NAME).so.0 $(NAME).so

$(OBJECTS): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

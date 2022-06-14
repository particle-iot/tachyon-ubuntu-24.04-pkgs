NAME = liblzma

# external/lzma/C/Android.bp
sources = \
  7zAlloc.c \
  7zArcIn.c \
  7zBuf2.c \
  7zBuf.c \
  7zCrc.c \
  7zCrcOpt.c \
  7zDec.c \
  7zFile.c \
  7zStream.c \
  Aes.c \
  AesOpt.c \
  Alloc.c \
  Bcj2.c \
  Bra86.c \
  Bra.c \
  BraIA64.c \
  CpuArch.c \
  Delta.c \
  LzFind.c \
  Lzma2Dec.c \
  Lzma2Enc.c \
  Lzma86Dec.c \
  Lzma86Enc.c \
  LzmaDec.c \
  LzmaEnc.c \
  LzmaLib.c \
  Ppmd7.c \
  Ppmd7Dec.c \
  Ppmd7Enc.c \
  Sha256.c \
  Sort.c \
  Xz.c \
  XzCrc64.c \
  XzCrc64Opt.c \
  XzDec.c \
  XzEnc.c \
  XzIn.c \

SOURCES := $(foreach source, $(sources), external/lzma/C/$(source))
OBJECTS := $(SOURCES:.c=.o)

CPPFLAGS += \
  -D_7ZIP_ST \
  -Iexternal/lzma/C \
  -Wno-empty-body \
  -Wno-enum-conversion \
  -Wno-logical-op-parentheses \
  -Wno-self-assign \

LDFLAGS += \
  -Wl,-soname,$(NAME).so.0 \
  -shared

build: $(OBJECTS)
	$(CXX) $^ -o debian/out/external/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/external/$(NAME).so

$(OBJECTS): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

include external/boringssl/sources.mk

NAME = libcrypto

amd64_SOURCES = $(linux_x86_64_sources)
arm64_SOURCES = $(linux_aarch64_sources)
armel_SOURCES = $(linux_arm_sources)
armhf_SOURCES = $(linux_arm_sources)
i386_SOURCES = $(linux_x86_sources)
ppcel64_SOURCES = $(linux_ppc64le_sources)

SOURCES = $(crypto_sources) $($(DEB_HOST_ARCH)_SOURCES)
SOURCES := $(foreach source, $(SOURCES), external/boringssl/$(source))

SOURCES_C = $(filter %.c,$(SOURCES))
OBJECTS_C = $(SOURCES_C:.c=.o)
SOURCES_ASSEMBLY = $(filter %.S,$(SOURCES))
OBJECTS_ASSEMBLY = $(SOURCES_ASSEMBLY:.S=.o)

CFLAGS += \
  -D_XOPEN_SOURCE=700 \
  -DBORINGSSL_ANDROID_SYSTEM \
  -DBORINGSSL_IMPLEMENTATION \
  -DBORINGSSL_SHARED_LIBRARY \
  -DOPENSSL_SMALL \
  -fvisibility=hidden \
  -Wa,--noexecstack # Fixes `shlib-with-executable-stack`, see `src/util/BUILD.toplevel`

CPPFLAGS += -Iexternal/boringssl/src/include -Iexternal/boringssl/src/crypto

debian/out/external/boringssl/$(NAME).a: $(OBJECTS_C) $(OBJECTS_ASSEMBLY)
	mkdir --parents debian/out/external/boringssl
	ar -rcs $@ $^

$(OBJECTS_C): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

$(OBJECTS_ASSEMBLY): %.o: %.S
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

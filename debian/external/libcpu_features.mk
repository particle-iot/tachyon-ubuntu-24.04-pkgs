NAME = libcpu_features

# external/cpu_features/Android.bp
sources = \
  filesystem.c \
  stack_line_reader.c \
  string_view.c \
  hwcaps.c \

ifeq ($(DEB_HOST_ARCH), amd64)
  sources += impl_x86_linux_or_android.c
endif
ifeq ($(DEB_HOST_ARCH), i386)
  sources += impl_x86_linux_or_android.c
endif
ifeq ($(DEB_HOST_ARCH), armhf)
  sources += impl_arm_linux_or_android.c
endif
ifeq ($(DEB_HOST_ARCH), arm64)
  sources += impl_aarch64_linux_or_android.c
endif

SOURCES := $(foreach source, $(sources), external/cpu_features/src/$(source))
OBJECTS := $(SOURCES:.c=.o)

CPPFLAGS += \
  -DHAVE_DLFCN_H \
  -DHAVE_STRONG_GETAUXVAL \
  -DSTACK_LINE_READER_BUFFER_SIZE=1024 \
  -Iexternal/cpu_features/include \

LDFLAGS += \
  -Wl,-soname,$(NAME).so.0 \
  -shared

build: $(OBJECTS)
	$(CXX) $^ -o debian/out/external/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/external/$(NAME).so

$(OBJECTS): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

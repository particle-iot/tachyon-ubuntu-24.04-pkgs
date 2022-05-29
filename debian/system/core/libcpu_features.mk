NAME = libcpu_features

sources = \
  filesystem.c \
  stack_line_reader.c \
  string_view.c \
#  hwcaps.c \

ifeq ($(DEB_HOST_ARCH), amd64)
  sources += cpuinfo_x86.c
endif
ifeq ($(DEB_HOST_ARCH), i386)
  sources += cpuinfo_x86.c
endif
ifeq ($(DEB_HOST_ARCH), armhf)
  sources += cpuinfo_arm.c
endif
ifeq ($(DEB_HOST_ARCH), arm64)
  sources += cpuinfo_aarch64.c
endif

SOURCES := $(foreach source, $(sources), external/cpu_features/src/$(source))
OBJECTS := $(SOURCES:.c=.o)

CPPFLAGS += \
  -DSTACK_LINE_READER_BUFFER_SIZE=1024 \
  -Iexternal/cpu_features/include \

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

NAME = libnativehelper

SOURCES = \
  DlHelp.c \
  ExpandableString.c \
  JNIHelp.c \
  JNIPlatformHelp.c \
  JniConstants.c \
  JniInvocation.c \
  file_descriptor_jni.c \

SOURCES := $(foreach source, $(SOURCES), libnativehelper/$(source))
OBJECTS = $(SOURCES:.c=.o)

CPPFLAGS += \
  -I/usr/include/android \
  -Ilibnativehelper/header_only_include \
  -Ilibnativehelper/include \
  -Ilibnativehelper/include_jni \
  -Isystem/libbase/include \
  -Isystem/logging/liblog/include \

LDFLAGS += \
  -Ldebian/out/system \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -ldl \
  -llog \
  -lpthread \
  -shared

build: $(OBJECTS)
	$(CXX) $^ -o debian/out/libnativehelper/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/libnativehelper/$(NAME).so

$(OBJECTS): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

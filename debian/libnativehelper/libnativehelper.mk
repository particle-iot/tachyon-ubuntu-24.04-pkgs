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

debian/out/libnativehelper/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/libnativehelper
	ar -rcs $@ $^

$(OBJECTS): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

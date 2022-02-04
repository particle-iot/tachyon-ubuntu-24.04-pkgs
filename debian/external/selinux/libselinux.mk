NAME = libselinux

cc_defaults_srcs = \
  src/booleans.c \
  src/callbacks.c \
  src/freecon.c \
  src/label_backends_android.c \
  src/label.c \
  src/label_support.c \
  src/matchpathcon.c \
  src/setrans_client.c \
  src/sha1.c \

cc_library_srcs = \
  src/label_file.c \
  src/regex.c \

cc_library_target_linux_srcs = \
  src/avc.c \
  src/avc_internal.c \
  src/avc_sidtab.c \
  src/compute_av.c \
  src/compute_create.c \
  src/compute_member.c \
  src/context.c \
  src/deny_unknown.c \
  src/enabled.c \
  src/fgetfilecon.c \
  src/getenforce.c \
  src/getfilecon.c \
  src/get_initial_context.c \
  src/init.c \
  src/lgetfilecon.c \
  src/load_policy.c \
  src/lsetfilecon.c \
  src/mapping.c \
  src/procattr.c \
  src/reject_unknown.c \
  src/setenforce.c \
  src/setexecfilecon.c \
  src/setfilecon.c \
  src/stringrep.c \

cc_extra = \
  src/setenforce.c \
  src/lsetfilecon.c \
  src/selinux_config.c \
  src/policyvers.c \
  src/check_context.c \
  src/lgetfilecon.c \
  src/disable.c \
  src/seusers.c \
  src/canonicalize_context.c \

SOURCES = $(cc_defaults_srcs) $(cc_library_srcs) $(cc_library_target_linux_srcs) $(cc_extra)
SOURCES := $(foreach source, $(SOURCES), external/selinux/libselinux/$(source))
OBJECTS = $(SOURCES:.c=.o)

CPPFLAGS += \
  -D_GNU_SOURCE \
  -DBUILD_HOST \
  -DDISABLE_BOOL \
  -DDISABLE_SETRANS \
  -DHOST \
  -DNO_DB_BACKEND \
  -DNO_MEDIA_BACKEND \
  -DNO_PERSISTENTLY_STORED_PATTERNS \
  -DNO_X_BACKEND \
  -Iexternal/selinux/libselinux/include \
  -Iexternal/selinux/libsepol/include \

debian/out/external/selinux/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/external/selinux
	ar -rcs $@ $^

$(OBJECTS): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

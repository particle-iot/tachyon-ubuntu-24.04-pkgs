NAME = libcutils

# system/core/libcutils/Android.bp
libcutils_sockets_sources = \
  sockets.cpp \
  \
  socket_inaddr_any_server_unix.cpp \
  socket_local_client_unix.cpp \
  socket_local_server_unix.cpp \
  socket_network_client_unix.cpp \
  sockets_unix.cpp \

libcutils_nonwindows_sources = \
  fs.cpp \
  hashmap.cpp \
  multiuser.cpp \
  str_parms.cpp \

cc_library_srcs = \
  config_utils.cpp \
  iosched_policy.cpp \
  load_file.cpp \
  native_handle.cpp \
  properties.cpp \
  record_stream.cpp \
  strlcpy.c \

cc_library_target_not_windows_srcs = \
  ashmem-host.cpp \
  canned_fs_config.cpp \
  fs_config.cpp \
  trace-host.cpp \

SOURCES = \
  $(libcutils_sockets_sources) \
  $(libcutils_nonwindows_sources) \
  $(cc_library_srcs) \
  $(cc_library_target_not_windows_srcs) \

SOURCES_C := $(foreach source, $(filter %.c, $(SOURCES)), system/core/libcutils/$(source))
OBJECTS_C := $(SOURCES_C:.c=.o)
SOURCES_CXX := $(foreach source, $(filter %.cpp, $(SOURCES)), system/core/libcutils/$(source))
OBJECTS_CXX := $(SOURCES_CXX:.cpp=.o)

CPPFLAGS += \
  -Isystem/core/include \
  -Isystem/core/libcutils/include \
  -Isystem/libbase/include \
  -Isystem/logging/liblog/include \

LDFLAGS += \
  -Ldebian/out/system \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -lbase \
  -llog \
  -lpthread \
  -shared

build: $(OBJECTS_C) $(OBJECTS_CXX)
	$(CXX) $^ -o debian/out/system/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/system/$(NAME).so

$(OBJECTS_C): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

$(OBJECTS_CXX): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

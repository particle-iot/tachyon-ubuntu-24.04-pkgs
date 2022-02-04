NAME = libcutils

libcutils_nonwindows_sources = \
  fs.cpp \
  hashmap.cpp \
  multiuser.cpp \
  socket_inaddr_any_server_unix.cpp \
  socket_local_client_unix.cpp \
  socket_local_server_unix.cpp \
  socket_network_client_unix.cpp \
  sockets_unix.cpp \
  str_parms.cpp \

cc_library_srcs = \
  config_utils.cpp \
  canned_fs_config.cpp \
  iosched_policy.cpp \
  load_file.cpp \
  native_handle.cpp \
  record_stream.cpp \
  sockets.cpp \
  strlcpy.c \
  threads.cpp \

cc_library_target_not_windows_srcs = \
  ashmem-host.cpp \
  fs_config.cpp \
  trace-host.cpp \

SOURCES = \
  $(libcutils_nonwindows_sources) \
  $(cc_library_srcs) \
  $(cc_library_target_not_windows_srcs)


SOURCES_C := $(foreach source, $(filter %.c, $(SOURCES)), system/core/libcutils/$(source))
OBJECTS_C := $(SOURCES_C:.c=.o)
SOURCES_CXX := $(foreach source, $(filter %.cpp, $(SOURCES)), system/core/libcutils/$(source))
OBJECTS_CXX := $(SOURCES_CXX:.cpp=.o)

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -I/usr/include/android \
  -Isystem/core/base/include \
  -Isystem/core/libcutils/include \
  -Isystem/core/liblog/include \
  -Isystem/core/include \

debian/out/system/core/$(NAME).a: $(OBJECTS_C) $(OBJECTS_CXX)
	mkdir --parents debian/out/system/core
	ar -rcs $@ $^

$(OBJECTS_C): %.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

$(OBJECTS_CXX): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

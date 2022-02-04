NAME = adb

SOURCES = \
  client/adb_client.cpp \
  client/bugreport.cpp \
  client/commandline.cpp \
  client/file_sync_client.cpp \
  client/main.cpp \
  client/console.cpp \
  client/adb_install.cpp \
  client/line_printer.cpp \
  shell_service_protocol.cpp \

SOURCES := $(foreach source, $(SOURCES), system/core/adb/$(source))
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -D_GNU_SOURCE \
  -DADB_HOST=1 \
  -DADB_VERSION='"$(DEB_VERSION)"' \
  -I/usr/include/android \
  -Iexternal/boringssl/include \
  -Isystem/core/adb \
  -Isystem/core/base/include \
  -Isystem/core/include \

LDFLAGS += -lpthread -lusb-1.0
STATIC_LIBS = \
  debian/out/system/core/libadb.a \
  debian/out/system/core/libcutils.a \
  debian/out/system/core/libbase.a \
  debian/out/system/core/liblog.a \
  debian/out/system/core/libcrypto_utils.a \
  debian/out/external/boringssl/libcrypto.a \

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifneq ($(filter armel mipsel,$(DEB_HOST_ARCH)),)
  LDFLAGS += -latomic
endif

debian/out/system/core/$(NAME): $(OBJECTS)
	mkdir --parents debian/out/system/core
	$(CXX) -o $@ $^ $(CXXFLAGS) $(CPPFLAGS) $(STATIC_LIBS) $(LDFLAGS)

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

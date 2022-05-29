NAME = liblog

liblog_sources = \
  log_event_list.cpp \
  log_event_write.cpp \
  logger_name.cpp \
  logger_read.cpp \
  logger_write.cpp \
  logprint.cpp \
  properties.cpp \

not_windows_sources = \
  event_tag_map.cpp \

SOURCES = $(liblog_sources) $(not_windows_sources)
SOURCES := $(foreach source, $(SOURCES), system/logging/liblog/$(source))
OBJECTS := $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++2a -fcommon
CPPFLAGS += \
  -DFAKE_LOG_DEVICE=1 \
  -DLIBLOG_LOG_TAG=1006 \
  -DSNET_EVENT_LOG_TAG=1397638484 \
  -I/usr/include/android \
  -Isystem/core/include \
  -Isystem/core/libcutils/include \
  -Isystem/libbase/include \
  -Isystem/logging/liblog/include \

LDFLAGS += \
  -Ldebian/out/system/core \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -Wl,-soname,$(NAME).so.0 \
  -lpthread \
  -shared

build: $(OBJECTS)
	mkdir -p debian/out/system/core
	$(CXX) $^ -o debian/out/system/core/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/system/core/$(NAME).so

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

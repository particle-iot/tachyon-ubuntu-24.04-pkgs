NAME = liblog

# system/logging/liblog/Android.bp
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

CXXFLAGS += -fcommon
CPPFLAGS += \
  -DLIBLOG_LOG_TAG=1006 \
  -DSNET_EVENT_LOG_TAG=1397638484 \
  -Isystem/core/include \
  -Isystem/core/libcutils/include \
  -Isystem/libbase/include \
  -Isystem/logging/liblog/include \

LDFLAGS += \
  -Wl,-soname,$(NAME).so.0 \
  -lpthread \
  -shared

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifneq ($(filter armel mipsel,$(DEB_HOST_ARCH)),)
  LDFLAGS += -latomic
endif

build: $(OBJECTS)
	$(CXX) $^ -o debian/out/system/$(NAME).so.0 $(LDFLAGS)
	ln -sf $(NAME).so.0 debian/out/system/$(NAME).so

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

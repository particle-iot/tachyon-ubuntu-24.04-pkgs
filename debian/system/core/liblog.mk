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
SOURCES := $(foreach source, $(SOURCES), system/core/liblog/$(source))
OBJECTS := $(SOURCES:.cpp=.o)

CFLAGS += -fvisibility=hidden -fcommon
CXXFLAGS += -std=gnu++17
CPPFLAGS += \
  -Isystem/core/liblog/include \
  -Isystem/core/include \
  -Isystem/core/base/include \
  -I/usr/include/android \
  -DLIBLOG_LOG_TAG=1006 \
  -DFAKE_LOG_DEVICE=1 \
  -DSNET_EVENT_LOG_TAG=1397638484 \

debian/out/system/core/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/system/core
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

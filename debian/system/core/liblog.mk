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

CXXFLAGS += -std=gnu++2a -fcommon -fvisibility=hidden
CPPFLAGS += \
  -DFAKE_LOG_DEVICE=1 \
  -DLIBLOG_LOG_TAG=1006 \
  -DSNET_EVENT_LOG_TAG=1397638484 \
  -I/usr/include/android \
  -Isystem/core/base/include \
  -Isystem/core/include \
  -Isystem/core/liblog/include \

debian/out/system/core/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/system/core
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

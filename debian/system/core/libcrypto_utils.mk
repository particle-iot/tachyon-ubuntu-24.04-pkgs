NAME:= libcrypto_utils

SOURCES = system/core/libcrypto_utils/android_pubkey.cpp
OBJECTS = $(SOURCES:.cpp=.o)

CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
  -I/usr/include/android \
  -Isystem/core/include \
  -Isystem/core/libcrypto_utils/include \

debian/out/system/core/$(NAME).a: $(OBJECTS)
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

NAME:= libcrypto_utils

SOURCES = system/core/libcrypto_utils/android_pubkey.cpp
OBJECTS = $(SOURCES:.cpp=.o)

CPPFLAGS += \
  -Isystem/core/include \
  -Isystem/core/libcrypto_utils/include \
  \
  -I/usr/include/android \

debian/out/system/$(NAME).a: $(OBJECTS)
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cpp
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

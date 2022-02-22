NAME = libssl

SOURCES = \
  src/ssl/bio_ssl.cc \
  src/ssl/d1_both.cc \
  src/ssl/d1_lib.cc \
  src/ssl/d1_pkt.cc \
  src/ssl/d1_srtp.cc \
  src/ssl/dtls_method.cc \
  src/ssl/dtls_record.cc \
  src/ssl/handoff.cc \
  src/ssl/handshake.cc \
  src/ssl/handshake_client.cc \
  src/ssl/handshake_server.cc \
  src/ssl/s3_both.cc \
  src/ssl/s3_lib.cc \
  src/ssl/s3_pkt.cc \
  src/ssl/ssl_aead_ctx.cc \
  src/ssl/ssl_asn1.cc \
  src/ssl/ssl_buffer.cc \
  src/ssl/ssl_cert.cc \
  src/ssl/ssl_cipher.cc \
  src/ssl/ssl_file.cc \
  src/ssl/ssl_key_share.cc \
  src/ssl/ssl_lib.cc \
  src/ssl/ssl_privkey.cc \
  src/ssl/ssl_session.cc \
  src/ssl/ssl_stat.cc \
  src/ssl/ssl_transcript.cc \
  src/ssl/ssl_versions.cc \
  src/ssl/ssl_x509.cc \
  src/ssl/t1_enc.cc \
  src/ssl/t1_lib.cc \
  src/ssl/tls13_both.cc \
  src/ssl/tls13_client.cc \
  src/ssl/tls13_enc.cc \
  src/ssl/tls13_server.cc \
  src/ssl/tls_method.cc \
  src/ssl/tls_record.cc \

SOURCES := $(foreach source, $(SOURCES), external/boringssl/$(source))
OBJECTS = $(SOURCES:.cc=.o)

CXXFLAGS += -std=gnu++2a \
  -fno-common \
  -fvisibility=hidden \
  -Wa,--noexecstack # Fixes `shlib-with-executable-stack`, see `src/util/BUILD.toplevel`

CPPFLAGS += \
  -D_XOPEN_SOURCE=700 \
  -DBORINGSSL_ANDROID_SYSTEM \
  -DBORINGSSL_IMPLEMENTATION \
  -DOPENSSL_SMALL \
  -Iexternal/boringssl/src/include \

debian/out/external/boringssl/$(NAME).a: $(OBJECTS)
	mkdir --parents debian/out/external/boringssl
	ar -rcs $@ $^

$(OBJECTS): %.o: %.cc
	$(CXX) -c -o $@ $< $(CXXFLAGS) $(CPPFLAGS)

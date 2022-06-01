NAME = hprof-conv

# dalvik/tools/hprof-conv/Android.bp
SOURCES = dalvik/tools/hprof-conv/HprofConv.c

debian/out/dalvik/tools/$(NAME): $(SOURCES)
	mkdir -p debian/out/dalvik/tools
	$(CC) -o $@ $^ $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)

NAME = hprof-conv

SOURCES = dalvik/tools/hprof-conv/HprofConv.c

debian/out/dalvik/tools/$(NAME): $(SOURCES)
	mkdir --parents debian/out/dalvik/tools
	$(CC) -o $@ $^ $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)

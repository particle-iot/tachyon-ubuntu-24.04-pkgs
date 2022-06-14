NAME = hprof-conv

# dalvik/tools/hprof-conv/Android.bp
SOURCES = dalvik/tools/hprof-conv/HprofConv.c
LDFLAGS += -pie

debian/out/dalvik/tools/$(NAME): $(SOURCES)
	$(CC) -o $@ $^ $(CFLAGS) $(CPPFLAGS) $(LDFLAGS)

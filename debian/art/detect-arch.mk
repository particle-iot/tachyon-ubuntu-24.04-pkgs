# More info see: /usr/share/dpkg/cputable

ifeq ($(DEB_HOST_ARCH), amd64)
  CPU = x86_64
endif
ifeq ($(DEB_HOST_ARCH), i386)
  CPU = x86
endif
ifeq ($(DEB_HOST_ARCH), armel)
  CPU = arm
endif
ifeq ($(DEB_HOST_ARCH), armhf)
  CPU = arm
endif
ifeq ($(DEB_HOST_ARCH), arm64)
  CPU = arm64
endif
ifeq ($(DEB_HOST_ARCH), mips)
  CPU = mips
endif
ifeq ($(DEB_HOST_ARCH), mipsel)
  CPU = mips
endif
ifeq ($(DEB_HOST_ARCH), mips64el)
  CPU = mips64
endif
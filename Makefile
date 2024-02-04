export ARCHS = arm64 arm64e
export TARGET = iphone:clang:14.0
export SYSROOT = $(THEOS)/sdks/iPhoneOS14.1.sdk

FINALPACKAGE = 0
DEBUG = 1
STRIP = 1

TWEAK_NAME=nosigninthanks
$(TWEAK_NAME)_FILES = nosigninthanks.xm
$(TWEAK_NAME)_CFLAGS += -fobjc-arc
INSTALL_TARGET_PROCESSES = $(BUNDLE_IDENTIFIER)

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
ARCHS = armv7 armv7s arm64 arm64e
TARGET = iphone:clang:11.2:8.0
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libimagepicker
libimagepicker_FILES = libimagepicker.mm LIPImageChooseCell.m
libimagepicker_FRAMEWORKS = UIKit Preferences Photos MobileCoreServices
libimagepicker_LDFLAGS += -FFrameworks/
libimagepicker_CFLAGS = -fobjc-arc

after-install::
	install.exec "killall -9 Preferences"

include $(THEOS_MAKE_PATH)/library.mk

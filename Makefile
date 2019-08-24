ARCHS = armv7 armv7s arm64 arm64e
TARGET = iphone:clang:latest:8.0

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libimagepicker
libimagepicker_FILES = libimagepicker.mm LIPImageChooseCell.m
libimagepicker_FRAMEWORKS = UIKit Preferences Photos MobileCoreServices
libimagepicker_LDFLAGS += -FFrameworks/
libimagepicker_CFLAGS = -fobjc-arc

after-install::
	install.exec "killall -9 Preferences"

include $(THEOS_MAKE_PATH)/library.mk

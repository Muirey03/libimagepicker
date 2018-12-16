ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libimagepicker
libimagepicker_FILES = libimagepicker.mm LIPImageChooseCell.m
libimagepicker_PRIVATE_FRAMEWORKS = Preferences
libimagepicker_FRAMEWORKS = UIKit Photos MobileCoreServices
libimagepicker_CFLAGS = -fobjc-arc

after-install::
	install.exec "killall -9 Preferences"

include $(THEOS_MAKE_PATH)/library.mk

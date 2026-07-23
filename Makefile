TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = IzenPopup
IzenPopup_FILES = Tweak.x
IzenPopup_FRAMEWORKS = UIKit WebKit
IzenPopup_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk

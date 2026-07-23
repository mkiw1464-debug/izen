export THEOS = $(shell echo ~/theos)
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = zenpopup
zenpopup_FILES = Tweak.xm
zenpopup_CFLAGS = -fobjc-arc
zenpopup_FRAMEWORKS = UIKit WebKit

include $(THEOS_MAKE_PATH)/tweak.mk

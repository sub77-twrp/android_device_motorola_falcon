# MultiROM
include device/motorola/falcon/multirom/versioning/MR_REC_VERSION.mk
ifeq ($(MR_REC_VERSION),)
MR_REC_VERSION := $(shell date -u +%Y%m%d)-01
endif
BOARD_MKBOOTIMG_ARGS += --board mrom$(MR_REC_VERSION)

ifndef MR_CUSTOM_THEME
    TW_THEME := portrait_hdpi
else
    TW_CUSTOM_THEME := $(MR_CUSTOM_THEME)
endif

MR_INFOS := device/motorola/falcon/multirom/infos
MR_DEVICE_HOOKS := device/motorola/falcon/multirom/mr_hooks.c
MR_DEVICE_HOOKS_VER := 4

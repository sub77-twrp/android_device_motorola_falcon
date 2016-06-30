# MultiROM
include device/motorola/falcon/multirom/versioning/MR_REC_VERSION.mk
ifeq ($(MR_REC_VERSION),)
MR_REC_VERSION := $(shell date -u +%Y%m%d)-01
endif
BOARD_MKBOOTIMG_ARGS += --board mrom$(MR_REC_VERSION)

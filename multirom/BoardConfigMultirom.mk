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
MR_FSTAB := device/motorola/falcon/multirom/mrom.fstab
MR_INIT_DEVICES := device/motorola/falcon/multirom/mr_init_devices.c

RECOVERY_GRAPHICS_USE_LINELENGTH := true
MR_USE_QCOM_OVERLAY := true
MR_PIXEL_FORMAT := "RGBX_8888"
MR_QCOM_OVERLAY_HEADER := device/motorola/falcon/multirom/overlay/mr_qcom_overlay.h
MR_QCOM_OVERLAY_CUSTOM_PIXEL_FORMAT := MDP_RGBX_8888

MR_INPUT_TYPE := type_b
MR_DPI := hdpi
MR_DPI_FONT := 160
MR_KEXEC_DTB := true
MR_CONTINUOUS_FB_UPDATE := false

MR_ALLOW_NKK71_NOKEXEC_WORKAROUND := true
MR_DEV_BLOCK_BOOTDEVICE := true

MR_KEXEC_MEM_MIN := 0x05000000

MR_DEVICE_VARIANTS := xt1031 xt1032 xt1033 xt1034 falcon_umts falcon_umtsds falcon_cdma falcon_retuaws falcon falcon_gpe

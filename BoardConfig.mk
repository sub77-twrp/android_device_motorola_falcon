# Options
# Added TARGET_KERNEL_SOURCE
# Added TARGET_KERNEL_LLCON
# Added TARGET_KERNEL_TESTCONFIG
# Added TARGET_PREBUILT_TESTKERNEL
# Added COMPRESS_RAMDISK (xz,lzma)
# Added TW_DEVICE_SPECIFIC_VERSION
# Added TW_CUSTOM_TESTTHEME
# Added TARGET_RECOVERY_IS_MULTIROM

-include device/motorola/falcon/BoardConfigOptions.mk

# Bootloader
TARGET_NO_BOOTLOADER := true
TARGET_BOOTLOADER_BOARD_NAME := MSM8226

# Platform
TARGET_BOARD_PLATFORM := msm8226
TARGET_BOARD_PLATFORM_GPU := qcom-adreno305

# Architecture
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
TARGET_CPU_VARIANT := krait
ARCH_ARM_HAVE_TLS_REGISTER := true

# Kernel Common
BOARD_CUSTOM_BOOTIMG_MK := device/motorola/falcon/mkbootimg.mk
BOARD_KERNEL_CMDLINE := androidboot.bootdevice=msm_sdcc.1 androidboot.hardware=qcom vmalloc=400M androidboot.selinux=permissive
BOARD_KERNEL_PAGESIZE := 2048
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x01000000
# Kernel Inline
ifdef TARGET_KERNEL_SOURCE
ifndef TARGET_KERNEL_TESTCONFIG
    TARGET_KERNEL_CONFIG := falcon_defconfig
else
    TARGET_KERNEL_CONFIG := $(TARGET_KERNEL_TESTCONFIG)
endif
    BOARD_KERNEL_IMAGE_NAME := zImage-dtb
endif
# Kernel Prebuilt
ifndef TARGET_KERNEL_SOURCE
ifndef TARGET_PREBUILT_TESTKERNEL
    TARGET_PREBUILT_KERNEL := device/motorola/falcon/zImage-dtb
else
    TARGET_PREBUILT_KERNEL := $(TARGET_PREBUILT_TESTKERNEL)
endif
    TARGET_CUSTOM_KERNEL_HEADERS := device/motorola/falcon/include
endif
# Kernel Low Level Console
ifdef TARGET_KERNEL_LLCON
    BOARD_KERNEL_CMDLINE += androidboot.llcon=2,100,0,0x00,24,1280,720,720,8,0
endif

# Init
TARGET_INCREASES_COLDBOOT_TIMEOUT := true

# Recovery
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_HAS_NO_REAL_SDCARD := true
RECOVERY_SDCARD_ON_DATA := true

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 10485760
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 10485760
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1023410176
BOARD_USERDATAIMAGE_PARTITION_SIZE := 5930598400 # 5930614784 - 16384
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64) macro
BOARD_SUPPRESS_SECURE_ERASE := true

# TWRP
TW_DEFAULT_EXTERNAL_STORAGE := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_EXCLUDE_SUPERSU := true
TW_IGNORE_MAJOR_AXIS_0 := true
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_NTFS_3G := true
TW_NO_USB_STORAGE := true
TW_TARGET_USES_QCOM_BSP := true
ifndef TW_CUSTOM_TESTTHEME
    TW_THEME := portrait_hdpi
else
    TW_CUSTOM_THEME := $(TW_CUSTOM_TESTTHEME)
endif

# MultiROM
ifeq ($(TARGET_RECOVERY_IS_MULTIROM),true)
       -include device/motorola/falcon/multirom/BoardConfigMultirom.mk
endif

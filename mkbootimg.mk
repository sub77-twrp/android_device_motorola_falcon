LOCAL_PATH := $(call my-dir)
LZMA_BIN := /usr/bin/lzma
FLASH_IMAGE_IMG := twrp-$(TW_DEVICE_SPECIFIC_VERSION)_$(TARGET_DEVICE)_$(shell date -u +%Y%m%d-%H%M).img
KERNEL_CONFIG := $(KERNEL_OUT)/.config

## Overload recoveryimg generation: Same as the original
$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) \
		$(recovery_ramdisk) \
		$(recovery_uncompressed_ramdisk) \
		$(recovery_kernel)
	@echo -e ${CL_GRN}"----- Compressing recovery ramdisk with lzma ------"${CL_RST}
	$(hide) rm -f $(OUT)/ramdisk-recovery.cpio.lzma
	$(LZMA_BIN) $(recovery_uncompressed_ramdisk)
	$(hide) cp $(recovery_uncompressed_ramdisk).lzma $(recovery_ramdisk)
	@echo -e ${CL_CYN}"----- Making recovery image ------"${CL_RST}
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made recovery image: $@"${CL_RST}
	$(hide) cp $(PRODUCT_OUT)/recovery.img $(PRODUCT_OUT)/$(FLASH_IMAGE_IMG)
	@echo -e ${PRT_IMG}"----- Made recovery image: $(PRODUCT_OUT)/$(FLASH_IMAGE_IMG) --------"${CL_RST}

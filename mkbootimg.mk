#
# Copyright 2016 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

LZMA_RAMDISK := $(PRODUCT_OUT)/ramdisk-recovery-lzma.img
LZMA_BIN := $(shell which lzma)

ifdef TW_DEVICE_SPECIFIC_VERSION
	TWRP_VERSION := $(TW_DEVICE_SPECIFIC_VERSION)
else
	TWRP_VERSION := $(shell cat bootable/recovery/variables.h | grep TW_VERSION_STR | cut -d\" -f2)
endif

TWRP_NAME := twrp-$(TWRP_VERSION)-$(TARGET_DEVICE)

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(PREBUILT_DTIMAGE_TARGET)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made boot image: $@"${CL_RST}

$(LZMA_RAMDISK): $(recovery_ramdisk)
	$(hide) gunzip -f < $(recovery_ramdisk) | $(LZMA_BIN) > $@

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(PREBUILT_DTIMAGE_TARGET) \
		$(LZMA_RAMDISK) \
		$(recovery_kernel)
	@echo -e ${CL_CYN}"----- Making recovery image ------"${CL_RST}
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@ --ramdisk $(LZMA_RAMDISK)
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made recovery image: $@"${CL_RST}
	cd $(PRODUCT_OUT) && mv recovery.img $(TWRP_NAME)-$(shell date -u +%Y%m%d-%H%M).img
	@echo -e ${PRT_IMG}"----- Made recovery image: $(PRODUCT_OUT)/$(TWRP_NAME)-$(shell date -u +%Y%m%d-%H%M).img --------"${CL_RST}

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

define assert-max-image-size-sub
$(if $(2), \
  $(call assert-max-file-size-sub,$(1),$(call image-size-from-data-size,$(2))))
endef

define assert-max-file-size-sub
$(if $(2), \
  size=$$(for i in $(1); do $(call get-file-size,$$i); echo +; done; echo 0); \
  total=$$(( $$( echo "$$size" ) )); \
  printname=$$(echo -n "$(1)" | tr " " +); \
  img_blocksize=$(call image-size-from-data-size,$(BOARD_FLASH_BLOCK_SIZE)); \
  twoblocks=$$((img_blocksize * 2)); \
  onepct=$$((((($(2) / 100) - 1) / img_blocksize + 1) * img_blocksize)); \
  reserve=$$((twoblocks > onepct ? twoblocks : onepct)); \
  maxsize=$$(($(2) - reserve)); \
  export TEST1="*** $$printname \n* maxsize=$$maxsize \nblocksize=$$img_blocksize \ntotal=$$total \n* reserve=$$reserve"; \
  if [ "$$total" -gt "$$maxsize" ]; then \
    echo "error: $$printname too large ($$total > [$(2) - $$reserve])"; \
    false; \
  elif [ "$$total" -gt $$((maxsize - 32768)) ]; then \
    echo "WARNING: $$printname approaching size limit ($$total now; limit $$maxsize)"; \
  fi \
 , \
  true \
 )
endef

LZMA_BIN := $(shell which lzma)
FLASH_IMAGE_IMG := twrp-$(TW_DEVICE_SPECIFIC_VERSION)_$(TARGET_DEVICE)_$(shell date -u +%Y%m%d-%H%M).img

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) \
		$(recovery_uncompressed_ramdisk) \
		$(recovery_kernel)
	@echo -e ${PRT_IMG}"Making compressed recovery ramdisk"${CL_RST}
	$(hide) $(LZMA_BIN) < $(recovery_uncompressed_ramdisk) > $(recovery_ramdisk)
	@echo -e ${PRT_IMG}"Making recovery image"${CL_RST}
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-image-size-sub,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE))
	$(hide) cp $(PRODUCT_OUT)/recovery.img $(PRODUCT_OUT)/$(FLASH_IMAGE_IMG)
	@echo -e ${PRT_IMG}"\nMade recovery image: $(PRODUCT_OUT)/$(FLASH_IMAGE_IMG) .\n"${CL_RST}
	@echo $$TEST1
	@echo $$printname

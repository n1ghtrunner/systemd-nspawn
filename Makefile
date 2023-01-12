#!/usr/bin/make

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

BUILD_DIR := build
MACHINE_DIR := machines

MACHINES := $(shell cd $(MACHINE_DIR); echo *)

help: ;
	@echo "make <one of: $(MACHINES)>"

toolcheck:
	@which debootstrap > /dev/null
	@which systemd-nspawn > /dev/null
	@which file-rename > /dev/null
	@which crudini > /dev/null

# generate target for each defined machine
# <machine>: $(BUILD_DIR)/<machine>
$(foreach machine,$(MACHINES),$(eval $(machine): $(BUILD_DIR)/$(machine)))

$(BUILD_DIR)/%: machines/% mkosi.cache
	@export IMAGE_ID=$(*); export $(shell cat $(<) | xargs); ./create_mkosi_instance_from_template

define build_targets_template =
build_$(1): $(BUILD_DIR)/$(1)
	@$(MAKE) -C $(BUILD_DIR)/$(1)
endef
$(foreach machine,$(MACHINES),$(eval $(call build_targets_template,$(machine))))

define boot_targets_template =
boot_$(1):
	@$(MAKE) -C $(BUILD_DIR)/$(1) mkosi_boot
endef
$(foreach machine,$(MACHINES),$(eval $(call boot_targets_template,$(machine))))

define clean_targets_template =
clean_$(1):
	@sudo rm -rf $(BUILD_DIR)/$(1)
endef
$(foreach machine,$(MACHINES),$(eval $(call clean_targets_template,$(machine))))

mkosi.cache:
	@mkdir mkosi.cache

clean:
	@sudo rm -rf $(BUILD_DIR)

distclean: clean
	@sudo rm -rf mkosi.cache

.PHONY: help clean distclean

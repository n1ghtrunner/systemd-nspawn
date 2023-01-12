#!/usr/bin/make

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

MKOSI_SRC := $(mkfile_dir)/mkosi_src

MACHINE := $(shell crudini --get mkosi.conf Output ImageId)

all: mkosi mkosi_build

nonrootcheck:
ifeq ($(shell id -u), 0)
	$(error "please execute with your normal user account, not root")
endif

mkosi:
	./helper/build_mkosi $(mkfile_dir)/mkosi

mkosi_build: mkosi
	@sudo ./mkosi build
	@touch mkosi_build

mkosi_boot: mkosi
	@sudo ./mkosi boot

mkosi_shell: mkosi
	@sudo ./mkosi shell

mkosi_clean: mkosi
	@sudo ./mkosi clean

crudini: ; 
	@which crudini > /dev/null

machinectl_import: crudini
	@sudo mkdir -p /etc/systemd/nspawn
	@sudo cp $(MACHINE).nspawn /etc/systemd/nspawn
	@sudo machinectl import-fs $(MACHINE)

machinectl_remove: crudini
	@sudo machinectl remove $(MACHINE)

machinectl_start: crudini
	@sudo machinectl start $(MACHINE)

machinectl_poweroff: crudini
	@sudo machinectl poweroff $(MACHINE)

machinectl_login: crudini
	@sudo machinectl login $(MACHINE)

machinectl_enable: crudini
	@sudo machinectl enable $(MACHINE)

machinectl_disable: crudini
	@sudo machinectl disable $(MACHINE)
	@sleep 2

machinectl_create_current_user_in_machine: nonrootcheck
	@sudo machinectl copy-to $(MACHINE) ./helper/create_user_in_machine /tmp/create_user_in_machine
	@sudo machinectl copy-to $(MACHINE) /home/$(USER)/.ssh/authorized_keys /tmp/authorized_keys
	@sudo systemd-run --machine $(MACHINE) --wait /tmp/create_user_in_machine $(USER)

machinectl_install: nonrootcheck machinectl_import machinectl_enable machinectl_start machinectl_create_current_user_in_machine

machinectl_uninstall: machinectl_poweroff machinectl_disable machinectl_remove

machinectl_user_shell:
	@sudo machinectl shell $(USER)@$(MACHINE)


clean:
	@sudo ./mkosi clean
	@rm -f mkosi

.PHONY: all mkosi_build mkosi_boot mkosi_shell mkosi_clean crudini machinectl_import machinectl_remove machinectl_start machinectl_poweroff machinectl_login machinectl_enable machinectl_disable machinectl_install machinectl_uninstall nonrootcheck

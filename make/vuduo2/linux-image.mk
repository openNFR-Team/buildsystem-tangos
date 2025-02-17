#
# flashimage
#

flashimage: $(D)/neutrino
	$(START_BUILD)
	$(MAKE) flash-image-vuduo2
	$(TUXBOX_CUSTOMIZE)
	@$(call draw_line,);
	@$(call draw_line,Build of $@ for $(BOXTYPE) successfully completed.,2);
	@$(call draw_line,);

ofgimage: $(D)/neutrino
	$(START_BUILD)
	echo "nothing to do"
	@$(call draw_line,);
	@$(call draw_line,Build of $@ for $(BOXTYPE) successfully completed.,2);
	@$(call draw_line,);

online-image: $(D)/neutrino
	$(START_BUILD)
	echo "nothing to do"
	@$(call draw_line,);
	@$(call draw_line,Build of $@ for $(BOXTYPE) successfully completed.,2);
	@$(call draw_line,);

flash-clean:
	echo ""

### mipsbox vuduo
# general
VUDUO_PREFIX = vuplus/duo2
VUDUO_BUILD_TMP = $(BUILD_TMP)/image-build

flash-image-vuduo2:
	rm -rf $(VUDUO_BUILD_TMP) || true
	mkdir -p $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)
	touch $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/reboot.update
	cp $(SKEL_ROOT)/release/splash.bin $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/splash_cfe_auto.bin
	cp $(RELEASE_DIR)/boot/initrd_cfe_auto.bin $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)
	cp $(RELEASE_DIR)/boot/kernel_cfe_auto.bin $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)
	mkfs.ubifs -r $(RELEASE_DIR) -o $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/root_cfe_auto.ubi -m 2048 -e 126976 -c 8192
	echo '[ubifs]' > $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'mode=ubi' >> $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'image=$(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/root_cfe_auto.ubi' >> $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_id=0' >> $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_type=dynamic' >> $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_name=rootfs' >> $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_flags=autoresize' >> $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/ubinize.cfg
	ubinize -o $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/root_cfe_auto.jffs2 -m 2048 -p 128KiB $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/ubinize.cfg
	rm -f $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/root_cfe_auto.ubi
	rm -f $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/ubinize.cfg
	echo $(BOXTYPE)_$(FLAVOUR)_$(ITYPE)_$(shell date '+%d%m%Y-%H%M%S') > $(VUDUO_BUILD_TMP)/$(VUDUO_PREFIX)/imageversion
	cd $(VUDUO_BUILD_TMP)/ && \
	zip -r $(RELEASE_IMAGE_DIR)/$(BOXTYPE)_$(FLAVOUR)_$(ITYPE)_$(shell date '+%d.%m.%Y-%H.%M').zip $(VUDUO_PREFIX)*
	# cleanup
	rm -rf $(VUDUO_BUILD_TMP)

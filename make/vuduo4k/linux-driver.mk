#
# driver
#
DRIVER_VER = 4.1.45
DRIVER_DATE = 20191218
#DRIVER_DATE = 20190212
DRIVER_REV = r0
DRIVER_SRC = vuplus-dvb-proxy-$(KERNEL_TYPE)-$(DRIVER_VER)-$(DRIVER_DATE).$(DRIVER_REV).tar.gz

$(ARCHIVE)/$(DRIVER_SRC):
	$(DOWNLOAD) http://archive.vuplus.com/download/build_support/vuplus/$(DRIVER_SRC)

driver-clean:
	rm -f $(D)/driver $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/$(KERNEL_TYPE)*

driver: $(D)/driver
$(D)/driver: $(ARCHIVE)/$(DRIVER_SRC) $(D)/bootstrap $(D)/kernel
	$(START_BUILD)
	install -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	tar -xf $(ARCHIVE)/$(DRIVER_SRC) -C $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	$(MAKE) platform_util
	$(MAKE) libgles
	$(MAKE) vmlinuz_initrd
	$(TOUCH)

#
# platform util
#
UTIL_VER = 18.1
UTIL_DATE = $(DRIVER_DATE)
UTIL_REV = r0
UTIL_SRC = platform-util-$(KERNEL_TYPE)-$(UTIL_VER)-$(UTIL_DATE).$(UTIL_REV).tar.gz

$(ARCHIVE)/$(UTIL_SRC):
	$(DOWNLOAD) http://archive.vuplus.com/download/build_support/vuplus/$(UTIL_SRC)

$(D)/platform_util: $(D)/bootstrap $(ARCHIVE)/$(UTIL_SRC)
	$(START_BUILD)
	$(UNTAR)/$(UTIL_SRC)
	install -m 0755 $(BUILD_TMP)/platform-util-$(KERNEL_TYPE)/* $(TARGET_DIR)/usr/bin
	$(REMOVE)/platform-util-$(KERNEL_TYPE)
	$(TOUCH)

#
# libgles
#
GLES_VER = 18.1
GLES_DATE = $(DRIVER_DATE)
GLES_REV = r0
GLES_SRC = libgles-$(KERNEL_TYPE)-$(GLES_VER)-$(GLES_DATE).$(GLES_REV).tar.gz

$(ARCHIVE)/$(GLES_SRC):
	$(DOWNLOAD) http://archive.vuplus.com/download/build_support/vuplus/$(GLES_SRC)

$(D)/libgles: $(D)/bootstrap $(ARCHIVE)/$(GLES_SRC)
	$(START_BUILD)
	$(UNTAR)/$(GLES_SRC)
	install -m 0755 $(BUILD_TMP)/libgles-$(KERNEL_TYPE)/lib/* $(TARGET_LIB_DIR)
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so
	cp -a $(BUILD_TMP)/libgles-$(KERNEL_TYPE)/include/* $(TARGET_INCLUDE_DIR)
	$(REMOVE)/libgles-$(KERNEL_TYPE)
	$(TOUCH)

#
# vmlinuz initrd
#
INITRD_DATE = 20181030
INITRD_SRC = vmlinuz-initrd_$(KERNEL_TYPE)_$(INITRD_DATE).tar.gz

$(ARCHIVE)/$(INITRD_SRC):
	$(DOWNLOAD) http://archive.vuplus.com/download/kernel/$(INITRD_SRC)

$(D)/vmlinuz_initrd: $(D)/bootstrap $(ARCHIVE)/$(INITRD_SRC)
	$(START_BUILD)
	tar -xf $(ARCHIVE)/$(INITRD_SRC) -C $(TARGET_DIR)/boot
	install -d $(TARGET_DIR)/boot
	$(TOUCH)

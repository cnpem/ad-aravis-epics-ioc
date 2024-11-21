TOP=..
include $(TOP)/configure/CONFIG

install:
	mkdir -p /usr/local/share/misc
	ln -s $(shell realpath $(TOP))/iocBoot/iocCamera/envPaths /usr/local/share/misc/
	ln -s $(shell realpath $(INSTALL_HOST_BIN))/Camera /usr/local/bin/

include $(CONFIG)/RULES_DIRS

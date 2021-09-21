#!/usr/bin/make -f

# Copyright (C) 2018 - underscore@autistici.org
# Copyright (C) 2018 - 2018 ENCRYPTED SUPPORT LP <adrelanos@riseup.net>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING file for more details.

## genmkfile - makefile-full - version 1.5

## This is a copy.
## master location:
## https://github.com/Whonix/genmkfile/blob/master/usr/share/genmkfile/makefile-full

GENMKFILE_PATH ?= ./

DESTDIR ?= /

export GENMKFILE_PATH
export DESTDIR

all:
	$(GENMKFILE_PATH)/make-helper.bsh all $(ARGS)

dist:
	$(GENMKFILE_PATH)/make-helper.bsh dist

undist:
	$(GENMKFILE_PATH)/make-helper.bsh undist

debdist:
	$(GENMKFILE_PATH)/make-helper.bsh debdist

undebdist:
	$(GENMKFILE_PATH)/make-helper.bsh undebdist

manpages:
	$(GENMKFILE_PATH)/make-helper.bsh manpages

uch:
	$(GENMKFILE_PATH)/make-helper.bsh uch

install:
	$(GENMKFILE_PATH)/make-helper.bsh install

deb-build-dep:
	$(GENMKFILE_PATH)/make-helper.bsh deb-build-dep

deb-run-dep:
	$(GENMKFILE_PATH)/make-helper.bsh deb-run-dep

deb-all-dep:
	$(GENMKFILE_PATH)/make-helper.bsh deb-all-dep

deb-pkg:
	$(GENMKFILE_PATH)/make-helper.bsh deb-pkg ${ARGS}

deb-pkg-signed:
	$(GENMKFILE_PATH)/make-helper.bsh deb-pkg-signed ${ARGS}

deb-pkg-install:
	$(GENMKFILE_PATH)/make-helper.bsh deb-pkg-install ${ARGS}

deb-pkg-source:
	$(GENMKFILE_PATH)/make-helper.bsh deb-pkg-source ${ARGS}

deb-install:
	$(GENMKFILE_PATH)/make-helper.bsh deb-install

deb-icup:
	$(GENMKFILE_PATH)/make-helper.bsh deb-icup

deb-remove:
	$(GENMKFILE_PATH)/make-helper.bsh deb-remove

deb-purge:
	$(GENMKFILE_PATH)/make-helper.bsh deb-purge

deb-clean:
	$(GENMKFILE_PATH)/make-helper.bsh deb-clean

deb-cleanup:
	$(GENMKFILE_PATH)/make-helper.bsh deb-cleanup

lintian:
	$(GENMKFILE_PATH)/make-helper.bsh lintian

dput-ubuntu-ppa:
	$(GENMKFILE_PATH)/make-helper.bsh dput-ubuntu-ppa

clean:
	$(GENMKFILE_PATH)/make-helper.bsh clean

distclean:
	$(GENMKFILE_PATH)/make-helper.bsh distclean

checkout:
	$(GENMKFILE_PATH)/make-helper.bsh checkout

installcheck:
	$(GENMKFILE_PATH)/make-helper.bsh installcheck

installsim:
	$(GENMKFILE_PATH)/make-helper.bsh installsim

uninstallcheck:
	$(GENMKFILE_PATH)/make-helper.bsh uninstallcheck

uninstall:
	$(GENMKFILE_PATH)/make-helper.bsh uninstall

uninstallsim:
	$(GENMKFILE_PATH)/make-helper.bsh uninstallsim

deb-chl-bumpup-manual:
	$(GENMKFILE_PATH)/make-helper.bsh deb-chl-bumpup-manual

deb-chl-bumpup-major:
	$(GENMKFILE_PATH)/make-helper.bsh deb-chl-bumpup-major

deb-uachl-bumpup-manual:
	$(GENMKFILE_PATH)/make-helper.bsh deb-uachl-bumpup-manual

deb-uachl-bumpup-major:
	$(GENMKFILE_PATH)/make-helper.bsh deb-uachl-bumpup-major

git-tag-show:
	$(GENMKFILE_PATH)/make-helper.bsh git-tag-show

git-tag-sign:
	$(GENMKFILE_PATH)/make-helper.bsh git-tag-sign

git-tag-verify:
	$(GENMKFILE_PATH)/make-helper.bsh git-tag-verify

git-tag-check:
	$(GENMKFILE_PATH)/make-helper.bsh git-tag-check

git-commit-verify:
	$(GENMKFILE_PATH)/make-helper.bsh git-commit-verify

git-verify:
	$(GENMKFILE_PATH)/make-helper.bsh git-verify

git-tag-push:
	$(GENMKFILE_PATH)/make-helper.bsh git-tag-push

git-tag-show-latest:
	$(GENMKFILE_PATH)/make-helper.bsh git-tag-show-latest

git-tag-push-latest:
	$(GENMKFILE_PATH)/make-helper.bsh git-tag-push-latest

reprepro-add:
	$(GENMKFILE_PATH)/make-helper.bsh reprepro-add

reprepro-remove:
	$(GENMKFILE_PATH)/make-helper.bsh reprepro-remove

help:
	$(GENMKFILE_PATH)/make-helper.bsh help

%:
	$(GENMKFILE_PATH)/make-helper.bsh $@ $(ARGS)

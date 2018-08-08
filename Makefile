#!/usr/bin/make -f

# Copyright (C) 2018 - underscore@autistici.org
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING file for more details.

BIN_PATH = /usr/bin
BIN_FILE = orjail

install:
	@cp $(BIN_FILE) $(BIN_PATH)/$(BIN_FILE)

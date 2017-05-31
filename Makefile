BIN_PATH = /usr/bin
BIN_FILE = torjail

install:
	@cp $(BIN_FILE) $(BIN_PATH)/$(BIN_FILE)

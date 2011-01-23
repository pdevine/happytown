
BIN_DIR = /Developer/SDKs/flex_sdk_4.1/bin
FLAGS = --debug=true

%.swf: %.as
	$(BIN_DIR)/mxmlc $(FLAGS) $<

clean:
	rm -f *.swf

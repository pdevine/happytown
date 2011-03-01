SOURCES = \
	HappyTown.as \
	LevelSelect.as \
	Light.as \
	Menu.as \
	MenuItem.as \
	MenuItemEvent.as \
	Point3D.as \
	Tile.as \
	TileI.as \
	TileL.as \
	TileT.as \
	Tiles.as \
	Title.as \
	Triangle.as \

BIN_DIR = /Developer/SDKs/flex_sdk_4.1/bin
FLAGS = -static-link-runtime-shared-libraries=true -debug=true -use-network=false

happytown: $(SOURCES)
	$(BIN_DIR)/mxmlc $(FLAGS) HappyTown.as

%.swf: %.as
	$(BIN_DIR)/mxmlc $(FLAGS) $<


clean:
	rm -f *.swf

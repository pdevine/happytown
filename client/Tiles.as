package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class Tiles extends Sprite
    {
        private var tiles:Array;
        private var movingTiles:Array;

        private var tile:TileT;
        private var vpX:Number;
        private var vpY:Number;
        private var rows:uint = 3;
        private var columns:uint = 3;

        private var rowPositions:Array;
        private var columnPositions:Array;

        public const NORTH:uint = 1;
        public const EAST:uint = 2;
        public const SOUTH:uint = 4;
        public const WEST:uint = 8;

        public function Tiles()
        {
            tiles = new Array();
            movingTiles = new Array();

            trace("added stage event listener");
            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        public function createRandomBoard():void
        {
            var tileTypes:Array = [TileI, TileL, TileT];
            var tile:Tile;
            var scaling:Number = 0.30;

            for(var i:uint = 0; i < rows * columns; i++)
            {
                var tileType:uint = Math.floor(
                                        Math.random() * tileTypes.length)
                var rotation:Number = Math.floor(Math.random() * 4) * 90;
                tile = new tileTypes[tileType](rotation, scaling, vpX, vpY);
                tiles.push(tile);
            }

            tiles[0] = new TileL(0, scaling, vpX, vpY);
            tiles[columns-1] = new TileL(90, scaling, vpX, vpY);
            tiles[rows * (columns-1)] = new TileL(270, scaling, vpX, vpY);
            tiles[rows * columns - 1] = new TileL(180, scaling, vpX, vpY);
            
            fixTilePositions();
        }

        private function fixTilePositions():void
        {
            rowPositions = new Array();
            columnPositions = new Array();

            var tile:Tile;
            for(var row:uint = 0; row < rows; row++)
            {
                for(var column:uint = 0; column < columns; column++)
                {
                    var tileNum:uint = (row * columns) + column;
                    tile = tiles[tileNum];
                    var x:Number = tile.width * column - tile.width;
                    var y:Number = tile.height * row - tile.height;
                    tile.translate(x, y, 0);
                    rowPositions.push(y);
                    columnPositions.push(x);
                }
            }
        }

        public function loadLevel(levelName:String):void
        {
            trace("loading level");
            var xmlLoader:URLLoader = new URLLoader();
            xmlLoader.load(new URLRequest(levelName));
            xmlLoader.addEventListener(Event.COMPLETE, levelLoaded);
        }

        private function levelLoaded(event:Event):void
        {
            trace("xml loaded");
            var tile:Tile;

            XML.ignoreWhitespace = true;
            var tileData:XML = new XML(event.target.data);
            for(var i:uint = 0; i < tileData.tile.length(); i++)
            {
                var tileType:String = tileData.tile[i].type;
                var rotation:Number = Number(tileData.tile[i].rotation);
                if(tileType == 'tile_l')
                    tile = new TileL(rotation, 0.4, vpX, vpY);
                else if(tileType == 'tile_i')
                    tile = new TileI(rotation, 0.4, vpX, vpY);
                else if(tileType == 'tile_t')
                    tile = new TileT(rotation, 0.4, vpX, vpY);

                tiles.push(tile);
            }

            fixTilePositions();
        }

        public function moveTiles(position:uint, direction:uint):void
        {
            // XXX - check that direction is NORTH, EAST, SOUTH, WEST
            var i:uint;

            if(direction == EAST || direction == WEST)
            {
                for(i = 0; i < tiles.length; i++)
                {
                    // find the tiles in our row and flag them to be moved
                    if(rowPositions.indexOf(tiles[i]) == position)
                    {
                        movingTiles.push(tiles[i]);
                        trace("pushed tile");
                    }
                }
                movingTiles.sortOn("x", Array.DESCENDING | Array.NUMERIC);
                for(i = 0; i < movingTiles.length; i++)
                {
                    movingTiles[i].x += movingTiles[i].width;
                }
            }
        }

        public function draw():void
        {
            graphics.clear();
            // sort objects here
            for(var i:uint = 0; i < tiles.length; i++)
            {
                tiles[i].draw(graphics);
            }
        }

        private function onAddedToStage(event:Event):void
        {
            trace("set vanishing point");
            vpX = stage.stageWidth / 2;
            vpY = stage.stageHeight / 2;
        }

        private function onEnterFrame(event:Event):void
        {
            draw();
        }
    }
}

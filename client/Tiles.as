package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class Tiles extends Sprite
    {
        private var tiles:Array;
        private var tile:TileT;
        private var vpX:Number = stage.stageWidth / 2;
        private var vpY:Number = stage.stageHeight / 2;
        private var rows:uint = 3;
        private var columns:uint = 3;

        public function Tiles()
        {
            init();
        }

        private function init():void
        {
            tiles = new Array();

            loadLevel("level1.xml");

            //createRandomBoard();

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function createRandomBoard():void
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
            var tile:Tile;
            for(var row:uint = 0; row < rows; row++)
            {
                for(var column:uint = 0; column < columns; column++)
                {
                    var tileNum:uint = (row * columns) + column;
                    tile = tiles[tileNum];
                    tile.translate(tile.width * column - tile.width,
                                   tile.height * row - tile.height);
                }
            }
        }

        private function loadLevel(levelName:String):void
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

        private function onEnterFrame(event:Event):void
        {
            graphics.clear();
            // sort objects here
            for(var i:uint = 0; i < tiles.length; i++)
            {
                tiles[i].draw(graphics);
            }
        }
    }
}

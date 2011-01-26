package
{
    import flash.display.Sprite;
    import flash.events.Event;

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

            var tileTypes:Array = [TileI, TileL, TileT];
            var tile:Tile;
            for(var i:uint = 0; i < rows * columns; i++)
            {
                var tileType:uint = Math.floor(
                                        Math.random() * tileTypes.length)
                tile = new tileTypes[tileType](0, 0, vpX, vpY);
                tile.rotate(Math.floor(Math.random() * 4) * 90);
                tile.scale(0.4);
                tiles.push(tile);
            }

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

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
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

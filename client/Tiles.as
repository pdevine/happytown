package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.utils.Dictionary;

    import MovingTilesEvent;
    import MenuItemEvent;

    public class Tiles extends Sprite
    {
        public static const NORTH:uint = 1;
        public static const EAST:uint = 2;
        public static const SOUTH:uint = 4;
        public static const WEST:uint = 8;

        public var paused:Boolean = false;

        private var tiles:Array;
        private var movingTiles:Array;

        private var floatingTile:Tile;

        private var tile:TileT;
        private var fl:Number = 250;
        private var vpX:Number;
        private var vpY:Number;
        private var rows:uint = 3;
        private var columns:uint = 3;

        private var rowPositions:Array;
        private var columnPositions:Array;

        private var dm:DataManager;
        private var overlayMenu:OverlayMenu;

        public var players:Array;

        //public var followMouse:Boolean = true;

        public function Tiles()
        {
            tiles = new Array();
            players = new Array();
            movingTiles = new Array();
            dm = DataManager.getInstance();

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
                    //var tileNum:uint = (row * columns) + column;
                    tile = tiles[row][column];
                    var x:Number = tile.width * column - tile.width;
                    var y:Number = tile.height * row - tile.height;
                    tile.x = x;
                    tile.y = y;
                    tile.targetX = x;
                    tile.targetY = y;
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
            var row:Array;

            XML.ignoreWhitespace = true;
            var tileData:XML = new XML(event.target.data);
            var scaling:Number = Number(tileData.@scaling);
            rows = uint(tileData.@rows);
            columns = uint(tileData.@columns);
            trace("scaling: ", tileData.@scaling);

            for(var r:uint = 0; r < tileData.row.length(); r++)
            {
                trace("row", r);
                row = new Array();
                for(var i:uint = 0; i < tileData.row[r].tile.length(); i++)
                {
                    trace("tile");
                    var tileType:String = tileData.row[r].tile[i].type;
                    var rotation:Number = 
                        Number(tileData.row[r].tile[i].rotation);
                    tile = createTile(tileType, rotation, scaling, vpX, vpY);
                    row.push(tile);
                }
                tiles.push(row);
            }

            floatingTile = createTile(tileData.floating_tile[0].type,
                                      0, scaling, vpX, vpY);
            fixTilePositions();

            var floatingTileX:int = int(tileData.floating_tile[0].@x);
            var floatingTileY:int = int(tileData.floating_tile[0].@y);

            dm.floatingTilePosition = new Point3D(
                floatingTileX, floatingTileY, 0);

            var player1:ExtrudedA = new ExtrudedA(vpX, vpY);
            player1.scale(0.15);
            player1.x = tiles[0][0].x;
            player1.y = tiles[0][0].y;
            player1.z = 20;
            players.push(player1);

            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            stage.addEventListener(MovingTilesEvent.CONTROL_TYPE,
                                   onMovingTiles);
        }

        private function createTile(tileType:String,
                                    rotation:Number,
                                    scaling:Number,
                                    vpX:Number, vpY:Number):Tile
        {
            if(tileType == 'tile_l')
                return(new TileL(rotation, scaling, vpX, vpY));
            else if(tileType == 'tile_i')
                return(new TileI(rotation, scaling, vpX, vpY));
            else if(tileType == 'tile_t')
                return(new TileT(rotation, scaling, vpX, vpY));

            return null;
        }

        private function getTileGraph():TraversalGraph
        {
            var g:TraversalGraph = new TraversalGraph();

            var row:uint;
            var column:uint;

            var v1:uint;
            var v2:uint;

            trace("columns:", columns);
            trace("rows:", rows);

            for(row = 0; row < tiles.length; row++)
                for(column = 0; column < tiles[row].length; column++)
                    g.addVertex(row * columns + column);

            for(row = 0; row < tiles.length; row++)
            {
                for(column = 0; column < tiles[row].length; column++)
                {
                    if(column < columns-1 &&
                       tiles[row][column].hasDir(EAST) &&
                       tiles[row][column+1].hasDir(WEST))
                    {
                        v1 = row * columns + column;
                        v2 = row * columns + column + 1;
                        g.addEdge(v1, v2);
                        g.addEdge(v2, v1);
                    }
                    if(row < rows-1 &&
                       tiles[row][column].hasDir(SOUTH) &&
                       tiles[row+1][column].hasDir(NORTH))
                    {
                        v1 = row * columns + column;
                        v2 = (row+1) * columns + column;
                        g.addEdge(v1, v2);
                        g.addEdge(v2, v1);
                    }

                }
            }

            return g;
        }

        private function onMovingTiles(event:MovingTilesEvent):void
        {
            if(event.command == "finished")
            {
                trace("move finished!");
                //followMouse = true;
                //floatingTile.moving = true;
                returnFloatingTile();
            }
        }

        private function returnFloatingTile():void
        {
            trace("return tile x=", dm.floatingTilePosition.x,
                  " y=", dm.floatingTilePosition.y);
            floatingTile.moveTo(
                dm.floatingTilePosition.x,
                dm.floatingTilePosition.y,
                0);
        }

        public function moveTiles(position:uint, direction:uint):void
        {
            var i:int;
            stage.dispatchEvent(new MovingTilesEvent("moving"));

            trace("move tiles: ", position, direction);
            trace("row positions", rowPositions);

            var newFloatingTile:Tile;
            var width:uint = tiles[position].length;
            var height:uint = tiles.length;

            //trace("don't follow mouse");
            //followMouse = false;

            if(direction == WEST)
            {
                floatingTile.x = tiles[position][width-1].x + 
                                 floatingTile.width;
                floatingTile.targetX = tiles[position][width-1].x;
                floatingTile.y = tiles[position][width-1].y;
                floatingTile.targetY = floatingTile.y;
                floatingTile.moving = true;

                newFloatingTile = tiles[position][0];

                for(i = 0; i < width; i++)
                {
                    trace("moving: ", tiles[position][i].width);
                    tiles[position][i].moving = true;
                    tiles[position][i].targetX -= tiles[position][i].width;
                    if(i < width-1)
                        tiles[position][i] = tiles[position][i+1];
                }
                tiles[position][width-1] = floatingTile;
                floatingTile = newFloatingTile;
            }
            else if(direction == EAST)
            {

                floatingTile.x = tiles[position][0].x - floatingTile.width;
                floatingTile.targetX = tiles[position][0].x;
                floatingTile.y = tiles[position][0].y;
                floatingTile.targetY = floatingTile.y;
                floatingTile.moving = true;

                newFloatingTile = tiles[position][width-1];

                for(i = width-1; i >= 0; i--)
                {
                    trace("i", i);
                    tiles[position][i].moving = true;
                    tiles[position][i].targetX += tiles[position][i].width;
                    if(i > 0)
                        tiles[position][i] = tiles[position][i-1];
                }

                tiles[position][0] = floatingTile;
                floatingTile = newFloatingTile;
            }
            else if(direction == SOUTH)
            {
                floatingTile.y = tiles[0][position].y - floatingTile.width;
                floatingTile.targetY = tiles[0][position].y;
                floatingTile.x = tiles[0][position].x;
                floatingTile.targetX = floatingTile.x;
                floatingTile.moving = true;

                newFloatingTile = tiles[height-1][position];

                for(i = height-1; i >= 0; i--)
                {
                    tiles[i][position].moving = true;
                    tiles[i][position].targetY += tiles[i][position].height;
                    if(i > 0)
                        tiles[i][position] = tiles[i-1][position];
                }

                tiles[0][position] = floatingTile;
                floatingTile = newFloatingTile;
            }
            else if(direction == NORTH)
            {
                floatingTile.y = tiles[height-1][position].y + 
                                 floatingTile.height;
                floatingTile.targetY = tiles[height-1][position].y;
                floatingTile.x = tiles[height-1][position].x;
                floatingTile.targetX = floatingTile.x;
                floatingTile.moving = true;

                newFloatingTile = tiles[0][position];

                for(i = 0; i < height; i++)
                {
                    tiles[i][position].moving = true;
                    tiles[i][position].targetY -= tiles[i][position].height;
                    if(i < height-1)
                        tiles[i][position] = tiles[i+1][position];
                }
                tiles[height-1][position] = floatingTile;
                floatingTile = newFloatingTile;
            }

            if(floatingTile.moving)
                dm.pushedTile = true;
        }

        public function draw():void
        {

            graphics.clear();
            // sort objects here
            for(var row:uint = 0; row < tiles.length; row++)
            {
                for(var column:uint = 0; column < tiles[row].length; column++)
                {
                    tiles[row][column].draw(stage, graphics);
                }
            }

            for(var i:int = 0; i < players.length; i++)
            {
                players[i].draw(graphics);
            }

            if(floatingTile != null)
            {
                if(! dm.pushedTile && !paused)
                {
                    floatingTile.x = getWorldX(mouseX);
                    floatingTile.y = getWorldY(mouseY);
                    floatingTile.z = 0;
                }

                floatingTile.draw(stage, graphics);
            }
        }

        private function onAddedToStage(event:Event):void
        {
            trace("set vanishing point");
            vpX = stage.stageWidth / 2;
            vpY = stage.stageHeight / 2;

            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        }

        private function onEnterFrame(event:Event):void
        {
            draw();
        }

        private function onMouseUp(event:MouseEvent):void
        {
            var wx:Number = getWorldX(mouseX);
            var wy:Number = getWorldY(mouseY);
            trace("world coords:", wx, wy);

            var row:int = getRow(wy);
            var column:int = getColumn(wx);
            trace("r, c:", row, column);
            trace("tiles len", tiles.length);

            if(! dm.pushedTile)
            {
                if(wx < 0 && column == -1 && row > 0 && row < rows) 
                    moveTiles(row, EAST);
                else if(wx > 0 && column == -1 && row > 0 && row < rows) 
                    moveTiles(row, WEST);
                else if(wy < 0 && row == -1 && column > 0 && column < columns) 
                    moveTiles(column, SOUTH);
                else if(wy > 0 && row == -1 && column > 0 && column < columns) 
                    moveTiles(column, NORTH);
            }
            else if(column > -1 && row > -1)
            {
                var g:TraversalGraph = getTileGraph();
                var shortestPath:Array = g.findShortestPath(
                    0,
                    row * columns + column,
                    []);

                var tilePath:Array = new Array();

                if(shortestPath.length > 0)
                {
                    trace("path:", shortestPath);
                    for(var x:int = 0; x < shortestPath.length; x++)
                    {
                        var pos:int = shortestPath[x];
                        tilePath.push(tiles[int(pos / rows)][pos % rows]);
                    }
                    trace(tilePath);
                }
            }

        }

        private function getRow(y:Number):int
        {
            var row:int = -1;
            var tileHeight:Number = tiles[0][0].height;

            for(var r:int = 0; r < tiles.length; r++)
            {
                if(y > tiles[r][0].y - tileHeight / 2 &&
                   y < tiles[r][0].y + tileHeight / 2)
                {
                    row = r;
                    break;
                }
            }

            return row;
        }

        private function getColumn(x:Number):int
        {
            var column:int = -1;
            var tileWidth:Number = tiles[0][0].width;

            for(var c:int = 0; c < tiles[0].length; c++)
            {
                if(x > tiles[0][c].x - tileWidth / 2 &&
                   x < tiles[0][c].x + tileWidth / 2)
                {
                    column = c;
                    break;
                }
            } 

            return column;
        }

        private function onMenuItemEvent(event:MenuItemEvent):void
        {
            trace("!!! menu item");
            if(event.command == "resume")
            {
                resume();
            }
        }

        private function resume():void
        {
            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            stage.removeEventListener(
                KeyboardEvent.KEY_DOWN,
                onPauseMenuKeyDown);
            overlayMenu.removeOverlay();
            paused = false;
        }

        private function pause():void
        {
            paused = true;
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onPauseMenuKeyDown);

            returnFloatingTile();
            overlayMenu = new OverlayMenu(this);
            stage.addEventListener(
                MenuItemEvent.CONTROL_TYPE,
                onMenuItemEvent);
        }

        private function onPauseMenuKeyDown(event:KeyboardEvent):void
        {
            switch(event.keyCode)
            {
                case Keyboard.ESCAPE:
                    resume();
                    break;
                default:
                    break;
            }
        }

        private function onKeyDown(event:KeyboardEvent):void
        {
            switch(event.keyCode)
            {
                case Keyboard.ESCAPE:
                    pause();
                    break;
                case Keyboard.RIGHT:
                    moveTiles(1, EAST);
                    break;
                case Keyboard.LEFT:
                    moveTiles(1, WEST);
                    break;
                case Keyboard.DOWN:
                    moveTiles(1, SOUTH);
                    break;
                case Keyboard.UP:
                    moveTiles(1, NORTH);
                    break;
                case 88:
                    // x
                    floatingTile.rotateClockwise();
                    if(floatingTile.hasDir(NORTH))
                        trace("has north");
                    if(floatingTile.hasDir(EAST))
                        trace("has east");
                    if(floatingTile.hasDir(SOUTH))
                        trace("has south");
                    if(floatingTile.hasDir(WEST))
                        trace("has west");
                    break;
                case 90:
                    // z
                    floatingTile.rotateAnticlockwise();
                    if(floatingTile.hasDir(NORTH))
                        trace("has north");
                    if(floatingTile.hasDir(EAST))
                        trace("has east");
                    if(floatingTile.hasDir(SOUTH))
                        trace("has south");
                    if(floatingTile.hasDir(WEST))
                        trace("has west");
                    break;
                default:
                    break;
            }
        }

        public function getWorldX(x:Number):Number
        {
            var scale:Number = fl / (fl + 200);
            return (x - vpX) / scale;
        }

        public function getWorldY(y:Number):Number
        {
            var scale:Number = fl / (fl + 200);
            return (y - vpY) / scale;
        }
    }
}

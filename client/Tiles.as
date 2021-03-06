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
        private var world:World;

        private var floatingTile:Tile;

        private var tile:TileT;
        private var fl:Number = 250;
        private var vpX:Number;
        private var vpY:Number;

        private var rowPositions:Array;
        private var columnPositions:Array;

        private var dm:DataManager;
        private var overlayMenu:OverlayMenu;

        private var xmlLoader:URLLoader;
        public var players:Array;
        public var objects:Array;

        //public var followMouse:Boolean = true;

        public function Tiles()
        {
            tiles = new Array();
            players = new Array();
            movingTiles = new Array();
            dm = DataManager.getInstance();
            world = new World();

            dm.objects = new Array();

            trace("added stage event listener");
            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        public function createRandomBoard():void
        {
            var tileTypes:Array = [TileI, TileL, TileT];
            var tile:Tile;
            var scaling:Number = 0.30;

            for(var i:uint = 0; i < dm.rows * dm.columns; i++)
            {
                var tileType:uint = Math.floor(
                                        Math.random() * tileTypes.length)
                var rotation:Number = Math.floor(Math.random() * 4) * 90;
                tile = new tileTypes[tileType](rotation, scaling, vpX, vpY);
                tiles.push(tile);
            }

            tiles[0] = new TileL(0, scaling, vpX, vpY);
            tiles[dm.columns-1] = new TileL(90, scaling, vpX, vpY);
            tiles[dm.rows * (dm.columns-1)] = new TileL(270, scaling, vpX, vpY);
            tiles[dm.rows * dm.columns - 1] = new TileL(180, scaling, vpX, vpY);
            
            fixTilePositions();
        }

        private function fixTilePositions():void
        {
            rowPositions = new Array();
            columnPositions = new Array();

            var tile:Tile;
            for(var row:uint = 0; row < dm.rows; row++)
            {
                for(var column:uint = 0; column < dm.columns; column++)
                {
                    //var tileNum:uint = (row * dm.columns) + column;
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
            xmlLoader = new URLLoader();
            xmlLoader.load(new URLRequest(levelName));
            xmlLoader.addEventListener(Event.COMPLETE, levelLoaded);
        }

        private function levelLoaded(event:Event):void
        {
            // XXX - clean up this method

            trace("xml loaded");
            var tile:Tile;
            var row:Array;
            var worldObject:WorldObject;

            // setup XML parser
            XML.ignoreWhitespace = true;
            var tileData:XML = new XML(event.target.data);

            // set world parameters
            var scaling:Number = Number(tileData.@scaling);
            dm.rows = uint(tileData.@rows);
            dm.columns = uint(tileData.@columns);

            var playerHomes:Dictionary = new Dictionary();

            for(var r:uint = 0; r < tileData.row.length(); r++)
            {
                trace("row", r);
                row = new Array();
                for(var i:uint = 0; i < tileData.row[r].tile.length(); i++)
                {
                    worldObject = null;

                    // set up tile
                    trace("tile");
                    var tileType:String = tileData.row[r].tile[i].type;
                    var rotation:Number = 
                        Number(tileData.row[r].tile[i].rotation);

                    // starting location for a player -- should be in the form
                    // playerX
                    var home:String = tileData.row[r].tile[i].home;

                    // XXX - support multiple objects?
                    var objectType:String = tileData.row[r].tile[i].object;

                    tile = createTile(tileType, rotation, scaling, vpX, vpY);

                    // add any objects if we've found them
                    trace("object = ", objectType);
                    if(objectType)
                    {
                        worldObject = createObject(objectType);
                        worldObject.x = tile.x;
                        worldObject.y = tile.y;
                        worldObject.tilePosition = tile;
                        world.addObject(worldObject);
                        dm.objects.push(worldObject);
                    }

                    if(home)
                        playerHomes[home] = tile;

                    world.addObject(tile);
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

            for(i = 0; i < tileData.player.length(); i++)
            {
                var playerName:String = "player" + String(i + 1);
                trace("Hello", playerName);

                var requiredObjects:XMLList = 
                    tileData.player[i].requiredObjects;

                var player:Bus = new Bus(vpX, vpY, playerName);
                player.scale(scaling);
                player.tilePosition = playerHomes[playerName];
                player.sidebar = new Sidebar(playerName, 300, 20);
                addChild(player.sidebar);

                trace("req objects xml", requiredObjects);

                // find any objects the player needs to collect
                for(var n:uint = 0; n < requiredObjects.object.length(); n++)
                {
                    trace("found object");
                    player.requiredObjects.push(
                        getObjectByName(requiredObjects.object[n]));
                }

                players.push(player);
                world.addObject(player);
            }

            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            stage.addEventListener(MovingTilesEvent.CONTROL_TYPE,
                                   onMovingTiles);
            xmlLoader.removeEventListener(Event.COMPLETE, levelLoaded);
        }

        private function getObjectByName(objectName:String):WorldObject
        {
            for(var n:uint = 0; n < dm.objects.length; n++)
            {
                if(dm.objects[n].name == objectName) {
                    trace("object is", objectName);
                    return dm.objects[n];
                }
            }
            return null;
        }

        private function createObject(objectType:String):WorldObject
        {
            if(objectType == "a")
                return(new ExtrudedA(vpX, vpY, objectType));
            return null;
        }

        private function setPlayerObjectAlphaValue():void
        {
            for(var n:uint = 0; n < dm.objects.length; n++)
            {
                var object:WorldObject = dm.objects[n];
                for(var i:uint = 0; i < players.length; i++)
                {
                    var player:Person = players[i];
                    var dx:Number = player.x - object.x;
                    var dy:Number = player.y - object.y;
                    var dist:Number = Math.sqrt(dx*dx + dy*dy);
                    trace("object distance =", dist);
                    if(dist <= 100)
                    {
                        player.setAlpha(dist / 100.0);
                        object.setAlpha(dist / 100.0);
                    }
                }
            }
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

        private function onMovingTiles(event:MovingTilesEvent):void
        {
            if(event.command == "finished")
            {
                trace("move finished!");
                if(floatingTile.x != dm.floatingTilePosition.x ||
                   floatingTile.y != dm.floatingTilePosition.y) {
                    // make the floating tile draw separately
                    floatingTile.drawSeparately = true;
                    world.removeObject(floatingTile);
                    returnFloatingTile();
                }
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

            // XXX - move objects and players instead of teleporting them

            for(var i:int = 0; i < dm.objects.length; i++)
            {
                if(dm.objects[i].tilePosition == floatingTile)
                    dm.objects[i].tilePosition =
                        floatingTile.nextTileForObjects;
            }

            for(i = 0; i < players.length; i++)
            {
                if(players[i].tilePosition == floatingTile)
                    players[i].tilePosition = floatingTile.nextTileForObjects;
            }
        }

        private function moveObjectsAndPlayersOnTile(tile:Tile):void
        {
            // move any objects on a given tile
            for(var i:int = 0; i < dm.objects.length; i++)
            {
                if(tile == dm.objects[i].tilePosition)
                {
                    dm.objects[i].x = tile.x;
                    dm.objects[i].y = tile.y;
                }
            }

            // now move any players
            for(i = 0; i < players.length; i++)
            {
                if(tile == players[i].tilePosition && !players[i].moving)
                {
                    players[i].x = tile.x;
                    players[i].y = tile.y;
                }
            }

        }

        public function endTurn():void
        {
            var player:Person = players[dm.currentPlayer];

            lookForObjects(player);
            if(!player.requiredObjects.length)
            {
                trace("Player wins!");
                dm.gameOver = true;
            }

            dm.currentPlayer++;
            if(dm.currentPlayer >= players.length)
                dm.currentPlayer = 0;
            dm.pushedTile = false;
        }

        private function lookForObjects(player:Person):void
        {
            // look for any objects to pick up
            for(var i:uint = 0; i < player.requiredObjects.length; i++)
            {
                for(var n:uint = 0; n < dm.objects.length; n++)
                {
                    if(dm.objects[n].tilePosition == player.tilePosition &&
                       dm.objects[n] == player.requiredObjects[i])
                    {
                        trace("found an object!");
                        delete player.requiredObjects[i];
                    }
                }
            }

            // cleanup the array since delete leaves a null in the array
            var newRequiredObjects:Array = new Array();
            for(i = 0; i < player.requiredObjects.length; i++)
            {
                if(player.requiredObjects[i])
                    newRequiredObjects.push(player.requiredObjects[i]);
            }

            player.requiredObjects = newRequiredObjects;
        }

        public function moveTiles(position:uint, direction:uint):void
        {
            var i:int;
            var tile:Tile;
            stage.dispatchEvent(new MovingTilesEvent("moving"));

            trace("move tiles: ", position, direction);
            trace("row positions", rowPositions);

            var newFloatingTile:Tile;
            var width:uint = tiles[position].length;
            var height:uint = tiles.length;

            //trace("don't follow mouse");
            //followMouse = false;

            floatingTile.drawSeparately = false;
            world.addObject(floatingTile);

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
                    tile = tiles[position][i];
                    trace("moving: ", tile.width);

                    tile.moving = true;
                    tile.targetX -= tile.width;

                    if(i < width-1)
                        tiles[position][i] = tiles[position][i+1];
                }
                tiles[position][width-1] = floatingTile;
                floatingTile = newFloatingTile;
                floatingTile.nextTileForObjects = tiles[position][width-1];
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
                floatingTile.nextTileForObjects = tiles[position][0];
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
                floatingTile.nextTileForObjects = tiles[0][position];
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
                floatingTile.nextTileForObjects = tiles[height-1][position];
            }

            if(floatingTile.moving)
                dm.pushedTile = true;
        }

        public function draw():void
        {

            graphics.clear();
            for(var row:uint = 0; row < tiles.length; row++)
            {
                for(var column:uint = 0; column < tiles[row].length; column++)
                {
                    var tile:Tile = tiles[row][column];
                    tile.update(stage);
                    moveObjectsAndPlayersOnTile(tile);
                }
            }
            world.draw(graphics);
            setPlayerObjectAlphaValue();

            for(var i:int = 0; i < players.length; i++)
                players[i].update();

            for(i = 0; i < dm.objects.length; i++)
                dm.objects[i].update();

            if(floatingTile != null)
            {
                moveObjectsAndPlayersOnTile(floatingTile);

                if(!dm.pushedTile && !paused && !dm.gameOver)
                {
                    floatingTile.x = getWorldX(mouseX);
                    floatingTile.y = getWorldY(mouseY);
                }

                floatingTile.update(stage);
                if(floatingTile.drawSeparately)
                    floatingTile.draw(graphics);
            }

        }

        private function onAddedToStage(event:Event):void
        {
            trace("set vanishing point");
            vpX = stage.stageWidth / 2;
            vpY = stage.stageHeight / 2;

            this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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
                if(wx < 0 && column == -1 && row > 0 && row < dm.rows-1) 
                    moveTiles(row, EAST);
                else if(wx > 0 && column == -1 && row > 0 && row < dm.rows-1) 
                    moveTiles(row, WEST);
                else if(wy < 0 && row == -1 && column > 0 &&
                        column < dm.columns-1)
                    moveTiles(column, SOUTH);
                else if(wy > 0 && row == -1 && column > 0 &&
                        column < dm.columns-1) 
                    moveTiles(column, NORTH);
            }
            else if(column > -1 && row > -1)
            {
                var g:TraversalGraph = new TraversalGraph();
                g.createTileGraph(tiles);

                // tileIndex should always be good here
                var shortestPath:Array = g.findShortestPath(
                    findTileIndexInTiles(
                        players[dm.currentPlayer].tilePosition),
                    row * dm.columns + column,
                    []);

                var tilePath:Array = new Array();

                if(shortestPath.length > 0)
                {
                    trace("path:", shortestPath);
                    for(var x:int = 0; x < shortestPath.length; x++)
                    {
                        var pos:int = shortestPath[x];
                        tilePath.push(tiles[int(pos / dm.rows)][pos % dm.rows]);
                    }
                    trace(tilePath);
                    players[dm.currentPlayer].move(tilePath);
                }
            }

        }

        public function findTileIndexInTiles(tile:Tile):int
        {
            trace("looking for tile:", tile);
            var i:int = 0;
            for(var row:uint = 0; row < dm.rows; row++)
            {
                for(var column:uint = 0; column < dm.columns; column++)
                {
                    if(tile == tiles[row][column])
                        return i;
                    i++;
                }
            }
    
            return -1;
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

        public function quit():void
        {
            // clean up any leftover stuff
            stage.removeEventListener(
                KeyboardEvent.KEY_DOWN,
                onPauseMenuKeyDown);
            stage.removeEventListener(
                MenuItemEvent.CONTROL_TYPE,
                onMenuItemEvent);
        }

        private function resume():void
        {
            trace("RESUME");
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
                case Keyboard.SPACE:
                    endTurn();
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

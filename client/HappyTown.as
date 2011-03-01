package
{
    import flash.display.Sprite;
    import flash.events.Event;

    import MenuItemEvent;

    public class HappyTown extends Sprite
    {
        private var title:Title;
        private var tiles:Tiles;

        private const TITLE_MODE:int = 0;
        private const TILES_MODE:int = 1;

        private var drawMode:int = TITLE_MODE;

        private var levels:Array = ["level1.xml", "level2.xml"];

        public function HappyTown()
        {
            title = new Title();
            addChild(title);

            tiles = new Tiles();

            stage.addEventListener(MenuItemEvent.CONTROL_TYPE, onMenuItemEvent);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(event:Event):void
        {
            if(drawMode == TITLE_MODE)
            {
                title.draw();
            }
            else
            {
                tiles.draw();
            }
        }

        private function onMenuItemEvent(event:MenuItemEvent):void
        {
            trace("!!! menu item");
            if(event.command == "start")
            {
                var dm:DataManager = DataManager.getInstance();
                tiles.loadLevel(levels[dm.currentLevel - 1]);
                removeChild(title);
                addChild(tiles);

                drawMode = TILES_MODE;
            }
        }
    }
}

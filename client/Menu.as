package
{
    import flash.display.Sprite;

    public class Menu
    {

        public var menu:Array;

        public function Menu(display:Sprite)
        {
            menu = new Array();

            var menuItem:MenuItem;
            menuItem = new MenuItem("start", 40, 200);
            display.addChild(menuItem);
            menu.push(menuItem);

            var levelSelect:LevelSelect = new LevelSelect(40, 250);
            display.addChild(levelSelect);

            menuItem = new MenuItem("quit", 40, 300);
            display.addChild(menuItem);
            menu.push(menuItem);

        }
    }

}

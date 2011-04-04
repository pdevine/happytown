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
            menuItem = new MenuItem("start", "menu", 40, 200);
            display.addChild(menuItem);
            menu.push(menuItem);

            var levelSelect:LevelSelect = new LevelSelect("menu", 40, 250);
            display.addChild(levelSelect);

            menuItem = new MenuItem("quit", "menu", 40, 300);
            display.addChild(menuItem);
            menu.push(menuItem);

        }
    }

}

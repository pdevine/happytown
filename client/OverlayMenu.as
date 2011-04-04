package
{
    import flash.display.Sprite;

    public class OverlayMenu
    {

        public var menu:Array;
        private var display:Sprite;

        public function OverlayMenu(display:Sprite)
        {
            this.display = display;
            menu = new Array();

            var menuItem:MenuItem;
            menuItem = new MenuItem("resume", "overlay", 40, 200);
            display.addChild(menuItem);
            menu.push(menuItem);

            menuItem = new MenuItem("quit", "overlay", 40, 300);
            display.addChild(menuItem);
            menu.push(menuItem);
        }

        public function removeOverlay():void
        {
            for(var i:int = 0; i < menu.length; i++)
            {
                trace("@@@ Removing ", menu[i].textField.text);
                display.removeChild(menu[i]);
            }
        }
    }
}

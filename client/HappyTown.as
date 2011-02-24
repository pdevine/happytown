package
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.events.Event;

    import MenuItemEvent;

    public class HappyTown extends Sprite
    {

        [Embed(source="Fonts/lokisd.ttf", fontFamily="LoKinderSchrift")]
        public static var _lokinder:Class;

        [Embed(source="Fonts/actionj.ttf", fontFamily="Action Jackson")]
        public static var _actionJackson:Class;

        private var xOffset:Number = 50;
        private var yOffset:Number = 20;
        private var title:String = "HAPPYTOWN";
        private var letters:Array;
        private var menu:Array;
        private var angle:Number = 0;

        public function HappyTown()
        {

            var format:TextFormat = new TextFormat();
            format.font = "LoKinderSchrift";
            format.color = 0xff0000;
            format.size = 80;

            letters = new Array();
            var letter:TextField;

            for(var i:uint = 0; i < title.length; i++)
            {
                letter = new TextField();
                letter.embedFonts = true;
                letter.autoSize = TextFieldAutoSize.LEFT;
                letter.defaultTextFormat = format;
                letter.x = xOffset;
                letter.y = yOffset;
                letter.text = title.charAt(i);
                letters.push(letter);
                addChild(letter);

                xOffset += letter.width;
            }

            var menu:Menu = new Menu(this);

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            stage.addEventListener(MenuItemEvent.CONTROL_TYPE, onMenuItemEvent);
            var dm:DataManager = DataManager.getInstance();
            trace(dm.foo);

        }

        private function onEnterFrame(event:Event):void
        {
            angle += 0.05;

            for(var i:uint = 0; i < letters.length; i++)
            {
                letters[i].y = Math.sin(angle + 0.5 * i) * 20 + yOffset;
            }

        }

        private function onMenuItemEvent(event:MenuItemEvent):void
        {
            trace("menuItemEvent!");
            trace(event.command);
        }
    }
}

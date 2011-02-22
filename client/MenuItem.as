package
{
    import flash.display.Sprite;

    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.events.MouseEvent;
    import flash.events.Event;

    public class MenuItem extends Sprite
    {

        [Embed(source="Fonts/actionj.ttf", fontFamily="Action Jackson")]
        public static var _actionJackson:Class;

        public var format:TextFormat;
        public var textField:TextField;

        public function MenuItem(text:String, x:Number, y:Number,
                                 clickable:Boolean=true)
        {
            this.x = x;
            this.y = y;

            if(clickable == true)
                this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            format = new TextFormat();
            format.font = "Action Jackson";
            format.color = 0x000000;
            format.size = 50;

            textField = createTextField(text);

            addChild(textField); 
        }

        public function createTextField(text:String):TextField
        {
            var textField:TextField = new TextField();
            textField.embedFonts = true;
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.defaultTextFormat = format;
            textField.selectable = false;
            textField.text = text;

            return textField;
        }

        private function onAddedToStage(event:Event):void
        {
            trace("added to stage");
            this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        }


        private function onMouseDown(event:MouseEvent):void
        {
            trace("mouse down!");
            y -= 3;
            x -= 3;

            this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }

        private function onMouseUp(event:MouseEvent):void
        {
            y += 3;
            x += 3;

            removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }
    }
}

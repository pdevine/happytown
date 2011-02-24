package
{
    import flash.display.Sprite;

    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.events.MouseEvent;
    import flash.events.Event;

    import flash.events.EventDispatcher;
    import MenuItemEvent;

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
            this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOverOut);
        }

        private function onMouseDown(event:MouseEvent):void
        {
            y -= 3;
            x -= 3;

            this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }

        private function onMouseOut(event:MouseEvent):void
        {
            resetSprite();
        }

        private function onMouseUp(event:MouseEvent):void
        {
            resetSprite();
            trace("fired: ", textField.text);
            stage.dispatchEvent(new MenuItemEvent(textField.text));
        }

        private function onMouseOver(event:MouseEvent):void
        {
            textField.textColor = 0xff0000;
        }

        private function onMouseOverOut(event:MouseEvent):void
        {
            textField.textColor = 0x000000;
        }

        private function resetSprite():void
        {
            y += 3;
            x += 3;

            this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            this.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }

        
    }
}

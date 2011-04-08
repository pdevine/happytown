package
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class Sidebar extends Sprite
    {
        [Embed(source="Fonts/actionj.ttf", fontFamily="Action Jackson")]
        public static var _actionJackson:Class;

        public var format:TextFormat;

        public function Sidebar(playerName:String, x:Number, y:Number)
        {
            this.x = x;
            this.y = y;

            format = new TextFormat();
            format.font = "Action Jackson";
            format.color = 0x0;
            format.size = 18;

            var textField:TextField = new TextField();
            textField.embedFonts = true;
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.defaultTextFormat = format;
            textField.text = playerName;

            addChild(textField);
        }
    }
}

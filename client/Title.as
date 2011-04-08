package
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.events.Event;

    import MenuItemEvent;

    public class Title extends Sprite
    {

        [Embed(source="Fonts/lokisd.ttf", fontFamily="LoKinderSchrift")]
        public static var _lokinder:Class;

        private var xOffset:Number = 50;
        private var yOffset:Number = 20;
        private var title:String = "HAPPYTOWN";
        private var letters:Array;
        private var menu:Array;
        private var angle:Number = 0;

        private var bgShape:Sprite;
        private var sunRays:SunRays;

        private var sun:Sun;
        private var sasquatch:Sasquatch;

        private const colors:Array = [0xfcb653, 0xff5254, 0xcee879];

        public function Title()
        {

            sunRays = new SunRays();
            addChild(sunRays);

            sun = new Sun();
            addChild(sun);

            sasquatch = new Sasquatch();
            addChild(sasquatch);

            var format:TextFormat = new TextFormat();
            format.font = "LoKinderSchrift";
            format.color = 0xff0000;
            format.size = 80;

            letters = new Array();
            var letter:TextField;

            for(var i:uint = 0; i < title.length; i++)
            {
                format.color = 
                    colors[int(Math.floor(Math.random() * colors.length))];
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
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        public function draw():void
        {
            angle += 0.05;

            for(var i:uint = 0; i < letters.length; i++)
            {
                letters[i].y = Math.sin(angle + 0.5 * i) * 20 + yOffset;
            }

            sunRays.rotation = angle * 7;
        }

        private function onAddedToStage(event:Event):void
        {
            bgShape = new Sprite();

            bgShape.graphics.beginFill(0x5cacc4);
            bgShape.graphics.drawRect(
                -100, 0,
                stage.stageWidth + 100,
                stage.stageHeight);
            bgShape.graphics.endFill();
            addChildAt(bgShape, 0);

            stage.addEventListener(MenuItemEvent.CONTROL_TYPE, onMenuItemEvent);
        }

        private function onEnterFrame(event:Event):void
        {
            sunRays.x = sun.x;
            sunRays.y = sun.y;
            draw();
        }

        private function onMenuItemEvent(event:MenuItemEvent):void
        {
            if(event.command == "start")
            {
                var dm:DataManager = DataManager.getInstance();
                trace("Level selected: ", dm.currentLevel);
            }
        }
    }
}

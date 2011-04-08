package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;

    import com.lorentz.SVG.*;
    import com.lorentz.SVG.display.SVGDocument;

    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class Sasquatch extends Sprite
    {
        private const filename:String = "Images/sasquatch.svg";
        private var angle:Number = 0;
        private var rotationSpeed:Number = 0.1;
        private var container:Sprite;

        public function Sasquatch()
        {

            container = new Sprite();
            addChild(container);

            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, onXmlComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            loader.load(new URLRequest(filename));
            

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        }

        private function onXmlComplete(event:Event):void
        {
            XML.ignoreWhitespace = false;
            var svg:XML = new XML(event.target.data);
            XML.ignoreWhitespace = true;

            var sunImg:SVGDocument = new SVGDocument();
            sunImg.baseURL = "Images/";
            sunImg.parse(svg);

            container.addChild(sunImg);
            container.scaleX = .5;
            container.scaleY = .5;
            container.x = -container.width / 2;
            container.y = -container.height / 2;
        }

        private function onAddedToStage(event:Event):void
        {
            x = 30;
            y = stage.stageHeight - 100;
        }

        private function onEnterFrame(event:Event):void
        {
            angle += rotationSpeed;
            rotation = Math.sin(angle) * 10;
        }

        private function onIOError(event:IOErrorEvent):void
        {
            trace("ERROR:  couldn't load", filename);
        }
    }
}

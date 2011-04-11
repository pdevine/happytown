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
        private var arm1:TwoSegmentReach;
        private var arm2:TwoSegmentReach;

        public function Sasquatch()
        {

            container = new Sprite();
            addChild(container);

            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, onXmlComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            loader.load(new URLRequest(filename));
            
            arm1 = new TwoSegmentReach();
            arm2 = new TwoSegmentReach();

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        }

        private function onXmlComplete(event:Event):void
        {
            XML.ignoreWhitespace = false;
            var svg:XML = new XML(event.target.data);
            XML.ignoreWhitespace = true;

            var svgImg:SVGDocument = new SVGDocument();
            svgImg.baseURL = "Images/";
            svgImg.parse(svg);

            container.addChild(svgImg);
            container.scaleX = .5;
            container.scaleY = .5;
            container.x = -container.width / 2;
            container.y = -container.height / 2;

            arm1.x = -65;
            arm1.y = -60;
            container.addChild(arm1);

            arm2.x = -240;
            arm2.y = -60;
            container.addChild(arm2);
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

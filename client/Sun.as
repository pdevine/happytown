package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;

    import com.lorentz.SVG.*;
    import com.lorentz.SVG.display.SVGDocument;

    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class Sun extends Sprite
    {
        private const filenames:Array = ["Images/sun0.svg", "Images/sun1.svg"];
        private var images:Array;

        private var angle:Number = 0;
        private var rotationSpeed:Number = 0.1;
        private var container:Sprite;

        private var loader:URLLoader;

        public function Sun()
        {
            images = new Array();

            container = new Sprite();
            addChild(container);

            loader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, onXmlComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            loader.load(new URLRequest(filenames[images.length]));
            

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        }

        private function onXmlComplete(event:Event):void
        {
            XML.ignoreWhitespace = false;
            var svg:XML = new XML(event.target.data);
            XML.ignoreWhitespace = true;

            var svgImage:SVGDocument = new SVGDocument();
            svgImage.baseURL = "Images/";
            svgImage.parse(svg);

            images.push(svgImage);

            if(images.length == 1)
            {
                container.addChild(svgImage);
                container.scaleX = .5;
                container.scaleY = .5;
                container.x = -container.width / 2;
                container.y = -container.height / 2;
            }
            if(images.length < filenames.length)
                loader.load(new URLRequest(filenames[images.length]));
        }

        private function onAddedToStage(event:Event):void
        {
            x = stage.stageWidth - 30;
            y = 30;
            stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }

        private function onEnterFrame(event:Event):void
        {
            angle += rotationSpeed;
            rotation = Math.sin(angle) * 10;
        }

        private function onMouseDown(event:MouseEvent):void
        {
            container.removeChildAt(0);
            container.addChild(images[1]);
            //container.scaleX = 
        }

        private function onMouseUp(event:MouseEvent):void
        {
            container.removeChildAt(0);
            container.addChild(images[0]);
        }

        private function onIOError(event:IOErrorEvent):void
        {
            trace("ERROR:  couldn't load image");
        }
    }
}

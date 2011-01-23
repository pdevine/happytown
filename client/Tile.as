package
{
    import flash.display.Sprite;
    import flash.events.Event;

    public class Tile extends Sprite
    {
        public var points:Array;
        private var triangles:Array;
        private var fl:Number = 250;
        private var vpX:Number = stage.stageWidth / 2;
        private var vpY:Number = stage.stageHeight / 2;

        public function Tile()
        {
            points = [
                new Point3D(-200, -200,   0),
                new Point3D( 200, -200,   0),
                new Point3D( 200,  200,   0),
                new Point3D(-200,  200,   0),
            // 4
                new Point3D(-200, -200, -20),
                new Point3D(-100, -200, -20),
                new Point3D(-100,  200, -20),
                new Point3D(-200,  200, -20),

            // 8
                new Point3D( 100, -200, -20),
                new Point3D( 200, -200, -20),
                new Point3D( 200,  200, -20),
                new Point3D( 100,  200, -20),
            // 12
                new Point3D(-100, -200,   0),
                new Point3D(-100,  200,   0),
                new Point3D( 100, -200,   0),
                new Point3D( 100,  200,   0),

            // 16
                new Point3D( 100, -100,   0),
                new Point3D( 100, -100, -20),
                new Point3D( 100,  100,   0),
                new Point3D( 100,  100, -20),

            // 20
                new Point3D( 200, -100,   0),
                new Point3D( 200, -100, -20),
                new Point3D( 200,  100,   0),
                new Point3D( 200,  100, -20),

            // 24
                new Point3D(-100, -100,   0),
                new Point3D(-100,  100,   0),
                new Point3D(-100, -100, -20),
                new Point3D(-100,  100, -20),

            // 28
                new Point3D(-200, -100, -20),
                new Point3D(-200, -100,   0),
            ];

            for(var i:uint = 0; i < points.length; i++)
            {
                points[i].setVanishingPoint(vpX, vpY);
                points[i].setCenter(0, 0, 200);
            }
        }

        public function init(triangles:Array):void
        {
            this.triangles = triangles;
            var i:uint;

            var light:Light = new Light();
            for(i = 0; i < triangles.length; i++)
                triangles[i].light = light;

            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(event:Event):void
        {
            var angleX:Number = (mouseY - vpY) * 0.001;
            var angleY:Number = (mouseX - vpX) * 0.001;

            var i:uint;

            for(i = 0; i < points.length; i++)
            {
                var point:Point3D = points[i];
                point.rotateX(angleX);
                point.rotateY(angleY);
            }

            triangles.sortOn("depth", Array.DESCENDING | Array.NUMERIC);

            graphics.clear();
            for(var i:uint = 0; i < triangles.length; i++)
                triangles[i].draw(graphics);

        }
    }
}

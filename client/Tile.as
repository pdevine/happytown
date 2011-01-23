package
{
    import flash.display.Sprite;
    import flash.events.Event;

    public class Tile extends Sprite
    {
        private var points:Array;
        private var triangles:Array;
        private var fl:Number = 250;
        private var vpX:Number = stage.stageWidth / 2;
        private var vpY:Number = stage.stageHeight / 2;

        public function Tile()
        {
            init();
        }

        private function init():void
        {
            var i:uint;

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

            ];

            for(i = 0; i < points.length; i++)
            {
                points[i].setVanishingPoint(vpX, vpY);
                points[i].setCenter(0, 0, 200);
            }

            triangles = [
                //new Triangle(points[3], points[0], points[1], 0x5cacc4),
                //new Triangle(points[1], points[2], points[3], 0x5cacc4),

                new Triangle(points[7], points[4], points[5], 0x8cd19d),
                new Triangle(points[5], points[6], points[7], 0x8cd19d),

                new Triangle(points[8], points[9], points[11], 0x8cd19d),
                new Triangle(points[9], points[10], points[11], 0x8cd19d),

                new Triangle(points[5], points[12], points[6], 0x8cd19d),
                new Triangle(points[12], points[13], points[6], 0x8cd19d),

                new Triangle(points[0], points[4], points[7], 0x8cd19d),
                new Triangle(points[0], points[7], points[3], 0x8cd19d),

                new Triangle(points[3], points[7], points[6], 0x8cd19d),
                new Triangle(points[3], points[6], points[13], 0x8cd19d),

                new Triangle(points[0], points[12], points[5], 0x8cd19d),
                new Triangle(points[0], points[5], points[4], 0x8cd19d),

                new Triangle(points[1], points[10], points[9], 0x8cd19d),
                new Triangle(points[1], points[2], points[10], 0x8cd19d),

                new Triangle(points[11], points[15], points[14], 0x8cd19d),
                new Triangle(points[11], points[14], points[8], 0x8cd19d),

                new Triangle(points[15], points[11], points[10], 0x8cd19d),
                new Triangle(points[15], points[10], points[2], 0x8cd19d),

                new Triangle(points[1], points[9], points[14], 0x8cd19d),
                new Triangle(points[9], points[8], points[14], 0x8cd19d),

            ];

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

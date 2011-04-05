package
{
    import flash.display.Graphics;
    import flash.events.Event;

    public class Bus
    {
        private var points:Array;
        public var triangles:Array;
        private var fl:Number = 250;
        private var vpX:Number;
        private var vpY:Number;

        private var _x:Number = 0;
        private var _y:Number = 0;
        private var _z:Number = 0;

        public var targetX:Number = 0;
        public var targetY:Number = 0;
        public var targetZ:Number = 0;

        public function Bus(
            vpX:Number,
            vpY:Number)
        {
            this.vpX = vpX;
            this.vpY = vpY;

            init();
        }

        private function init():void
        {
            points = [
                new Point3D(-160, -30,   -5),
                new Point3D(-160, -30, -105),
                new Point3D(  80, -30, -105),
                new Point3D(  80, -30,   -5),
                new Point3D(  80, -30,  -45),
                new Point3D( 160, -30,  -45),
                new Point3D( 160, -30,   -5),

                // 7
                new Point3D(-160,  30, -105),
                new Point3D(  80,  30, -105),
                new Point3D(  80,  30,  -45),
                new Point3D( 160,  30,  -45),
                new Point3D( 160,  30,   -5),

                // 12
                new Point3D(-160,  30,   -5),
                new Point3D(-160,  30, -105),
                new Point3D(  80,  30, -105),
                new Point3D(  80,  30,   -5),
                new Point3D(  80,  30,  -45),
                new Point3D( 160,  30,  -45),
                new Point3D( 160,  30,   -5),


            ];

            for(var i:uint = 0; i < points.length; i++)
            {
                points[i].setVanishingPoint(vpX, vpY);
                points[i].setCenter(0, 0, 200);
            }

            triangles = [
                // side
                new Triangle(points[0], points[2], points[1], 0xf7e033),
                new Triangle(points[0], points[3], points[2], 0xf7e033),
                new Triangle(points[3], points[5], points[4], 0xf7e033),
                new Triangle(points[3], points[6], points[5], 0xf7e033),

                //top
                new Triangle(points[1], points[2], points[7], 0xf7e033),
                new Triangle(points[7], points[2], points[8], 0xf7e033),

                //windshield
                new Triangle(points[4], points[8], points[2], 0xf7e033),
                new Triangle(points[4], points[9], points[8], 0xf7e033),

                //hood
                new Triangle(points[4], points[10], points[9], 0xf7e033),
                new Triangle(points[4], points[5], points[10], 0xf7e033),

                //grill
                new Triangle(points[6], points[10], points[5], 0xf7e033),
                new Triangle(points[6], points[11], points[10], 0xf7e033),

                //other side
                new Triangle(points[12], points[13], points[14], 0xf7e033),
                new Triangle(points[12], points[14], points[15], 0xf7e033),
                new Triangle(points[15], points[16], points[17], 0xf7e033),
                new Triangle(points[15], points[17], points[18], 0xf7e033),

                //back
                new Triangle(points[0], points[13], points[14], 0xf7e033),
                new Triangle(points[12], points[14], points[15], 0xf7e033),

            ];

            var light:Light = new Light();
            for(i = 0; i < triangles.length; i++)
            {
                triangles[i].light = light;
            }

            //addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        public function scale(scaleFactor:Number):void
        {
            for(var i:int = 0; i < points.length; i++)
            {
                points[i].scale(scaleFactor);
            }
        }

        public function translate(x:Number, y:Number, z:Number):void
        {
            _x += x;
            _y += y;
            _z += z;

            for(var i:int = 0; i < points.length; i++)
            {
                points[i].x += x;
                points[i].y += y;
                points[i].z += z;
            }
        }

        public function get x():Number
        {
            return _x;
        }

        public function set x(val:Number):void
        {
            translate(-_x + val, 0, 0);
        }

        public function get y():Number
        {
            return _y;
        }

        public function set y(val:Number):void
        {
            translate(0, -_y + val, 0);
        }

        public function get z():Number
        {
            return _z;
        }

        public function set z(val:Number):void
        {
            translate(0, 0, -_z + val);
        }

        public function update():void
        {
            var i:int;
            var angleX:Number = 0.01;
            var angleY:Number = 0.01;

            for(i = 0; i < points.length; i++)
            {
                var point:Point3D = points[i];
                point.x -= _x;
                point.y -= _y;
                point.z -= _z;

                point.rotateX(angleX);
                point.rotateY(angleY);

                point.x += _x;
                point.y += _y;
                point.z += _z;

            }

            //triangles.sortOn("depth", Array.DESCENDING | Array.NUMERIC);

            //g.clear();
            //for(i = 0; i < triangles.length; i++)
            //{
            //    triangles[i].draw(g);
            //}
        }
    }
}

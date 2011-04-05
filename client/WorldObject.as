package
{
    import flash.display.Graphics;

    public class WorldObject
    {
        protected var points:Array;
        public var triangles:Array;

        private var fl:Number = 250;
        protected var vpX:Number;
        protected var vpY:Number;

        protected var _x:Number = 0;
        protected var _y:Number = 0;
        protected var _z:Number = 0;

        public var targetX:Number = 0;
        public var targetY:Number = 0;
        public var targetZ:Number = 0;

        public function WorldObject(vpX:Number, vpY:Number)
        {
            this.vpX = vpX;
            this.vpY = vpY;

            points = new Array();
            triangles = new Array();
        }

        public function setData(dataPoints:Array, dataTriangles:Array):void
        {
            for(var i:uint = 0; i < dataPoints.length; i += 3)
            {

                trace("new point = ",
                    dataPoints[i],
                    dataPoints[i+1],
                    dataPoints[i+2]);

                points.push(new Point3D(
                    dataPoints[i],
                    dataPoints[i+1],
                    dataPoints[i+2]));
            }

            trace("vanishing point = ", vpX, vpY);
            
            for(i = 0; i < points.length; i++)
            {
                points[i].setVanishingPoint(vpX, vpY);
                points[i].setCenter(0, 0, 200);
            }

            for(i = 0; i < dataTriangles.length; i += 4)
            {
                // triangle is 3 points + a colour value
                triangles.push(
                    new Triangle(
                        points[dataTriangles[i]],
                        points[dataTriangles[i+1]],
                        points[dataTriangles[i+2]],
                        dataTriangles[i+3]))
            }

            // set lighting
            var light:Light = new Light();
            for(i = 0; i < triangles.length; i++)
            {
                triangles[i].light = light;
            }
        }

        public function scale(scaleFactor:Number):void
        {
            trace("Scale = ", scaleFactor);
            for(var i:uint = 0; i < points.length; i++)
                points[i].scale(scaleFactor);
        }

        public function translate(x:Number, y:Number, z:Number):void
        {
            _x += x;
            _y += y;
            _z += z;

            trace("Moving object to = ", _x, _y, _z);

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

    }
}

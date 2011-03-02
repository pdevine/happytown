package
{
    import flash.display.Graphics;

    public class Tile
    {
        public var points:Array;
        private var triangles:Array;
        private var fl:Number = 250;
        private var vpX:Number;
        private var vpY:Number;
        private var _x:Number = 0;
        private var _y:Number = 0;
        private var _z:Number = 0;

        public var rotation:Number = 0;
        public var targetRotation:Number = 0;

        private const rotationSpeed:Number = 0.1;

        public function Tile(rotation:Number,
                             scaleAmount:Number,
                             vpX:Number, vpY:Number)
        {
            this.vpX = vpX;
            this.vpY = vpY;

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
                var point:Point3D = points[i];
                point.setVanishingPoint(vpX, vpY);
                point.setCenter(0, 0, 200);
                //point.x += x;
                //point.y += y;
            }

            scale(scaleAmount);

            targetRotation = rotation;
            rotate(rotation);
            
        }

        public function init(triangles:Array):void
        {
            this.triangles = triangles;
            var i:uint;

            var light:Light = new Light();
            for(i = 0; i < triangles.length; i++)
                triangles[i].light = light;

        }

        public function scale(scaleFactor:Number):void
        {
            for(var i:uint = 0; i < points.length; i++)
            {
                points[i].scale(scaleFactor);
            }
        }

        public function translate(x:Number, y:Number, z:Number):void
        {
            _x += x;
            _y += y;
            _z += z;

            for(var i:uint = 0; i < points.length; i++)
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

        public function get width():Number
        {
            var start:Number = 0;
            var end:Number = 0;

            for(var i:uint = 0; i < points.length; i++)
            {
                start = Math.min(start, points[i].x);
                end = Math.max(end, points[i].x);
            }

            return end - start;
        }

        public function get height():Number
        {
            var start:Number = 0;
            var end:Number = 0;

            // find first and last point
            for(var i:uint = 0; i < points.length; i++)
            {
                start = Math.min(start, points[i].y);
                end = Math.max(end, points[i].y);
            }

            return end - start;
        }

        public function rotateTo(angleZ:Number):void
        {
            targetRotation += angleZ;
        }

        public function rotate(angleZ:Number, center:Boolean=true):void
        {
            rotation += angleZ;

            // convert to radians
            angleZ = angleZ / 180 * Math.PI;

            for(var i:uint = 0; i < points.length; i++)
            {
                var point:Point3D = points[i];
                if(center)
                {
                    point.x -= _x;
                    point.y -= _y;
                    point.z -= _z;
                }

                point.rotateZ(angleZ);

                if(center)
                {
                    point.x += _x;
                    point.y += _y;
                    point.z += _z;
                }
            }
        }

        public function draw(g:Graphics):void
        {
            if(targetRotation != rotation)
            {
                rotate((targetRotation - rotation) * rotationSpeed);
            }
           // else if(targetRotation < rotation)
           // {
           //     rotate((targetRotation - rotation) * rotationSpeed);
           // }

            triangles.sortOn("depth", Array.DESCENDING | Array.NUMERIC);

            for(var i:uint = 0; i < triangles.length; i++)
                triangles[i].draw(g);
        }
    }
}

package
{
    public class Bus extends Actor
    {

        private const objectPoints:Array = [
            -160, -50,   -5,
            -160, -50, -105,
              80, -50, -105,
              80, -50,   -5,
              80, -50,  -45,
             160, -50,  -45,
             160, -50,   -5,

            // 7
            -160,  50, -105,
              80,  50, -105,
              80,  50,  -45,
             160,  50,  -45,
             160,  50,   -5,

            // 12
            -160,  50,   -5,
            -160,  50, -105,
              80,  50, -105,
              80,  50,   -5,
              80,  50,  -45,
             160,  50,  -45,
             160,  50,   -5,
            ];

        private const objectTriangles:Array = [
            // side
            0, 2, 1, 0xf7e033,
            0, 3, 2, 0xf7e033,
            3, 5, 4, 0xf7e033,
            3, 6, 5, 0xf7e033,

            //top
            1, 2, 7, 0xf7e033,
            7, 2, 8, 0xf7e033,

            //windshield
            4, 8, 2, 0xf7e033,
            4, 9, 8, 0xf7e033,

            //hood
            4, 10, 9, 0xf7e033,
            4, 5, 10, 0xf7e033,

            //grill
            6, 10, 5, 0xf7e033,
            6, 11, 10, 0xf7e033,

            //other side
            12, 13, 14, 0xf7e033,
            12, 14, 15, 0xf7e033,
            15, 16, 17, 0xf7e033,
            15, 17, 18, 0xf7e033,

            //back
            0, 1, 13, 0xf7e033,
            0, 13, 12, 0xf7e033,

        ];

        public function Bus(vpX:Number, vpY:Number)
        {
            super(vpX, vpY);
            setData(objectPoints, objectTriangles);
        }

        public function update():void
        {

            updateMove();

/*
            var i:int;
            var angleX:Number = 0.01;
            var angleY:Number = 0.01;
            //var angleX:Number = 0.0;
            //var angleY:Number = 0.0;


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

*/

        }

    }
}

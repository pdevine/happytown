package
{
    import flash.display.Graphics;
    import flash.events.Event;

    public class ExtrudedA extends Actor
    {
        private const objectPoints:Array = [
             -5, -25, -5,
              5, -25, -5,
             20,  25, -5,
             10,  25, -5,
              5,  10, -5,
             -5,  10, -5,
            -10,  25, -5,
            -20,  25, -5,
               0, -15, -5,
              5,    0, -5,
             -5,    0, -5,

             -5, -25,  5,
              5, -25,  5,
             20,  25,  5,
             10,  25,  5,
              5,  10,  5,
             -5,  10,  5,
            -10,  25,  5,
            -20,  25,  5,
              0, -15,  5,
              5,    0,  5,
             -5,    0,  5
        ];

        private const objectTriangles:Array = [
            0, 1, 8, 0xcccccc,
            1, 9, 8, 0xcccccc,
            1, 2, 9, 0xcccccc,
            2, 4, 9, 0xcccccc,
            2, 3, 4, 0xcccccc,
            4, 5, 9, 0xcccccc,
            9, 5, 10, 0xcccccc,
            5, 6, 7, 0xcccccc,
            5, 7, 10, 0xcccccc,
            0, 10, 7, 0xcccccc,
            0, 8, 10, 0xcccccc,
            11, 19, 12, 0xcccccc,
            12, 19, 20, 0xcccccc,
            12, 20, 13, 0xcccccc,
            13, 20, 15, 0xcccccc,
            13, 15, 14, 0xcccccc,
            15, 20, 16, 0xcccccc,
            20, 21, 16, 0xcccccc,
            16, 18, 17, 0xcccccc,
            16, 21, 18, 0xcccccc,
            11, 18, 21, 0xcccccc,
            11, 21, 19, 0xcccccc,
            0, 11, 1, 0xcccccc,
            11, 12, 1, 0xcccccc,
            1, 12, 2, 0xcccccc,
            12, 13, 2, 0xcccccc,
            3, 2, 14, 0xcccccc,
            2, 13, 14, 0xcccccc,
            4, 3, 15, 0xcccccc,
            3, 14, 15, 0xcccccc,
            5, 4, 16, 0xcccccc,
            4, 15, 16, 0xcccccc,
            6, 5, 17, 0xcccccc,
            5, 16, 17, 0xcccccc,
            7, 6, 18, 0xcccccc,
            6, 17, 18, 0xcccccc,
            0, 7, 11, 0xcccccc,
            7, 18, 11, 0xcccccc,
            8, 9, 19, 0xcccccc,
            9, 20, 19, 0xcccccc,
            9, 10, 20, 0xcccccc,
            10, 21, 20, 0xcccccc,
            10, 8, 21, 0xcccccc,
            8, 19, 21, 0xcccccc
        ];

        public function ExtrudedA(vpX:Number, vpY:Number)
        {
            super(vpX, vpY);

            setData(objectPoints, objectTriangles);
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
        }
    }
}

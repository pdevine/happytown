package
{
    public class TileI extends Tile
    {

        private var triangles:Array;

        public function TileI(rotation:Number,
                              scaleAmount:Number,
                              vpX:Number, vpY:Number)
        {
            super(rotation, scaleAmount, vpX, vpY);

            triangles = [
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

                new Triangle(points[12], points[14], points[13], 0xfcb653),
                new Triangle(points[13], points[14], points[15], 0xfcb653),

            ];

            init(triangles);

        }
    }
}


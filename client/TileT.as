package
{
    import flash.display.Sprite;

    public class TileT extends Tile
    {

        private var triangles:Array;

        public function TileT()
        {
            super();

            triangles = [
                new Triangle(points[7], points[4], points[5], 0x8cd19d),
                new Triangle(points[5], points[6], points[7], 0x8cd19d),

                //new Triangle(points[8], points[9], points[11], 0x8cd19d),
                //new Triangle(points[9], points[10], points[11], 0x8cd19d),

                new Triangle(points[5], points[12], points[6], 0x8cd19d),
                new Triangle(points[12], points[13], points[6], 0x8cd19d),

                new Triangle(points[0], points[4], points[7], 0x8cd19d),
                new Triangle(points[0], points[7], points[3], 0x8cd19d),

                new Triangle(points[3], points[7], points[6], 0x8cd19d),
                new Triangle(points[3], points[6], points[13], 0x8cd19d),

                new Triangle(points[0], points[12], points[5], 0x8cd19d),
                new Triangle(points[0], points[5], points[4], 0x8cd19d),

                new Triangle(points[17], points[8], points[9], 0x8cd19d),
                new Triangle(points[17], points[9], points[21], 0x8cd19d),

                new Triangle(points[14], points[8], points[17], 0x8cd19d),
                new Triangle(points[14], points[17], points[16], 0x8cd19d),

                new Triangle(points[1], points[9], points[14], 0x8cd19d),
                new Triangle(points[9], points[8], points[14], 0x8cd19d),

                new Triangle(points[16], points[17], points[21], 0x8cd19d),
                new Triangle(points[16], points[21], points[20], 0x8cd19d),

                new Triangle(points[20], points[21], points[9], 0x8cd19d),
                new Triangle(points[20], points[9], points[1], 0x8cd19d),

                new Triangle(points[15], points[11], points[10], 0x8cd19d),
                new Triangle(points[15], points[10], points[2], 0x8cd19d),

                new Triangle(points[15], points[18], points[19], 0x8cd19d),
                new Triangle(points[15], points[19], points[11], 0x8cd19d),

                new Triangle(points[2], points[10], points[23], 0x8cd19d),
                new Triangle(points[2], points[23], points[22], 0x8cd19d),

                new Triangle(points[22], points[23], points[19], 0x8cd19d),
                new Triangle(points[22], points[19], points[18], 0x8cd19d),

                new Triangle(points[11], points[19], points[23], 0x8cd19d),
                new Triangle(points[11], points[23], points[10], 0x8cd19d),

                new Triangle(points[24], points[12], points[14], 0xfcb653),
                new Triangle(points[24], points[14], points[16], 0xfcb653),

                new Triangle(points[25], points[24], points[16], 0xfcb653),
                new Triangle(points[25], points[16], points[18], 0xfcb653),

            ];

            init(triangles);

        }
    }
}

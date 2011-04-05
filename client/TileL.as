package
{
    import Tiles;

    public class TileL extends Tile
    {

        //private var triangles:Array;

        public function TileL(rotation:Number,
                              scaleAmount:Number,
                              vpX:Number, vpY:Number)
        {
            super(rotation, scaleAmount, vpX, vpY);

            exits = Tiles.EAST | Tiles.SOUTH;

            triangles = [
                new Triangle(points[7], points[28], points[26], 0x8cd19d),
                new Triangle(points[7], points[26], points[6], 0x8cd19d),

                new Triangle(points[28], points[4], points[5], 0x8cd19d),
                new Triangle(points[28], points[5], points[26], 0x8cd19d),

                new Triangle(points[26], points[5], points[8], 0x8cd19d),
                new Triangle(points[26], points[8], points[17], 0x8cd19d),

                new Triangle(points[3], points[29], points[28], 0x8cd19d),
                new Triangle(points[3], points[28], points[7], 0x8cd19d),

                new Triangle(points[3], points[7], points[6], 0x8cd19d),
                new Triangle(points[3], points[6], points[13], 0x8cd19d),

                new Triangle(points[29], points[0], points[4], 0x8cd19d),
                new Triangle(points[29], points[4], points[28], 0x8cd19d),

                new Triangle(points[0], points[12], points[5], 0x8cd19d),
                new Triangle(points[0], points[5], points[4], 0x8cd19d),

                new Triangle(points[17], points[8], points[9], 0x8cd19d),
                new Triangle(points[17], points[9], points[21], 0x8cd19d),

                new Triangle(points[13], points[6], points[26], 0x8cd19d),
                new Triangle(points[13], points[26], points[24], 0x8cd19d),

                new Triangle(points[12], points[14], points[8], 0x8cd19d),
                new Triangle(points[12], points[8], points[5], 0x8cd19d),

                new Triangle(points[24], points[26], points[17], 0x8cd19d),
                new Triangle(points[24], points[17], points[16], 0x8cd19d),

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

                new Triangle(points[25], points[24], points[16], 0xfcb653),
                new Triangle(points[25], points[16], points[18], 0xfcb653),

                new Triangle(points[13], points[25], points[18], 0xfcb653),
                new Triangle(points[13], points[18], points[15], 0xfcb653),

                new Triangle(points[18], points[16], points[20], 0xfcb653),
                new Triangle(points[18], points[20], points[22], 0xfcb653),

            ];

            init(triangles, rotation);
        }
    }
}


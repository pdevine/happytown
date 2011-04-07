package
{
    import Tiles;

    public class TileT extends Tile
    {

        private const objectTriangles:Array = [
            7, 4, 5, 0x8cd19d,
            5, 6, 7, 0x8cd19d,

            5, 12, 6, 0x8cd19d,
            12, 13, 6, 0x8cd19d,

            0, 4, 7, 0x8cd19d,
            0, 7, 3, 0x8cd19d,

            3, 7, 6, 0x8cd19d,
            3, 6, 13, 0x8cd19d,

            0, 12, 5, 0x8cd19d,
            0, 5, 4, 0x8cd19d,

            17, 8, 9, 0x8cd19d,
            17, 9, 21, 0x8cd19d,

            14, 8, 17, 0x8cd19d,
            14, 17, 16, 0x8cd19d,

            1, 9, 14, 0x8cd19d,
            9, 8, 14, 0x8cd19d,

            16, 17, 21, 0x8cd19d,
            16, 21, 20, 0x8cd19d,

            20, 21, 9, 0x8cd19d,
            20, 9, 1, 0x8cd19d,

            15, 11, 10, 0x8cd19d,
            15, 10, 2, 0x8cd19d,

            15, 18, 19, 0x8cd19d,
            15, 19, 11, 0x8cd19d,

            2, 10, 23, 0x8cd19d,
            2, 23, 22, 0x8cd19d,

            22, 23, 19, 0x8cd19d,
            22, 19, 18, 0x8cd19d,

            11, 19, 23, 0x8cd19d,
            11, 23, 10, 0x8cd19d,

            24, 12, 14, 0xfcb653,
            24, 14, 16, 0xfcb653,

            25, 24, 16, 0xfcb653,
            25, 16, 18, 0xfcb653,

            13, 25, 18, 0xfcb653,
            13, 18, 15, 0xfcb653,

            18, 16, 20, 0xfcb653,
            18, 20, 22, 0xfcb653,

            // dirt

            0, 30, 1, 0xfcb653,
            30, 31, 1, 0xfcb653,
            0, 3, 32, 0xfcb653,
            0, 32, 30, 0xfcb653,
            1, 33, 2, 0xfcb653,
            1, 31, 33, 0xfcb653,
            3, 2, 32, 0xfcb653,
            32, 2, 33, 0xfcb653,

        ];

        public function TileT(rotation:Number,
                              scaleAmount:Number,
                              vpX:Number, vpY:Number)
        {
            super(vpX, vpY);

            exits = Tiles.NORTH | Tiles.EAST | Tiles.SOUTH;

            setData(objectPoints, objectTriangles);
            setRotationAndScale(rotation, scaleAmount);
        }
    }
}


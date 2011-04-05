package
{
    import Tiles;

    public class TileI extends Tile
    {
        private const objectTriangles:Array = [
            7, 4, 5, 0x8cd19d,
            5, 6, 7, 0x8cd19d,

            8, 9, 11, 0x8cd19d,
            9, 10, 11, 0x8cd19d,

            5, 12, 6, 0x8cd19d,
            12, 13, 6, 0x8cd19d,

            0, 4, 7, 0x8cd19d,
            0, 7, 3, 0x8cd19d,

            3, 7, 6, 0x8cd19d,
            3, 6, 13, 0x8cd19d,

            0, 12, 5, 0x8cd19d,
            0, 5, 4, 0x8cd19d,

            1, 10, 9, 0x8cd19d,
            1, 2, 10, 0x8cd19d,

            11, 15, 14, 0x8cd19d,
            11, 14, 8, 0x8cd19d,

            15, 11, 10, 0x8cd19d,
            15, 10, 2, 0x8cd19d,

            1, 9, 14, 0x8cd19d,
            9, 8, 14, 0x8cd19d,

            12, 14, 13, 0xfcb653,
            13, 14, 15, 0xfcb653,
        ];

        public function TileI(rotation:Number,
                              scaleAmount:Number,
                              vpX:Number, vpY:Number)
        {
            super(vpX, vpY);

            exits = Tiles.NORTH | Tiles.SOUTH;

            setData(objectPoints, objectTriangles);
            setRotationAndScale(rotation, scaleAmount);
        }
    }
}


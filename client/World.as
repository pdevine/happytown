package
{
    import flash.display.Graphics;

    public class World
    {
        public var polygons:Array;

        public function World()
        {
            polygons = new Array();
        }

        public function draw(g:Graphics):void
        {
            polygons.sortOn("depth", Array.DESCENDING | Array.NUMERIC);
            trace("polygon count = ", polygons.length);

            // good for 0 to 4,294,967,295 (2^32-1) polys
            for(var i:uint = 0; i < polygons.length; i++)
            {
                polygons[i].draw(g);
            }
        }

        public function addObject(object:Object):void
        {
            for(var i:uint = 0; i < object.triangles.length; i++)
            {
                polygons.push(object.triangles[i]);
            }
        }
    }
}

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

            // good for 0 to 4,294,967,295 (2^32-1) polys
            for(var i:uint = 0; i < polygons.length; i++)
            {
                polygons[i].draw(g);
            }
        }

        public function addObject(object:Object):void
        {
            trace("Adding ", object.triangles.length, " polygons");
            for(var i:uint = 0; i < object.triangles.length; i++)
            {
                polygons.push(object.triangles[i]);
            }
        }

        // this is expensive -- at best case it's O(2n)
        public function removeObject(object:Object):void
        {
            trace("Removing ", object.triangles.length, " polygons");
            for(var i:uint = 0; i < polygons.length; i++)
            {
                for(var n:uint = 0; n < object.triangles.length; n++)
                {
                    if(polygons[i] == object.triangles[n])
                        delete polygons[i];   // still need to clean this up
                }
            }

            var newPolygons:Array = new Array();

            for(i = 0; i < polygons.length; i++)
            {
                if(polygons[i])
                    newPolygons.push(polygons[i]);
            }
            polygons = newPolygons;
        }
    }
}

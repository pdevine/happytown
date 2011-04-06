package
{
    import flash.display.Graphics;
    import flash.display.Stage;

    public class Tile extends WorldObject
    {
        protected const objectPoints:Array = [
            -200, -200,   0,
             200, -200,   0,
             200,  200,   0,
            -200,  200,   0,

            // 4
            -200, -200, -20,
            -100, -200, -20,
            -100,  200, -20,
            -200,  200, -20,

            // 8
             100, -200, -20,
             200, -200, -20,
             200,  200, -20,
             100,  200, -20,
            // 12
            -100, -200,   0,
            -100,  200,   0,
             100, -200,   0,
             100,  200,   0,

            // 16
             100, -100,   0,
             100, -100, -20,
             100,  100,   0,
             100,  100, -20,

            // 20
             200, -100,   0,
             200, -100, -20,
             200,  100,   0,
             200,  100, -20,

            // 24
            -100, -100,   0,
            -100,  100,   0,
            -100, -100, -20,
            -100,  100, -20,

            // 28
            -200, -100, -20,
            -200, -100,   0,
        ];

        public var exits:int = 0;

        private const moveSpeed:Number = 0.1;
        private const rotationSpeed:Number = 0.1;

        // where to send any objects on the tile if they get separated
        public var nextTileForObjects:Tile;

        public function Tile(vpX:Number, vpY:Number)
        {
            super(vpX, vpY);
        }

        public function setRotationAndScale(
                            rotation:Number,
                            scaleAmount:Number):void
        {
            scale(scaleAmount);

            for(var x:int = 0; x < rotation / 90; x++)
                rotateClockwise();

            rotate(rotation);

        }

        public function rotateClockwise():void
        {
            targetRotation += 90;

            // rotate the exits
            exits = exits << 1;

            // N = 1 E = 2 S = 4 W = 8
            if(exits > 15)
                exits -= 15;
        }

        public function rotateAnticlockwise():void
        {
            targetRotation -= 90;

            trace("pre:", exits);

            if(hasDir(Tiles.NORTH)) {
                trace("add 15");
                exits += 15;
            }

            exits = exits >> 1;
            trace("post:", exits);

        }

        public function hasDir(direction:int):Boolean
        {
            return (exits & direction) > 0;
        }

        public function update(stage:Stage):void
        {
            if(moving)
            {
                var dx:Number = (targetX - _x) * moveSpeed;
                var dy:Number = (targetY - _y) * moveSpeed;
                var dz:Number = (targetZ - _z) * moveSpeed;

                //trace(dx, dy, dz);

                translate(dx, dy, dz);            

                var dist:Number = Math.sqrt(dx*dx + dy*dy + dz*dz);

                if(dist < 0.5)
                {
                    x = targetX;
                    y = targetY;
                    z = targetZ;
                    moving = false;
                    stage.dispatchEvent(new MovingTilesEvent("finished"));
                }
            }

            if(targetRotation != rotation)
            {
                rotate((targetRotation - rotation) * rotationSpeed);
            }

        }

        public function draw(g:Graphics):void
        {
            for(var i:uint; i < triangles.length; i++)
                triangles[i].draw(g);
        }
    }
}

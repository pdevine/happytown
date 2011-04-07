package
{
    public class Actor extends WorldObject
    {

        public var tilePath:Array;
        private var currentSegment:int = -1;
        private var dm:DataManager;

        protected const moveSpeed:Number = 10;
        protected const rotationSpeed:Number = 0.1;

        protected var turning:Boolean = false;

        public function Actor(vpX:Number, vpY:Number, name:String)
        {
            super(vpX, vpY, name);
            dm = DataManager.getInstance();
        }

        public function move(tilePath:Array):void
        {
            currentSegment = 0;
            this.tilePath = tilePath;
            var tile:Tile = tilePath[currentSegment];
            targetX = tile.x;
            targetY = tile.y;
            targetZ = tile.z;

            trace("move to: ", targetX, targetY, targetZ);
            moving = true;
             
        }

        public function updateMove():void
        {
            if(turning)
            {
                trace("turning", rotation, targetRotation);

                if(rotation > targetRotation) {
                    rotate(-9);
                    return;
                }
                else if(rotation < targetRotation) {
                    rotate(9);
                    return;
                }

                if(rotation == targetRotation)
                    turning = false;
            }

            if(moving)
            {
                var dx:Number = (targetX - x);
                var dy:Number = (targetY - y);
                var dz:Number = (targetZ - z);

                var distance:Number = Math.sqrt(dx*dx + dy*dy + dz*dz);
                trace("distance: ", distance);

                dx = Math.cos(rotation / 180.0 * Math.PI) * 10;
                dy = Math.sin(rotation / 180.0 * Math.PI) * 10;
                dz = 0;

                translate(dx, dy, dz);

                if(distance < 10)
                {

                    currentSegment += 1;

                    if(currentSegment >= tilePath.length)
                    {
                        moving = false;
                    } else
                    {
                        x = targetX;
                        y = targetY;
                        z = targetZ;

                        var tile:Tile = tilePath[currentSegment];
                        targetX = tile.x;
                        targetY = tile.y;
                        targetZ = tile.z;

                        tilePosition = tile;

                        var direction:int = Math.round(
                            Math.atan2(targetY - y, targetX - x) * 180.0 
                                / Math.PI);

                        trace("direction = ", direction);
                        trace("rotation = ", rotation);

                        if(rotation != direction)
                        {
                            if(rotation == 90 && direction == -180)
                                rotation = -270;
                            else if(rotation == -90 && direction == 180)
                                rotation = 270;

                            trace("Turning to", direction);
                            turning = true;
                            targetRotation = direction;
                        }
                    }
                }
                toggleAlphaOnTile();

            }

        }

        // XXX - this could be a little better if it used distance
        private function toggleAlphaOnTile():void
        {
            var goClear:Boolean = false;
            for(var n:uint = 0; n < dm.objects.length; n++)
            {
                var myObj:WorldObject = dm.objects[n];
                for(var i:uint = 0; i < myObj.triangles.length; i++)
                {
                    myObj.triangles[i].alphaToggle = 
                        myObj.tilePosition == tilePosition;
                    goClear = myObj.tilePosition == tilePosition || goClear;
                }

            }
            for(n = 0; n < triangles.length; n++)
                triangles[n].alphaToggle = goClear;
        }

    }
}

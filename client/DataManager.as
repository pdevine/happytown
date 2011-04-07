package
{
    public class DataManager
    {
        private static var instance:DataManager;
        private static var allowInstantiation:Boolean;

        public var gameOver:Boolean = false;

        public var currentLevel:uint = 1;
        public var currentPlayer:int = 0;
        public var pushedTile:Boolean = false;
        public var floatingTilePosition:Point3D;
        public var columns:uint = 0;
        public var rows:uint = 0;

        public static function getInstance():DataManager
        {
            if(instance == null)
            {
                allowInstantiation = true;
                instance = new DataManager();
                allowInstantiation = false;
            }
            return instance;
        }

        public function DataManager():void
        {
            if(!allowInstantiation)
                throw new Error(
                    "Error: Instantiation failed.  Use getInstance()"
                )
        }
    }
}

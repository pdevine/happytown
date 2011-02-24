package
{
    public class DataManager
    {
        private static var instance:DataManager;
        private static var allowInstantiation:Boolean;

        public var foo:String = "foo bar baz!";

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

package
{
    public class Person extends Actor
    {

        public var requiredObjects:Array;
        public var sidebar:Sidebar;

        public function Person(vpX:Number, vpY:Number, name:String)
        {
            super(vpX, vpY, name);

            requiredObjects = new Array();
        }

    }
}

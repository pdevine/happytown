package
{
    public class Person extends Actor
    {

        public var requiredObjects:Array;

        public function Person(vpX:Number, vpY:Number)
        {
            super(vpX, vpY);

            requiredObjects = new Array();
        }

    }
}

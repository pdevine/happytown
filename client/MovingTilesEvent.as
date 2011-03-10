package
{
    import flash.events.Event;

    public class MovingTilesEvent extends flash.events.Event
    {
        public static const CONTROL_TYPE:String = "tileControl";
        public var command:String;

        public function MovingTilesEvent(command:String)
        {
            super(CONTROL_TYPE);
            this.command = command;
        }
    }
}

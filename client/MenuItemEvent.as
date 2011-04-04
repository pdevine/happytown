package
{
    import flash.events.Event;

    public class MenuItemEvent extends flash.events.Event
    {
        public static const CONTROL_TYPE:String = "headControl";
        public var command:String;
        public var domain:String;

        public function MenuItemEvent(command:String, domain:String)
        {
            super(CONTROL_TYPE);
            this.command = command;
            this.domain = domain;
        }
    }
}

package
{

    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class LevelSelect extends MenuItem
    {

        public var currentLevel:int = 5;

        private var decrementLevel:TextField;
        private var incrementLevel:TextField;
        private var levelNumber:TextField;

        public var totalLevels:int = 0;

        public function LevelSelect(x:Number, y:Number, levels:int=5)
        {
            super("level", x, y, false);

            totalLevels = levels;

            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            
            decrementLevel = createTextField('-');
            decrementLevel.x = textField.width + 20;
            addChild(decrementLevel);

            levelNumber = createTextField(String(currentLevel));
            levelNumber.x = decrementLevel.x + decrementLevel.width + 5;
            addChild(levelNumber);

            incrementLevel = createTextField('+');
            incrementLevel.x = levelNumber.x + levelNumber.width + 5;
            addChild(incrementLevel);
        }

        private function onAddedToStage(event:Event):void
        {
            decrementLevel.addEventListener(
                MouseEvent.MOUSE_DOWN, onMouseDecrementDown);
            incrementLevel.addEventListener(
                MouseEvent.MOUSE_DOWN, onMouseIncrementDown);
        }

        private function onMouseDecrementDown(event:MouseEvent):void
        {
            decrementLevel.y -= 3;
            decrementLevel.x -= 3;

            decrementLevel.addEventListener(
                MouseEvent.MOUSE_UP, onMouseDecrementUp);
        }

        private function onMouseDecrementUp(event:MouseEvent):void
        {
            decrementLevel.y += 3;
            decrementLevel.x += 3;

            currentLevel = Math.max(1, currentLevel - 1);
            levelNumber.text = String(currentLevel);

            decrementLevel.removeEventListener(
                MouseEvent.MOUSE_UP, onMouseDecrementUp);
        }

        private function onMouseIncrementDown(event:MouseEvent):void
        {
            incrementLevel.y -= 3;
            incrementLevel.x -= 3;

            incrementLevel.addEventListener(
                MouseEvent.MOUSE_UP, onMouseIncrementUp);
        }

        private function onMouseIncrementUp(event:MouseEvent):void
        {
            incrementLevel.y += 3;
            incrementLevel.x += 3;

            currentLevel = Math.min(totalLevels, currentLevel + 1);
            levelNumber.text = String(currentLevel);

            incrementLevel.removeEventListener(
                MouseEvent.MOUSE_UP, onMouseIncrementUp);
        }
    }
}

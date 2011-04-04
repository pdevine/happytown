package
{

    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class LevelSelect extends MenuItem
    {

        private var decrementLevel:TextField;
        private var incrementLevel:TextField;
        private var levelNumber:TextField;

        public var totalLevels:int = 0;

        public function LevelSelect(
                            domain:String,
                            x:Number,
                            y:Number,
                            levels:int=5)
        {
            super("level", domain, x, y, false);

            totalLevels = levels;

            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            
            decrementLevel = createTextField('-');
            decrementLevel.x = textField.width + 20;
            addChild(decrementLevel);

            var dm:DataManager = DataManager.getInstance();
            levelNumber = createTextField(String(dm.currentLevel));
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
            decrementLevel.addEventListener(
                MouseEvent.MOUSE_OVER, onMouseDecrementOver);
            decrementLevel.addEventListener(
                MouseEvent.MOUSE_OUT, onMouseDecrementOverOut);
            incrementLevel.addEventListener(
                MouseEvent.MOUSE_DOWN, onMouseIncrementDown);
            incrementLevel.addEventListener(
                MouseEvent.MOUSE_OVER, onMouseIncrementOver);
            incrementLevel.addEventListener(
                MouseEvent.MOUSE_OUT, onMouseIncrementOverOut);
        }

        private function onMouseDecrementDown(event:MouseEvent):void
        {
            decrementLevel.y -= 3;
            decrementLevel.x -= 3;

            decrementLevel.addEventListener(
                MouseEvent.MOUSE_OUT, onMouseDecrementOut);
            decrementLevel.addEventListener(
                MouseEvent.MOUSE_UP, onMouseDecrementUp);
        }

        private function onMouseDecrementOver(event:MouseEvent):void
        {
            decrementLevel.textColor = 0xff0000;
        }

        private function onMouseDecrementOverOut(event:MouseEvent):void
        {
            decrementLevel.textColor = 0x000000;
        }

        private function onMouseDecrementOut(event:MouseEvent):void
        {
            resetDecrementSprite();
        }

        private function onMouseDecrementUp(event:MouseEvent):void
        {
            var dm:DataManager = DataManager.getInstance();
            dm.currentLevel = Math.max(1, dm.currentLevel - 1);
            levelNumber.text = String(dm.currentLevel);

            resetDecrementSprite();
        }

        private function resetDecrementSprite():void
        {
            decrementLevel.y += 3;
            decrementLevel.x += 3;

            decrementLevel.removeEventListener(
                MouseEvent.MOUSE_OUT, onMouseDecrementOut);
            decrementLevel.removeEventListener(
                MouseEvent.MOUSE_UP, onMouseDecrementUp);
        }

        private function onMouseIncrementDown(event:MouseEvent):void
        {
            incrementLevel.y -= 3;
            incrementLevel.x -= 3;

            incrementLevel.addEventListener(
                MouseEvent.MOUSE_OUT, onMouseIncrementOut);
            incrementLevel.addEventListener(
                MouseEvent.MOUSE_UP, onMouseIncrementUp);
        }

        private function onMouseIncrementOver(event:MouseEvent):void
        {
            incrementLevel.textColor = 0xff0000;
        }

        private function onMouseIncrementOverOut(event:MouseEvent):void
        {
            incrementLevel.textColor = 0x000000;
        }

        private function onMouseIncrementOut(event:MouseEvent):void
        {
            resetIncrementSprite();
        }

        private function onMouseIncrementUp(event:MouseEvent):void
        {
            var dm:DataManager = DataManager.getInstance();
            dm.currentLevel = Math.min(totalLevels, dm.currentLevel + 1);
            levelNumber.text = String(dm.currentLevel);

            resetIncrementSprite();
        }

        private function resetIncrementSprite():void
        {
            incrementLevel.y += 3;
            incrementLevel.x += 3;

            incrementLevel.removeEventListener(
                MouseEvent.MOUSE_OUT, onMouseIncrementOut);
            incrementLevel.removeEventListener(
                MouseEvent.MOUSE_UP, onMouseIncrementUp);
        }
        
    }
}

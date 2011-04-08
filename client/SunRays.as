package
{
    import flash.display.Sprite;

    public class SunRays extends Sprite
    {
        private var container:Sprite;

        public function SunRays()
        {
            container = new Sprite();

            createRay(-700,  -50, -700,   50, 0xe6e6e6, 0.2);
            createRay( 700,  -50,  700,   50, 0xe6e6e6, 0.2);
            createRay( -50, -700,   50, -700, 0xe6e6e6, 0.2);
            createRay( -50,  700,   50,  700, 0xe6e6e6, 0.2);

            addChild(container);
        }

        private function createRay(
            ax:int,
            ay:int,
            bx:int,
            by:int,
            color:uint,
            alpha:Number):void
        {
            container.graphics.beginFill(color, alpha);
            container.graphics.moveTo(0, 0);
            container.graphics.lineTo(ax, ay);
            container.graphics.lineTo(bx, by);
            container.graphics.lineTo(0, 0);
            container.graphics.endFill();
        }

    }
}

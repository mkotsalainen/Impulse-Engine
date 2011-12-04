package impulse.display
{
	import impulse.core.*;
	import flash.display.*;
	import flash.geom.Point;
	import impulse.*;

	public class CircleSprite extends ImpulseSprite
	{
		
		public function CircleSprite(b:CircleBody, parent:DisplayObjectContainer, color:Number)
		{
			super(b, parent, color);
			drawShape();
		}
		
		protected override function drawShapeWithCM():void
		{
			g.drawCircle(0, 0, (body as CircleBody).radius);
		}
		
		protected override function drawShapeNoCM():void
		{
			g.drawCircle(0,0, (body as CircleBody).radiusNoCM);
		}
	}
}
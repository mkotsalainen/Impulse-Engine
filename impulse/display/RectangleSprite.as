package impulse.display
{
	import impulse.core.*;
	import flash.display.*;
	import flash.geom.Point;
	import impulse.*;

	public class RectangleSprite extends ImpulseSprite
	{
		public var drawMargin:Boolean = true;
		
		public function RectangleSprite(b:RectangleBody, parent:DisplayObjectContainer, color:Number)
		{
			super(b, parent, color);
			drawShape();
		}
	}
}
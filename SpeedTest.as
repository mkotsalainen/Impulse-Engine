package
{
	import flash.display.*;
	import impulse.util.*;
	import flash.geom.*;
	import flash.utils.*;
	import impulse.core.CsoPoint;
	import impulse.core.ClosestPoint;

	
	public class SpeedTest extends Sprite
	{
		private var iterations:Number = 1000000;
		
		public function SpeedTest()
		{	
			test2();	
			test1();			
		} 
		
		public function test1():void
		{
			var t:Number = getTimer();

			var a:Point = new Point(100,100);
			var b:Point = new Point(1,1.2)
			for (var i:Number = 0; i < iterations; i++)
			{
				Vec.add(a, b);
			}
			trace("elapsed time:" + (getTimer() - t));	
		}
		
		public function test2():void
		{
			var t:Number = getTimer();

			var a:Point = new Point(100,100);
			var b:Point = new Point(1,1.2);
			for (var i:Number = 0; i < iterations; i++)
			{
				a.x += b.x;
				a.y += b.y;
			}
			trace("elapsed time:" + (getTimer() - t));	
		}
	}
}
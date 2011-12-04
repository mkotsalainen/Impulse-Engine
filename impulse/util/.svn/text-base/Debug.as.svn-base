// ActionScript file
package impulse.util
{
	import flash.geom.Point;

	public class Debug
	{
		//#debug
		public static function assertPoint(v:Point) : void
		{
			assert (v != null && !Vec.isZero(v), "point is zero");
		}
		
		//#debug
		public static function assert(test:Boolean, msg:String = null) : void
		{
			if (!test) {
				trace("assertion failed");
				if (msg) trace(msg);
				var z:Point;
				z.length;	//we force the debugger to stop
			}	
		}
	}
}
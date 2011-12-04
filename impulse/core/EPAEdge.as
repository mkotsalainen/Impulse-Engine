package impulse.core
{
	import flash.geom.Point;
	import impulse.util.*;
	import impulse.display.Grid;
	
	public class EPAEdge
	{
		public var a:Point;
		public var b:Point;
		public var closestP:Point;
		public var closestPointLength:Number;
		public var isInvalid:Boolean;
		
		public function EPAEdge(a:Point, b:Point)
		{
			this.a = a;
			this.b = b;
			findClosestP();
		}
				
		private function findClosestP() : void
		{
			var ab:Point = b.subtract(a);
			Debug.assertPoint(ab);
				
			var ao:Point = Vec.neg(a);	//we are looking for the point closest to origo
			var t:Number = Vec.dot(ao, ab)
			var n:Number = Vec.dot(ab, ab);
			
			if (t < 0 || t > n)
			{
				isInvalid = true;
				return;
			}
			
			closestP = Point.interpolate(b, a, t/n);
			closestPointLength = closestP.length;
		}
	}
}
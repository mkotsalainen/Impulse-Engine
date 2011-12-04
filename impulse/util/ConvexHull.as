package impulse.util
{
	import flash.geom.Point;
	
	public class ConvexHull
	{
		public static function create(verts:Array):Array
		{
			var arr:Array = ArrayUtil.removeDuplicates(verts);
			if (arr.length < 4) return arr;
			
			arr.sortOn(["x", "y"], Array.NUMERIC);
			
			var l:Number;
			var r:Boolean;
			
			var upper:Array = new Array(arr[0], arr[1]);
			for (var i:Number = 2; i < arr.length; i++)
			{
				upper.push(arr[i]);
				
				l = upper.length;
				r = rightTurn(upper[l-3], upper[l-2], upper[l-1]);
				while (!r)
				{
					upper.splice(upper.length-2, 1);
					if (upper.length <= 2) break;
					l = upper.length;
					r = rightTurn(upper[l-3], upper[l-2], upper[l-1]);
				}
			}
			
			var lower:Array = new Array(arr[arr.length-1], arr[arr.length-2]);
			for (var j:Number = arr.length-3; j >= 0; j--)
			{
				lower.push(arr[j]);
				l = lower.length;
				r = rightTurn(lower[l-1], lower[l-2], lower[l-3]);
				
				while (r)
				{
					lower.splice(l-2, 1);
					if (lower.length <= 2) break;
					l = lower.length;
					r = rightTurn(lower[l-1], lower[l-2], lower[l-3]);
				}
			}
			
			lower.splice(0, 1);
			lower.splice(lower.length-1, 1);
			
			var hull:Array = upper.concat(lower);
			return hull;
		}
	
		public static function rightTurn(a:Point, b:Point, c:Point):Boolean
		{
			var v1:Point = b.subtract(a);
			var v2:Point = c.subtract(b);
			return (Vec.cross(v2, v1) >= 0);
		}
	}
}
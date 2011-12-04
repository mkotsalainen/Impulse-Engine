package impulse.util
{
	import flash.geom.Matrix;
	
	public class MathUtil
	{
		public static function transformPoints(m:Matrix, arr:Array):Array
		{
			var newArr:Array = new Array(arr.length);
			for (var i:Number = 0; i < arr.length; i++) {
				newArr[i] = m.transformPoint(arr[i]);
			} 
			return newArr; 
		}
		
		//#inline
		public static function sign(val:Number):Number
		{
			return ((val<0) ? -1 : 1);
		}
	}
}
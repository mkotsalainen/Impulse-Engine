package
{
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	import impulse.util.ArrayUtil;
	import Set;
	
	public class SetTester extends Sprite
	{
		private var iterations:Number = 100;
		private var pointSet:Set = new Set();
		
		public function SetTester()
		{
			var numbers:Array = [3, 5, 2, 3, 1];
			var s:Set = new Set();
			s.addArray(numbers);
			
			var array:Array = s.asArray();
			for (var j:Number = 0; j < array.length; j++)
			{
				trace(array[j] + ".");			
			}
			
			var arr:Array = new Array();
			for (var i:Number = 0; i < iterations; i++)
			{
				var pz:Point = new Point(Math.random(), Math.random());
				arr.push(pz);
			}
			
			trace(ArrayUtil.contains(arr, arr[Math.floor(arr.length/2)].clone()));
		} 

	}
}
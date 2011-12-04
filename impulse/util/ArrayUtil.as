package impulse.util
{
	//TODO: extend array
	public class ArrayUtil
	{
		//we assume that o has method equals
		public static function contains(arr:Array, o:Object):Boolean
		{
			return (indexOf(arr, o) != -1);
		}
		
		//like Array.indexOf, except we use equals instead of simply looking
		//at object references with ===
		public static function indexOf(arr:Array, o:Object):Number
		{
			var l:Number = arr.length;
			for (var i:Number = 0; i < l; i++) {
				if (arr[i].equals(o)) return i;
			}
			return -1;
		}
		
		
		//todo: optimize
		public static function removeDuplicates(arr:Array):Array
		{
			var newArr:Array = new Array();
			
			var l:Number = arr.length;
			for (var i:Number = 0; i < l; i++)
			{
				if (!contains(newArr, arr[i])) newArr.push(arr[i]);				
			}
			return newArr;
		}
		
		//#inline
		public static function remove(arr:Array, index:Number):Array
		{
			/*
			if (arr.length == 1)
			{
				trace("aaa");
				arr.pop();
				return arr;
			}
			*/
			
			arr.splice(index, 1)
			return arr;
		}
	}
}
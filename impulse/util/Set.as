package impulse.util
{
	import impulse.util.IHashCode;
	
	//faster than using arrays to represent collections when you have more than ~200 objects
	//WHEN - random access?
	//suports 
	//ie. array.contains() loops through all the objects and does the comparison
	dynamic public class Set
	{
		
		public function add(o:Object):Boolean
		{
			if (contains(o)) return false;
			this[o.toString()] = o;
			return true;
		}
		
		public function addArray(arr:Array):void
		{
			for (var i:Number = 0; i < arr.length; i++) {
				add(arr[i]);			
			}	
		}
		
		public function asArray():Array
		{
			var arr:Array = new Array();
			for (var o:Object in this) arr.push(this[o]);
			return arr;
		}
		
		public function remove(o:IHashCode):void
		{
			delete this[o.hashCode()]
		}
		
		public function contains(o:IHashCode):Boolean
		{
			return (this[o.hashCode()]!=undefined);
		}
	}
}
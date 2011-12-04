package impulse.core
{
	import flash.geom.Point;
	
	public class CsoPoint extends Point
	{
		public var b1p:Point;
		public var b2p:Point;
		
		//the search dir used to get this point
		//useful during debugging, but can be removed for production
		public var d:Point;
		
		private static var pool:Array;
		
		public function CsoPoint(b1p:Point = null, b2p:Point = null) : void
		{
			if (b1p != null)
			{
				this.b1p = b1p;
				this.b2p = b2p;
				update();
			}
		}
		
		public function update() : void
		{
			x = b1p.x - b2p.x;
			y = b1p.y - b2p.y;
		}
		
		public static function createPool() : void
		{
			pool = new Array(100);
			for (var i:Number = 0; i < 100; i++)
			{
				pool[i] = new CsoPoint(new Point(), new Point());
			}
		}
		
		public static function allocate(b1p:Point = null, b2p:Point = null) : CsoPoint
		{
			return pool.pop();
		}
		
		public static function free(p:CsoPoint) : void
		{
			pool.push(p);	
		}
		
		public function csoEq(p:CsoPoint) : Boolean
		{
			return (equals(p) && d.equals(p.d));
		}
		
		public function copyInto(p:CsoPoint) : void
		{
			p.b1p = b1p;
			p.b2p = b2p;
			p.update();
		}
	}
}
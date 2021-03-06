package impulse.util
{
	import flash.geom.Point;
	import flash.geom.Matrix;
	import impulse.*;

	public class Vec
	{
		public static const EPS:Number = 0.00001;
		
		//#inline
		public static function add(a:Point, b:Point):Point
		{
			a.x += b.x;
			a.y += b.y;
			return a;
		}
		
		//#inline
		public static function addNoReturn(a:Point, b:Point):void
		{
			trace("bar")	
			a.x += b.x;
			a.y += b.y;
		}
		
		
		//#inline
		public static function sameDir(v1:Point, v2:Point):Boolean
		{			
			Debug.assertPoint(v1);
			Debug.assertPoint(v2);
			
			return dot(v1, v2) >= 0;
		}
		
		//#inline
		public static function oppositeDir(v1:Point, v2:Point):Boolean
		{
			Debug.assertPoint(v1);
			Debug.assertPoint(v2);
			
			return dot(v1, v2) < 0;
		}
		
		//we assume that v1 and v2 start at same point
		//#inline
		public static function above(v1:Point, v2:Point):Boolean
		{
			Debug.assertPoint(v1);
			Debug.assertPoint(v2);
			
			return cross(v1, v2) > 0;
		}
		
		//we assume that v1 and v2 start at same point
		//#inline
		public static function linearlyDependent(v1:Point, v2:Point):Boolean
		{
			Debug.assertPoint(v1);
			Debug.assertPoint(v2);
			
			return cross(v1, v2) == 0;
		}
		
		//#inline
		public static function equals(p1:Point, p2:Point):Boolean
		{
			return (dist(p1, p2) < 0.0001);
		}
		
		//#inline
		public static function dist(p1:Point, p2:Point):Number
		{
			var dx:Number = p2.x - p1.x;
			var dy:Number = p2.y - p1.y;
			
			return Math.sqrt(dx*dx + dy*dy);
		}

		//#inline
		public static function below(v1:Point, v2:Point):Boolean
		{
			Debug.assertPoint(v1);
			Debug.assertPoint(v2);
			
			return cross(v1, v2) < 0;
		}
		
		//#inline
		public static function dot(v1:Point, v2:Point):Number
		{
			return v1.x*v2.x + v1.y*v2.y;
		}
		
		//#inline
		public static function cross(v1:Point, v2:Point):Number
		{
			//return -v1.x * v2.y + v1.y * v2.x;
			return v1.x * v2.y - v1.y * v2.x;
		}
		
		//#inline
		public static function mult(n:Number, v:Point):Point
		{
			return new Point(v.x*n, v.y*n);
		}
		
		//#inline
		public static function scale(n:Number, v:Point):Point
		{
			var p:Point = v.clone();
			p.normalize(n);
			return p;
		}
		
		//#inline
		public static function rotM(angle:Number):Matrix
		{
			var m:Matrix = new Matrix();
			m.rotate(angle);
			return m;
		}
		
		//#inline
		public static function abs(p:Point):Point
		{
			p.x = Math.abs(p.x);
			p.y = Math.abs(p.y);
			return p;
		}
		
		//#inline
		public static function copy(v1:Point, v2:Point):void
		{
			v1.x = v2.y;
			v1.x = v2.y;
		}
		
		//#inline
		public static function perpLeft(v:Point):Point
		{
			return new Point(v.y, -v.x);
		}
	
		//#inline
		public static function perpRight(v:Point):Point
		{
			return new Point(-v.y, v.x);
		}
		
		//#inline
		public static function rotate(v:Point, radians:Number):Point
		{
			var m:Matrix = rotM(radians);
			return m.deltaTransformPoint(v);
		}
		
		//#inline
		public static function neg(v:Point):Point
		{
			return new Point(-v.x, -v.y);	
		}
		
		//#inline
		public static function projBontoA(a:Point, b:Point):Point
		{
			var aUnit:Point = unit(a);
			return mult(dot(b, aUnit), aUnit);
		}
		
		public static function projBontoNormalizedA(a:Point, b:Point):Point
		{
			return mult(dot(b, a), a);
		}
		
		//#inline
		public static function unit(v:Point):Point
		{
			var vUnit:Point = v.clone();
			vUnit.normalize(1);
			return vUnit;
		}
		
		//#inline
		public static function isZero(v:Point):Boolean
		{
			return v.length < EPS;
		}
		
		//#inline
		public static function str(p:Point, decimals:Number = 2):String
		{
			var x:String = p.x.toFixed(decimals);
			var y:String = p.y.toFixed(decimals);
			return "(" + x + "," + y + ")";
		}
	}	
}
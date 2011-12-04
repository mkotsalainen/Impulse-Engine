package impulse.core
{
	import flash.geom.Point;
	import impulse.util.*;
	
	public class ClosestPoint
	{		
		
		public static function segment(p:Point, a:Point, b:Point) : Point
		{
			var ab:Point = b.subtract(a);
			var ap:Point = p.subtract(a);
			var t:Number = Vec.dot(ap, ab)
			if (t <= 0) return a;
			
			var n:Number = Vec.dot(ab, ab);
			if (t >= n) return b;
			else return Point.interpolate(b, a, t/n);
		}
		
		
		public static function triangle(p:Point, a:Point, b:Point, c:Point) : Point
		{
			var ab:Point = b.subtract(a);
			var ac:Point = c.subtract(a);
			var ap:Point = p.subtract(a);
			
			//check if P in vertex region outside A
			var d1:Number = Vec.dot(ab, ap);
			var d2:Number = Vec.dot(ac, ap);
			if (d1 < 0 && d2 <= 0) return a;
						
			//check if P in vertex region outside B
			var bp:Point = p.subtract(b);
		    var d3:Number = Vec.dot(ab, bp);
    		var d4:Number = Vec.dot(ac, bp);
			//the d4 <= d3 condition comes from BP*(AC - AC) <= 0 
    		if (d3 >= 0 && d4 <= d3) return b;
    		
    		//check if P in vertex region outside C 		
    		var cp:Point = p.subtract(c);
    		var d5:Number = Vec.dot(ab, cp);
    		var d6:Number = Vec.dot(ac, cp);
    		if (d6 >= 0 && d5 <= d6) return c;
    		 
    		// Check if P in edge region of AB, if so return projection of P onto AB
    		var vc:Number = d1*d4 - d3*d2;
    		if (vc <= 0 && d1 >= 0 && d3 <= 0)
    		{
    			var v:Number = d1 / (d1 - d3);
    			return Point.interpolate(a, b, 1-v);
    		}
    		
    		
    		// Check if P in edge region of AC, if so return projection of P onto AC
    		var vb:Number = d5*d2 - d1*d6;
    		if (vb <= 0 && d2 >= 0 && d6 <= 0)
    		{
    			var w:Number = d2 / (d2 - d6);
    			return Point.interpolate(a, c, 1-w);
    		}
  			
  			
  			// Check if P in edge region of BC, if so return projection of P onto BC
		    var va:Number = d3*d6 - d5*d4;
    		if (va <= 0 && (d4 - d3) >= 0 && (d5 - d6) >= 0)
    		{
        		var z:Number = (d4-d3) / ((d4-d3) + (d5-d6));
        		return Point.interpolate(b, c, 1-z);
      		}
      		
      		//if we get here, we're inside the triangle
      		return p;
  		}
 }
}
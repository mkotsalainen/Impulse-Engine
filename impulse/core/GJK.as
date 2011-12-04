package impulse.core
{
	import flash.display.*;
	import flash.geom.*;
	import impulse.core.*;
	import impulse.display.*;
	import impulse.*;
	import impulse.util.*;
	
	public class GJK
	{
		private static var maxIterations:Number = 5;
		
		public static function getClosestPoints(b1:Body, b2:Body, simplex:Array, withCM:Boolean) : CsoPoint
		{	
			var initialSimplex:Array = simplex.concat();
			
			if (Engine.stopDebugger)
			{
			}
									
			//fixLinearityIfNeeded(simplex);
			
			var closestDist:Number = Number.MAX_VALUE;
			var closestP:CsoPoint = new CsoPoint(new Point(), new Point());
			var searchDir:Point;
			var newPoint:CsoPoint;
			
			if (simplex.length == 1)
			{
				searchDir = Vec.neg(simplex[0]);
				newPoint = MinkowskiCSO.support(searchDir, b1, b2, withCM);				
				if (newPoint.csoEq(simplex[0])) return simplex[0];
				else simplex[1] = newPoint;
			}
			
			
			//Grid.instance.drawText("s0:" + Vec.str(simplex[0]), simplex[0].x+2, simplex[0].y-4, 0.4);
			//Grid.instance.drawText("s1:" + Vec.str(simplex[1]), simplex[1].x+2, simplex[1].y-4, 0.4);
			var i:Number = 0;
			while (true)
			{	
				if (i++ > 5) trace("GJK.closestPoint iteration: " + i);
				
				if (simplex.length == 3)
				{
					var containsOrigo:Boolean = reduceSimplexToClosestEdge(simplex);
					if (containsOrigo) return null;
				}

				projectOrigoOntoEdge(simplex, closestP);
				
				searchDir = Vec.neg(closestP);
				searchDir.normalize(1);
				newPoint = MinkowskiCSO.support(searchDir, b1, b2, withCM);				
								
				var proj:Number = Vec.dot(newPoint, searchDir);	
				var gettingCloser:Boolean = ((-proj + 0.1 < closestP.length) || proj > 0);
				if (!gettingCloser) return closestP;
				
				simplex.push(newPoint);
				newPoint.copyInto(closestP);
			}

			return closestP; //we won't get here, but the compiler requires a return
		}
		
		//#debug
		private static function closestPointDebugger(simplex:Array, searchDir:Point, newPoint:Point, closestP:CsoPoint, i:Number) : void
		{
			Grid.instance.drawVec(simplex[1].subtract(simplex[0]),simplex[0],Grid.darkGreen);
			Grid.instance.drawVec(searchDir, newPoint);
			//Grid.instance.drawText(""+i + ":" + Vec.str(newPoint), newPoint.x+2, newPoint.y-4, 0.4);
			Grid.instance.drawText(""+i + ":" + Vec.str(closestP), closestP.x+2, closestP.y-4, 1);
			Grid.instance.drawPoint(closestP, Grid.white,null,null,0.5);
		}
		
		//#inline
		private static function reduceSimplexToClosestEdge(simplex:Array) : Boolean
		{
			if (doTriangleSimplex(simplex) == null) return true;	
			else return false;
		}
				
		public static function projectOrigoOntoEdge(simplex:Array, cp:CsoPoint) : void
		{
			var a:CsoPoint = simplex[0];
			var b:CsoPoint = simplex[1];
			
			var ab:Point = b.subtract(a);
			var t:Number = 0;
			if (!Vec.isZero(ab))
			{
				var ao:Point = Vec.neg(a);
				t = Vec.dot(ao, ab) / Vec.dot(ab, ab);
			
				if (t > 1) t = 1;
				if (t < 0) t = 0;
			}
			
			cp.b1p = Point.interpolate(b.b1p, a.b1p, t);	//closest point on b1
			cp.b2p = Point.interpolate(b.b2p, a.b2p, t);	//closest point on b2
			cp.update();
		}
		
		//GJK-SA returns separating axis or null if there is a collision
		//takes two convex objects		
		public static function separatingAxis(b1:Body, b2:Body, simplex:Array, initialSearchDir:Point, withCM:Boolean) : Point
		{	
			var sa:Point = initializeSimplex(b1, b2, simplex, initialSearchDir, withCM);
			if (sa) return sa;
			
			//keep refining the simplex until we enclose origo or find a separating axis			
			while (true)
			{
				var searchDir:Point = doTriangleSimplex(simplex); 
				if (!searchDir) return null;

				simplex[2] = MinkowskiCSO.support(searchDir, b1, b2, withCM);
				if (Vec.oppositeDir(simplex[2], searchDir)) return searchDir;	//seachDir is a separating axis	
			}
			
			//we won't get here
			return null;
		}
		
		public static function initializeSimplex(b1:Body, b2:Body, simplex:Array, initialSearchDir:Point, withCM:Boolean):Point
		{
			var searchDir:Point = initialSearchDir;
			
			//1st simplex point	
			simplex[0] = MinkowskiCSO.support(searchDir, b1, b2, withCM);
			if (Vec.oppositeDir(simplex[0], searchDir)) return searchDir;
						
			//2nd simplex point
			searchDir = Vec.neg(simplex[0]);
			simplex[1] = MinkowskiCSO.support(searchDir, b1, b2, withCM);
			if (Vec.oppositeDir(simplex[1], searchDir)) return searchDir;
			
			//3nd simplex point
			searchDir = doLineSimplex(simplex);
			simplex[2] = MinkowskiCSO.support(searchDir, b1, b2, withCM);
			if (Vec.oppositeDir(simplex[2], searchDir)) return searchDir;
			
			return null;
		}
		
		public static function doLineSimplex(simplex:Array):Point
		{
			var ba:Point = simplex[0].subtract(simplex[1]);
			var bo:Point = Vec.neg(simplex[1]);
			
			if (!Vec.isZero(ba) && Vec.sameDir(ba, bo))
			{	
				var perp:Point = Vec.perpRight(ba);
				if (Vec.sameDir(perp, bo))
				{
					return perp;
				}
				else {
					return Vec.neg(perp);	
				}
			}
			else {
				return bo;
			}
		}
		
		public static function doTriangleSimplex(simplex:Array):Point
		{
			var a:Point = simplex[0];
			var b:Point = simplex[1];
			var c:Point = simplex[2]; 
		
			var ca:Point = a.subtract(c);
			var cb:Point = b.subtract(c);
			var co:Point = Vec.neg(c);
			
			/*
			either	(ccw)	or	(cw)
				a				b
			c				c		
				b				a
			
			we can be sure that we're to the left of the ab line
			if origo is in the triangle, we're fine
			otherwise we have to modify the simplex by throwing away either
			a or b
			*/
			
			if (Vec.isZero(ca) || Vec.isZero(cb))
			{
				simplex.splice(0,3,a,b);
				return doLineSimplex(simplex);
			}
			
			if (Vec.above(ca, cb))
			{	//first case
				if (Vec.above(co, ca))
				{
					simplex.splice(0,3,a,c);
					return Vec.perpLeft(ca);
				}
				else if (Vec.below(co, cb)) {
					simplex.splice(0,3,b,c);
					return Vec.perpRight(cb);
				}
				else return null; 
			}
			else
			{
				//second case
				if (Vec.above(co, cb))
				{
					simplex.splice(0,3,b,c);
					return Vec.perpLeft(cb);
				}
				else if (Vec.below(co, ca)) {
					simplex.splice(0,3,a,c);
					return Vec.perpRight(ca);
				}
				else return null; 
			}
		}
	}
}
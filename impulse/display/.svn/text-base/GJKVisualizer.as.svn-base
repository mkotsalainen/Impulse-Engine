package impulse.display
{
	import impulse.core.*;
	import impulse.util.*;
	import flash.display.*;
	import flash.geom.Point;
	import flash.geom.Matrix;

	public class GJKVisualizer extends GJK
	{	
		private static var lastSeparatingAxis:Point;
		
		public static var drawOuter:Boolean;
		public static var drawInner:Boolean = true;
		
		public static function draw(b1:Body, b2:Body):void
		{	
			Grid.moveOrigo = true;
			drawCso(b1, b2);
			
			var simplex:Array = [];
			
			if (!b1.AABR.intersects(b2.AABR) || !intersection(simplex, true, b1, b2, Grid.white)) return;
			
			simplex = [];
			var push:Boolean = intersection(simplex, false, b1, b2, Grid.darkGreen);
			if (push) pushApart(simplex, b1, b2);
			
			if (!push) {	
				var closestP:CsoPoint = GJK.getClosestPoints(b1, b2, simplex, false);
				drawClosestPoint(closestP);
			}
			
			Grid.instance.drawOrigo((push) ? Grid.green : Grid.red);
		}
		
		private static function pushApart(simplex:Array, b1:Body, b2:Body):void
		{
			var leastPenetration:Point = EPA.penetrationDepthSolver(simplex, b1, b2, false);
			var v:Array = b2.getVerts(false);
			var m:Matrix = new Matrix();
			m.translate(leastPenetration.x, leastPenetration.y);
			m.translate(-Grid.origo.x, -Grid.origo.y);
			v = MathUtil.transformPoints(m, v);
			Grid.instance.drawPoly(v);
		}
		
		private static function intersection(simplex:Array, withCM:Boolean, b1:Body, b2:Body, color:Number):Boolean
		{
			//if we've already found a separating axis on a previous frame we feed that into GJK to get a potential early out.
			var initialSearchDir:Point = (lastSeparatingAxis) ? lastSeparatingAxis :
																b2.pos.subtract(b1.pos);
			
			var separatingAxis:Point = GJK.separatingAxis(b1, b2, simplex, initialSearchDir, withCM);
			
			//if ((withCM && drawOuter) || (!withCM && drawInner)) drawSearchDirs(simplex, b1, b2, color);
			
			if (separatingAxis)
			{
				lastSeparatingAxis = separatingAxis;
				return false;
			}
			
			return true;
		}
		
		public static function drawCso(b1:Body, b2:Body):void
		{
			var cso:Array;
			
			if (drawInner)
			{	
				cso = MinkowskiCSO.createExplicitCSO(b1.getVerts(false), b2.getVerts(false));
				Grid.instance.drawPoly(cso, Grid.grey);
			}
			
			if (drawOuter)
			{
				cso = MinkowskiCSO.createExplicitCSO(b1.getVerts(true), b2.getVerts(true));
				Grid.instance.drawPoly(cso, Grid.grey);
			}
		}
				
		private static function drawClosestPoint(cp:CsoPoint):void
		{
			if (cp == null) return;
			
			//Grid.instance.drawPoint(cp.add(origo), 0xffffff);
			Grid.instance.drawPoint(cp.b1p.subtract(Grid.origo), Grid.yellow);
			Grid.instance.drawPoint(cp.b2p.subtract(Grid.origo), Grid.yellow);	
		}
	}
}
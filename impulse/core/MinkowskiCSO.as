package impulse.core
{
	import impulse.core.*;
	import impulse.display.Grid;
	import flash.geom.*;
	import flash.display.*;
	import impulse.util.*;
	import flash.net.getClassByAlias;
		
	public class MinkowskiCSO
	{
		private var UP:Point = new Point(0, 1);
		private var RIGHT:Point = new Point(1, 0);
		private var DOWN:Point = new Point(0, -1);
		private var LEFT:Point = new Point(-1, 0);
		
		private static var unitCircle:Array;
		private static var topUnitCircle:Array;
		private static var bottomUnitCircle:Array;
		private static var numDirectionSamples:Number = 16;
		
		//only needed if you need an explicit representation of the cso for visualization purposes
		//not needed for GJK algorithm.
		public static function createExplicitCSO(b1Verts:Array, b2Verts:Array):Array
		{
			var cso:Array = new Array();
			
			for (var i:Number = 0; i < b1Verts.length; i++)
			{
				for (var j:Number = 0; j < b2Verts.length; j++)
				{
					cso.push(new CsoPoint(b1Verts[i], b2Verts[j]));
				}
			}
			
			return ConvexHull.create(cso);
		}
				
		//returns a vector to the center of the cso
		public static function csoPos(b1:Body, b2:Body) : CsoPoint
		{
			return new CsoPoint(b1.pos, b2.pos);
		}	
			
		public static function support(d:Point, b1:Body, b2:Body, withCM:Boolean) : CsoPoint
		{
			var p1:Point = b1.support(d, withCM);
			var p2:Point = b2.support(Vec.neg(d), withCM);			
			var p:CsoPoint = new CsoPoint(p1, p2);
			p.d = d;
			return p;
		}
		
		/*
		private static function createUnitCircle() : void
		{
			for (var i:Number = 0; i < numDirectionSamples; i++)
			{
				var a:Number = (i/numDirectionSamples) * 2*Math.PI;
				var d:Point = new Point(Math.cos(a), Math.sin(a));
				unitCircle[i] = d;
			}
		}
		*/
	}
}
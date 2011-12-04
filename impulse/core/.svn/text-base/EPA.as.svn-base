package impulse.core
{
	import flash.geom.Point;
	import impulse.display.Grid;
	import flash.display.Graphics;
	import impulse.util.*;
	
	/*
	* This is an implementation of the Expanding Polytope Algorithm as described by Gino van Bergen
	* in "Proximity Queries and Penetration Depth Computation on 3D Game Objects"
	*/
	public class EPA
	{	
		//returns the minimum translation distance that one object undergoes to make the interiors of the two bodies disjoint
		//the simplex that is passed should contain the origo. It can be the simplex returned by GJK.separatingAxis
		public static function penetrationDepthSolver(simplex:Array, b1:Body, b2:Body, withCM:Boolean):Point
		{
			var edges:Array = new Array();
	
			var e:EPAEdge = new EPAEdge(simplex[0], simplex[1]);
			if (!e.isInvalid) edges.push(e);
			
			e = new EPAEdge(simplex[1], simplex[2]);
			if (!e.isInvalid) edges.push(e);
			
			e = new EPAEdge(simplex[2], simplex[0]);
			if (!e.isInvalid) edges.push(e);
			edges.sortOn("closestPointLength", Array.NUMERIC);
			
			var errorTolerance:Number = Math.max(b1.pseudoRadius, b2.pseudoRadius)/50;
			
			while (true)
			{	
				var closestE:EPAEdge = edges.shift();
				var splitP:CsoPoint = MinkowskiCSO.support(closestE.closestP, b1, b2, withCM);
				
				var closeEnough:Boolean = (Vec.dist(splitP, closestE.closestP) < 0.5);
				if (closeEnough || Vec.equals(splitP,closestE.a) || Vec.equals(splitP,closestE.b))
				{
					edges.push(closestE);
					drawEdgesAndClosestP(edges, closestE.closestP);	
					return closestE.closestP;
				}
				
				e = new EPAEdge(closestE.a, splitP);
				if (!e.isInvalid) edges.push(e);
				
				e = new EPAEdge(splitP, closestE.b);
				if (!e.isInvalid) edges.push(e);
				
				edges.sortOn("closestPointLength", Array.NUMERIC);
			}
			
			return null; 	//we won't get here
		}
		
		//#debug
		private static function drawEdgesAndClosestP(edges:Array, closestP:Point):void
		{
			var verts:Array = new Array();
			var g:Graphics = Grid.instance.g;
			g.lineStyle(1, Grid.darkRed);
			
			for each (var edge:EPAEdge in edges)
			{
				g.moveTo(edge.a.x + Grid.origo.x, edge.a.y + Grid.origo.y);
				g.lineTo(edge.b.x + Grid.origo.x, edge.b.y + Grid.origo.y);
			}
			Grid.instance.drawPoint(closestP);
		}
	}
}	
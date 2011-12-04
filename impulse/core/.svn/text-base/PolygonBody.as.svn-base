package impulse.core
{
	import flash.geom.*;
	import impulse.util.*;
	import flash.events.Event;
	
	
	public class PolygonBody extends Body
	{
		public var numVerts:Number;
		
		public function PolygonBody(pos:Point, rot:Number, verts:Array, mass:Number)
		{
			super(pos, rot);
			this.verts = verts;
			
			centerVerts();
			numVerts = verts.length;
			calculatePseudoRadius();
			setMassAndInertia(mass, mass*10);
		}
		
		public function centerVerts():void
		{
			updateAABR();
			
			var move:Point = Vec.mult(-1, getCenter(AABR));
			for (var i:Number = 0; i < verts.length; i++) {
				verts[i] = verts[i].add(move);
			}
			
			updateAABR();
			dispatchEvent(new Event("bodyUpdate"));
		}
		
		public function getCenter(r:Rectangle):Point
		{
			return r.topLeft.add(Vec.mult(0.5, r.bottomRight.subtract(r.topLeft)));
		}
		
		public override function support(d:Point, withCM:Boolean):Point
		{
			d = worldToLocalSpace.deltaTransformPoint(d);
			var maxDot:Number = 0;
			var supportV:Point = verts[0];
			
			var vs:Array = (withCM) ? verts : vertsNoCM;
			for (var i:Number = 0; i < verts.length; i++)
			{
				var dot:Number = Vec.dot(vs[i], d);
				if (dot > maxDot) {
					maxDot = dot;
					supportV = vs[i];
				}
			}
			return supportV;
		}
	}
}
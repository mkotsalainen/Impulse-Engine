package impulse.core
{
	import flash.geom.Point;
	import impulse.util.Debug;
	
	public class CircleBody extends Body
	{
		public var radius:Number;
		public var radiusNoCM:Number;
		
		private static var numVerts:Number = 20;
		
		public function CircleBody(pos:Point, radius:Number, mass:Number)
		{
			super(pos, 0);
			this.radius = radius;
			Debug.assert(2*collisionMargin < radius);
			
			radiusNoCM = radius - collisionMargin;
			
			verts = new Array(numVerts);
			vertsNoCM = new Array(numVerts);
			
			for (var i:Number = 0; i < numVerts; i++)
			{
				var a:Number = (i*2*Math.PI)/numVerts;
				verts[i] = Point.polar(radius, a);
				vertsNoCM[i] = Point.polar(radiusNoCM, a);
			}
			
			updateAABR();
			pseudoRadius = radius;
			setMassAndInertia(mass, 0.5 * radius * radius * mass); //this is the true inertia
			//setMassAndInertia(mass, 0.005 * radius * radius * mass); //this is the true inertia
		}
		
		//returns the point of the body furthest in the direction of d. (in world coords)
		public override function support(d:Point, withCM:Boolean):Point
		{
			var p:Point = d.clone();
			p.normalize((withCM) ? radius : radiusNoCM);
			p.x += pos.x; p.y += pos.y;
			return p;
		}
		
		public override function updateAABR():void
		{
			AABR.left = pos.x - radius - AABRMargin;
			AABR.top = pos.y - radius - AABRMargin;
			AABR.width = AABR.height = 2*(radius + AABRMargin);
		}
	}
}
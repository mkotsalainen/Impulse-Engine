package impulse.core
{
	import impulse.display.*;
	import impulse.core.*;
	import impulse.util.*;
	import flash.geom.*;
	
	public class RectangleBody extends Body
	{										
		public var e:Point;		//the halfwidth extents with collision margin
		public var eNoCM:Point;	//the halfwidth extents without collision margin
		
		public function RectangleBody(pos:Point, rot:Number, width:Number, height:Number, mass:Number)
		{
			super(pos, rot);
			
			e = new Point(width/2, height/2);
			
			verts = new Array(new Point(-e.x,e.y),
							new Point(e.x,e.y),
							new Point(e.x,-e.y),
							new Point(-e.x,-e.y));
			
			Debug.assert(collisionMargin < e.x && collisionMargin < e.y);
			
			eNoCM = new Point(e.x - collisionMargin, e.y - collisionMargin);
			
			vertsNoCM = new Array(new Point(-eNoCM.x,eNoCM.y),
							new Point(eNoCM.x,eNoCM.y),
							new Point(eNoCM.x,-eNoCM.y),
							new Point(-eNoCM.x,-eNoCM.y));
			
			updateAABR();
			calculatePseudoRadius();
			setMassAndInertia(mass, 4/12 * mass * (e.x*e.x + e.y*e.y));
		}
				
		//returns the point of the body furthest in the direction of d. (in world coords)
		public override function support(d:Point, withCM:Boolean):Point
		{
			//translate vector into local space
			d = worldToLocalSpace.deltaTransformPoint(d);
									
			var p:Point = new Point();
			var halfwidth:Point = (withCM) ? e : eNoCM;			
			p.x = MathUtil.sign(d.x) * halfwidth.x;
			p.y = MathUtil.sign(d.y) * halfwidth.y;	
			
			return localToWorldSpace.transformPoint(p);
		}
	}
}
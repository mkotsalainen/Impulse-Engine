package impulse.core
{
	import flash.geom.Point;
	import impulse.util.*;
	import impulse.display.Grid;
	
	/*
	* The collision point actually consists of two points, one on each body
	* Since the collision margin is small, they will be close together
	* The unit length contact normal is pointing out from body 2 (b2) towards body 1
	*/
	
	public class Contact
	{	
		public var b1:Body;
		public var b2:Body;
		public var b1WorldHitPos:Point;
		public var b2WorldHitPos:Point;
		public var b1LocalHitPos:Point;
		public var b2LocalHitPos:Point;
		public var normal:Point;
		public var separation:Number = 0;
		public var accumulatedNormalImpulse:Number = 0;
		public var accumulatedTangentImpulse:Number = 0;
		public var massNormal:Number = 0;
		public var massTangent:Number = 0;
		public var bias:Number = 0;	//?
		private static var createdContacts:Number = 0;
		public var id:Number;
		//? FeaturePair feature;
		
		public function Contact(b1:Body, b2:Body, b1WorldHitPos:Point, b2WorldHitPos:Point)
		{
			this.b1 = b1;
			this.b2 = b2;
			id = createdContacts++;
			update(b1WorldHitPos, b2WorldHitPos);
		}
		
		public function update(b1WorldHitPos:Point, b2WorldHitPos:Point) : void
		{
			this.b1WorldHitPos = b1WorldHitPos;
			this.b2WorldHitPos = b2WorldHitPos;
			
			b1LocalHitPos = b1.worldToLocalSpace.transformPoint(b1WorldHitPos);
			b2LocalHitPos = b2.worldToLocalSpace.transformPoint(b2WorldHitPos);
			
			normal = b2WorldHitPos.subtract(b1WorldHitPos);
			normal.normalize(1);
		}
		
		public function refreshSeparation() : void
		{				
			b1WorldHitPos = b1.localToWorldSpace.transformPoint(b1LocalHitPos);
			b2WorldHitPos = b2.localToWorldSpace.transformPoint(b2LocalHitPos);
			Grid.instance.drawPoint(b2WorldHitPos, Grid.blue);
			separation = Vec.dist(b2WorldHitPos, b1WorldHitPos);
		}
	}
}
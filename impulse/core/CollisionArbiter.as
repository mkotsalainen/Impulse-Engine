package impulse.core
{
	import flash.display.*;
	import flash.geom.Point;
	
	import impulse.display.GJKVisualizer;
	import impulse.display.Grid;
	import impulse.util.*;
	
	public class CollisionArbiter
	{
		public var b1:Body;
		public var b2:Body;
		public var firstTimeInContact:Boolean = false;
		public var contacts:Array = new Array();
		public var numContacts:Number = 0;
		public var friction:Number;
		private var simplex:Array = new Array();
		private var contactWithLeastSeparation:Number = 0;
		private static var totalMargin:Number;
		private static var allowedPenetration:Number = Body.collisionMargin/5;
		private var leastAllowedSeparation:Number;
		private var lastSeparatingAxis:Point;
		
		public function CollisionArbiter(b1:Body, b2:Body)
		{
			this.b1 = b1;
			this.b2 = b2;
			leastAllowedSeparation = 2*Body.collisionMargin - allowedPenetration;
			
			//calculate friction 
			//friction = (float) Math.sqrt(body1.getFriction() * body2.getFriction());
		}
		
		public function refreshContactSeparation():void
		{
			//trace("refreshContactSeparation");
			//update existing contacts
			for (var i:Number = 0; i < numContacts; i++)
			{
				var c:Contact = contacts[i];
				c.refreshSeparation();
				var withinMargins:Boolean = (c.separation < 2*Body.collisionMargin);
				
				if (!withinMargins) {
					trace("removing contact not within margins" + c.separation + ": id " + c.id);
					ArrayUtil.remove(contacts, i);
					numContacts--;
					i--;
				}
			}
		}
		
		public function collide():Boolean
		{
			simplex = [];
						
			//early out if the AABRs don't intersect
			//and then check if the bodies overlap with their collision margins
			if (!b1.AABR.intersects(b2.AABR) ||
				!intersection(simplex, true))
			{
				if (numContacts > 0) trace("clearing contacts");
				numContacts = 0;
				return false;
			}
			
			simplex = [];
						
			//if the interiors of the bodies are in contact, we have separate the bodies to
			//the closest point where only their collision margins are intersecting
			var push:Boolean = (intersection(simplex, false));
			if (push)
			{
				pushApart();
				simplex = [];	//we have to redo the intersection query because we have a new configuration
				intersection(simplex, false);
			}
				
			//at this point the bodies are just touching,
			//with their collision margins intersecting but not their interiors
			var closestP:CsoPoint = GJK.getClosestPoints(b1, b2, simplex, false);
			addContact(closestP);
				
			refreshContactSeparation();
			return (numContacts > 0);
		}
		
		public function intersection(simplex:Array, withCM:Boolean):Boolean
		{
			//if we've already found a separating axis on a previous frame we feed that into GJK to get a potential early out.
			var initialSearchDir:Point = (lastSeparatingAxis) ? lastSeparatingAxis :
																b2.pos.subtract(b1.pos);
			
			var separatingAxis:Point = GJK.separatingAxis(b1, b2, simplex, initialSearchDir, withCM);
			
			if (separatingAxis)
			{
				lastSeparatingAxis = separatingAxis;
				return false;
			}
			
			return true;
		}
		
		
		private function getSpeedRatio() : Number
		{
			//SpeedRatio [0,1]
			//0 -> b2 should move p
			//1 -> b1 should move -p
			//iterpolate inbetween
			var b1Speed:Number = b1.vel.length;
			var b2Speed:Number = b2.vel.length;
			var speedRatio:Number = (b2Speed == 0) ? 0 : b1Speed/b2Speed;
			if (speedRatio > 1) speedRatio = 1;
			return 0;
			return speedRatio;
		}	
			
		private function pushApart() : void
		{
			trace("pushApart()");
			var speedRatio:Number = getSpeedRatio();
			var d:Point = EPA.penetrationDepthSolver(simplex, b1, b2, true);
			//make the move a little larger so we get into the collision margin region
			//d.normalize(d.length + 2);
			//b1.pos = b1.pos.add(Vec.mult(speedRatio, d));
			//b2.pos = b2.pos.add(Vec.mult(-speedRatio, d));
			b2.pos = b2.pos.add(d);
			//b2.vel = new Point();
		}
		
		private function addContact(cp:CsoPoint):void
		{

			//Engine.instance.gravity = new Point();	//TODO remove
			//trace("removing gravity");
			//ImpulseEngine.instance.startPause();
				
			//Grid.instance.drawPoint(cp.b1p.subtract(Grid.origo), Grid.yellow);
			//Grid.instance.drawPoint(cp.b2p.subtract(Grid.origo), Grid.yellow);
			
			var updatedExistingContact:Boolean = false;
			
			for each (var c:Contact in contacts)
			{
				if (sameContact(cp, c))
				{
					c.update(cp.b1p, cp.b2p);
					updatedExistingContact = true;
					break;
				}
			}
			
			if (!updatedExistingContact)
			{
				contacts[numContacts++] = new Contact(b1, b2, cp.b1p, cp.b2p);
				trace("creating new contact" + contacts[numContacts-1].id);
				
				//we should never get more than two contacts in 2d since the shapes are convex
				Debug.assert(numContacts < 3);
			}
		}
		
		//TODO: improve
		//#inline
		public function sameContact(cp:CsoPoint, c:Contact) : Boolean
		{
			return (Vec.dist(cp.b1p, c.b1WorldHitPos) < 4);
		}	
		
		//TODO: check Vec.scales, his scales are actually mults
		public function preStep(invDt:Number) : void
		{	
			for each (var c:Contact in contacts)
			{
				//trace("pre step");
				
				var r1:Point = c.b1WorldHitPos.subtract(b1.pos);	
				var r2:Point = c.b2WorldHitPos.subtract(b2.pos);
				
				//Grid.instance.drawVec(r1, b1.pos.subtract(Grid.origo), Grid.yellow);
				//Grid.instance.drawVec(r2, b2.pos.subtract(Grid.origo), Grid.black);
				
				// Precompute normal mass, tangent mass, and bias.
				var rn1:Number = Vec.dot(r1, c.normal);
				var rn2:Number = Vec.dot(r2, c.normal);
				
				var kNormal:Number = b1.invMass + b2.invMass;
				//kNormal += b1.invI * (Vec.dot(r1, r1) - rn1*rn1);
				//kNormal += b2.invI * (Vec.dot(r2, r2) - rn2*rn2);	
				c.massNormal = 1/kNormal;
				
				/*
				var tangent:Point = Vec.perpRight(c.normal);	//or perpRight?
				var rt1:Number = Vec.dot(r1, tangent);
				var rt2:Number = Vec.dot(r2, tangent);
				
				
				var kTangent:Number = b1.invMass + b2.invMass;
				kTangent += b1.invI * (Vec.dot(r1, r1) - rt1*rt1);
				kTangent += b2.invI * (Vec.dot(r2, r2) - rt2*rt2);
				c.massTangent = 1 /  kTangent;
				*/
				
				// TODO: This hard code 0.1 is probably because of the standard 10 iterations
				// i.e. 1/10 - this probably isn't right.
				//c.bias = -0.1 * invDt * Math.min(0, c.separation + k_allowedPenetration);
						

				//c.bias = invDt * 0.01 * Math.max(0, leastAllowedSeparation - c.separation);
				
				var penetration:Number =  Body.collisionMargin - c.separation;
				c.bias = (penetration > 0) ? -invDt * 0.02 * penetration : 0;
				
				
				// Apply normal + friction impulse
				/*
				//Grid.instance.drawVec(impulse, c.b1.localToWorldSpace.transformPoint(c.b1HitPos));
				//trace("draw vec" + impulse);
				
				//impulse.add(Vec.mult(c.accumulatedTangentImpulse, tangent));
				//impulse.scale(body1.getHardness() + body2.getHardness());
				c.accumulatedNormalImpulse = 0;
				*/
				
				
				trace("accImpulse:" + c.accumulatedNormalImpulse);
				
				var impulse:Point = Vec.mult(c.accumulatedNormalImpulse, c.normal);
				b1.vel = b1.vel.add(Vec.mult(-b1.invMass, impulse));
				b1.angVel -= b1.invI * Vec.cross(r1, impulse);
				
				b2.vel = b2.vel.add(Vec.mult(b2.invMass, impulse));
				b2.angVel += b2.invI * Vec.cross(r2, impulse);
			}
		}
		
		/*
		*Collision model:
		*Body b2 smashes into body b1 by convention (even if b2 is still and b1 moving)
		*velocity of collision point on b1 - velocity of collision point on b2 = relative velocity (dv)
		*contact normal = c.b2WorldPos - c.b1WorldPos
		*/
		public function applyImpulse(iteration:Number, totalIterations:Number) : void
		{
			
			for each (var c:Contact in contacts)
			{
				//trace("apply impulse");
				var r1:Point = c.b1WorldHitPos.subtract(b1.pos);
				var r2:Point = c.b2WorldHitPos.subtract(b2.pos);
				
				// Relative velocity at contact
				var dv:Point = b2.vel.clone();
				dv = dv.add(Vec.mult(b2.angVel, Vec.perpRight(r2)));
				dv = dv.subtract(b1.vel);
				dv = dv.subtract(Vec.mult(b1.angVel, Vec.perpRight(r1)));

		
				if (iteration == 0)
				{
//					trace("before : " + Vec.str(b2.pos, 5) + " : " + Vec.str(b2.vel, 5));
				}
				else if (iteration == totalIterations-1)
				{
//					trace("after : " + Vec.str(b2.pos, 5) + " : " + Vec.str(b2.vel, 5));
				}
				
				if ((iteration == 0 || iteration == totalIterations-1) && Engine.stopDebugger)
				{
//					trace("stopping");
					Grid.instance.drawVec(dv, c.b2WorldHitPos.subtract(Grid.origo), Grid.red);
				}
				
				//Grid.instance.drawVec(Vec.scale(5, c.normal), c.b1.localToWorldSpace.transformPoint(c.b1HitPos), 0);
				
				// Compute normal impulse with bias.
				var vn:Number = Vec.dot(dv, c.normal);
				//trace("vn: " + vn);
				var normalImpulse:Number = c.massNormal * (-vn + c.bias);
				//var normalImpulse:Number = c.massNormal * -vn;
				//var normalImpulse:Number = c.massNormal * -vn*2;
				
				
				//we won't allow the accumulatedNormalImpulse to go below zero
				if (normalImpulse < -c.accumulatedNormalImpulse) normalImpulse = -c.accumulatedNormalImpulse;
				c.accumulatedNormalImpulse += normalImpulse;
				
				
				// Apply contact impulse
				var impulse:Point = Vec.mult(normalImpulse, c.normal);	//c.normal = 1/(1/m1 + 1/m2 + rotational terms))
				
				Grid.instance.drawVec(Vec.mult(1/c.massNormal, impulse), c.b1WorldHitPos.subtract(Grid.origo));
				
				b1.vel = b1.vel.add(Vec.mult(-b1.invMass, impulse));
				b1.angVel -= b1.invI * Vec.cross(r1, impulse);
				
				b2.vel = b2.vel.add(Vec.mult(b2.invMass, impulse));
				b2.angVel += b2.invI * Vec.cross(r2, impulse);
				
				//more calcs needed if we want friction
			}
		}
		
		public function equals(a:CollisionArbiter) : Boolean
		{
			return (b1.equals(a.b1) && b2.equals(a.b2));
		}
	}
}
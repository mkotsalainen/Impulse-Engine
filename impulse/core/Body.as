package impulse.core
{
	import flash.geom.*;
	import flash.utils.*;
	import impulse.*;
	import impulse.util.*;
	import impulse.display.Grid;
	import flash.events.*;
	
	public class Body implements IEventDispatcher, IEquals
	{
		public var pos:Point = new Point(0,0);
		public var previousPos:Point = new Point(0,0);
		
		public var vel:Point = new Point(0,0);	//linear velocity
		public var acc:Point = new Point(0,0);	//linear acceleration
		
		public var angVel:Number = 0;	//angular velocity
		public var angAcc:Number = 0;	//angular acceleration
		public var rot:Number = 0;
		
		public var mass:Number;
		public var invMass:Number;
		public var I:Number;
		public var invI:Number;
		
		public var force:Point = new Point(0,0);
		public var torque:Number = 0;
		
		public var dragCoeff:Number = 0.999;
		public var AABR:Rectangle = new Rectangle();
		public var pseudoRadius:Number;
		public static var AABRMargin:Number = 10;
		public static var collisionMargin:Number = 4;
		
		public var dispatcher:EventDispatcher;
		
		public var id:Number;
		private static var numCreatedBodies:Number = 0;
		
		public var localToWorldSpace:Matrix = new Matrix();
		public var worldToLocalSpace:Matrix = new Matrix();
		
		public var isStatic:Boolean;
		
		public var verts:Array;			//the verts in local body space
		public var vertsNoCM:Array;		//the verts without collision margin in local body space
		
		function Body(pos:Point, rot:Number)
		{
			dispatcher = new EventDispatcher();
			id = numCreatedBodies++;
			
			this.pos = pos;
			this.rot = rot;
			localToWorldSpace.createBox(1, 1, rot, pos.x, pos.y);
			worldToLocalSpace = localToWorldSpace.clone(); //optimize
			worldToLocalSpace.invert();
		}
		
		protected function calculatePseudoRadius():void
		{
			var w:Number = AABR.width;
			var h:Number = AABR.height;
			pseudoRadius = Math.sqrt(w*w + h*h);
		}
		
		//TODO: Implement infite mass
		public function setMassAndInertia(mass:Number, I:Number):void
		{
			this.mass = mass;
			if (mass < Number.MAX_VALUE)
			{
				invMass = 1/mass;
				this.I = I;
				invI = 1/I;	
			}
			else
			{
				invMass = 0;
				this.I = Number.MAX_VALUE;
				invI = 0;
			}
		}
		
		public function addForce(f:Point, bodyPos:Point):void
		{
			force = force
			force.x += f.x;
			force.y += f.y;
			
			//torque += cross(bodyPos, f);
			//trace("f" + force.length + ",t" + torque);
		}
		
		public function addExternalForces(force:Point, torque:Number):void
		{
			this.force = force.clone();
			this.torque = torque;
		}
		
		
		public function step(dt:Number):void
		{			
			//	Main.instance.debugger.text = "f:" + Point(force) + ",la:"+Point(linAcc)+",lv:"+Point(linVel)+",pos:"+Point(pos);
			
			trace("adsf" + pos.x);
			if (invMass == 0) return;
			
			acc = Vec.mult(invMass, force);
			vel = vel.add(Vec.mult(dt, acc));
			vel = Vec.mult(dragCoeff, vel);	//friction

			angAcc = invI * torque;
			angVel = (angVel + angAcc * dt) * dragCoeff;
			
			previousPos = pos.clone();			
			pos = pos.add(Vec.mult(dt, vel));
			rot += angVel*dt
			
			//trace("linVel:" + linVel);
			Grid.instance.drawVec(vel, pos.subtract(Grid.origo));		//Vec.scale(10, linVel)
			stateUpdated();
		}
		
		public function updateVel(dt:Number):void
		{			
			if (invMass == 0) return;
			
			acc = Vec.mult(invMass, force);
			vel = vel.add(Vec.mult(dt, acc));
			vel = Vec.mult(dragCoeff, vel);	//friction

			angAcc = invI * torque;
			angVel = (angVel + angAcc * dt) * dragCoeff;
		}
		
		public function updatePos(dt:Number):void
		{			
			//	Main.instance.debugger.text = "f:" + Point(force) + ",la:"+Point(linAcc)+",lv:"+Point(linVel)+",pos:"+Point(pos);
			
			if (invMass == 0) return;
			
			previousPos = pos.clone();			
			pos = pos.add(Vec.mult(dt, vel));
			rot += angVel*dt
			
			//trace("linVel:" + linVel);
			Grid.instance.drawVec(vel, pos.subtract(Grid.origo));		//Vec.scale(10, linVel)
			stateUpdated();
		}
		
		private function stateUpdated():void
		{
			localToWorldSpace.createBox(1, 1, rot, pos.x, pos.y);
			worldToLocalSpace = localToWorldSpace.clone(); //optimize
			worldToLocalSpace.invert();
			updateAABR();
		}
		
		public function setState(pos_x:Number, pos_y:Number, rot:Number):void
		{
			pos.x = pos_x;
			pos.y = pos_y;
			this.rot = rot;
			stateUpdated();
		}
		
		//takes a local space point vector, returns a world velocity
		//public function getLocalPointVel(p:Point):Point{}
		//takes a world space point vector, returns a world velocity
		//public function getWorldPointVel(p:Point):Point{}
					
		public function support(d:Point, withCM:Boolean):Point
		{
			throw new RequireOverrideError();	
		}
				
		public function updateAABR():void
		{
			AABR = Util.calculateAABR(getVerts(true));
		}
		
		public function getVerts(withCM:Boolean):Array
		{
			return MathUtil.transformPoints(localToWorldSpace, (withCM) ? verts : vertsNoCM);
		}
		
		public function equals(o:IEquals):Boolean
		{
			if (!o is Body) return false;
			else return ((o as Body).id == id);
		}
		
		public function str():String
		{
			return "pos:"+Vec.str(pos)+" vel:" + Vec.str(vel);
		}
		
		//the event methods
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
		 	dispatcher.addEventListener(type, listener, useCapture, priority);
        }
           
    	public function dispatchEvent(evt:Event):Boolean {
        	return dispatcher.dispatchEvent(evt);
    	}
    
    	public function hasEventListener(type:String):Boolean {
    		return dispatcher.hasEventListener(type);
    	}
    
    	public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
    		dispatcher.removeEventListener(type, listener, useCapture);
		}
    	
    	public function willTrigger(type:String):Boolean {
        	return dispatcher.willTrigger(type);
    	}
	}
}
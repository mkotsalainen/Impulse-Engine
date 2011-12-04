package impulse.core
{
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import impulse.display.Grid;
	import impulse.display.ImpulseSprite;
	import impulse.util.*;
	
	public class Engine implements IEventDispatcher
	{
		public var bodies:Array = new Array();
		private var numBodies:Number = 0;
		private var arbiters:Array = [];
		public var dispatcher:EventDispatcher;
		
		public var gravity:Point = new Point(0,75);
		public var broadPhaseStrategy:IBroadPhaseStrategy;
		public var fixedStepSize:Number = 0.01;
		private var fixedStepSizeInMillis:Number = fixedStepSize*1000;
		private var invFixedStepSize:Number = 1/fixedStepSize;
		private var timeAccumulator:Number = 0;
		public var runSpeed:Number = 1;
		private var iterations:Number = 10;	//the number of solver iterations we step forward the simulation by fixeStepSize
		private var invIterations:Number = 1/iterations;
		private var lastUpdate:Number;
		public var fps:Number = 0;
		public var paused:Boolean = false;
		public static var stopDebugger:Boolean = false;
		public static var instance:Engine;
		
		public function Engine(broadPhaseStrategy:IBroadPhaseStrategy)
		{
			dispatcher = new EventDispatcher();	
			instance = this;
			this.broadPhaseStrategy = broadPhaseStrategy;
			lastUpdate = getTimer();
		}
		
		public function add(body:Body):void
		{
			bodies.push(body);
			numBodies++;
		}
		
		public function startPause():void
		{
			paused = true;
		}
		
		public function endPause():void
		{
			paused = false;
			lastUpdate = getTimer();	
		}
		
		public function onEnterFrame():void
		{
			var t:Number = getTimer();
			var dt:Number = t - lastUpdate;
			
			fps = 0.75*fps + 0.25*(1000/dt);
			
			timeAccumulator += runSpeed*dt;
			
			if (paused) timeAccumulator = 0;
			
			var clearedGrid:Boolean;
			while (timeAccumulator > fixedStepSize)
			{
				/*
				if (!clearedGrid)
				{
					Grid.instance.clear();
					GJKVisualizer.draw(bodies[0], bodies[1]);
					clearedGrid = true;
				}
				*/
				stepForward();
				timeAccumulator -= fixedStepSizeInMillis;
				if (paused) break;
			}
			lastUpdate = t;
		}
			
		public function stepForward():void
		{
			var aa:Point = new Point();
			var bb:Point = new Point();
			Vec.addNoReturn(aa, bb)
			
			//collision detection
			var groups:Array = broadPhaseStrategy.findCollisionGroups(bodies);
			for each (var g:Array in groups) doNarrowPhase(g);
			
			//clear accumulators and add external forces
			var b:Body;
			for each (b in bodies)
			{
				//b.addExternalForces(Vec.mult(b.mass, gravity), 0);
				b.addExternalForces(new Point(), 0);
			}
			dispatchEvent(new Event("addForces"));
			
			for each (b in bodies) b.updateVel(fixedStepSize);
			
			//collision resolution
			var a:CollisionArbiter;
			for each (a in arbiters) a.preStep(invFixedStepSize);
			for (var i:Number = 0; i < iterations; i++)
			{
				for each (a in arbiters) a.applyImpulse(i, iterations);
			}
			
			for each (b in bodies) b.updatePos(fixedStepSize);
		}
		
		//the narrow-phase collision detection between bodies in same collision group
		//a collision is detected, a collision arbiter is created or updated for the body pair
		//otherwise, it is deleted
		//NOTE: bug to be fixed
		//if two bodies go from the same group to two different groups
		//the CollisionArbiter between them will not be removed
		private function doNarrowPhase(group:Array) : void
		{
			var numBodiesInGroup:Number = group.length;
			for (var i:Number=0; i < numBodiesInGroup; i++)
			{
				for (var j:Number=i+1; j < numBodiesInGroup; j++)
				{
					var a:CollisionArbiter = getCollisionArbiter(group[i], group[j]);
					if (!a.collide()) removeCollisionArbiter(a);
					else if (a.firstTimeInContact) notifyCollision(a);
				}
			}
		}
		
		private function notifyCollision(a:CollisionArbiter) : void
		{
			//runSpeed = 0.01;
			var e:DynamicEvent = new DynamicEvent("collision");
			e.b1 = a.b1;
			e.b2 = a.b2;
			dispatchEvent(e);
		}
		
		private function getCollisionArbiter(b1:Body, b2:Body) : CollisionArbiter
		{
			var a:CollisionArbiter = new CollisionArbiter(b1, b2);
			var i:Number = ArrayUtil.indexOf(arbiters, a);
			if (i != -1) {
				return arbiters[i];
			}
			else {
				arbiters.push(a);
				return a;
			}
		}
		
		private function removeCollisionArbiter(arbiter:CollisionArbiter):void
		{
			//runSpeed = 0.3;
			var i:Number = ArrayUtil.indexOf(arbiters, arbiter);
			ArrayUtil.remove(arbiters, i);
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
package impulse
{
	import flash.ui.Keyboard;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import impulse.core.*;
	import impulse.display.*;
	import flash.geom.Point;
	import flash.geom.Matrix;
	
	public class SpriteForcer
	{
		private var vector:Shape;
		private var keys:Dictionary;
		private var activeBody:Number = 1;
		private var holdingSpace:Boolean;
		
		public function SpriteForcer(stage:Stage)
		{
			createVector(stage);
			keys = new Dictionary();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
				
		public function keyDownHandler(e:KeyboardEvent):void
		{
			keys[e.keyCode] = true;
		}
		
		public function keyUpHandler(e:KeyboardEvent):void
		{
			keys[e.keyCode] = false;
			if (e.keyCode == Keyboard.SPACE) holdingSpace = false;
		}
		
		public function createVector(stage:Stage):void
		{
			vector = new Shape();
			stage.addChild(vector);
			var size:Number = 40;
			var g:Graphics = vector.graphics;
			g.lineStyle(5, 0x000000);
			g.lineTo(size, 0);
			g.drawCircle(size,0,2);
		}
		
		public function updateVector(angle:Number, body:Body):void
		{			
			vector.visible = true;
			var m:Matrix = new Matrix();
			m.createBox(1, 1, -angle, body.pos.x, body.pos.y);
			vector.transform.matrix = m;
		}
		
		public function addForces(e:Event):void
		{
			var body:Body = ImpulseSprite(Main.instance.sprites[activeBody]).body;
			
			var force:Number, torque:Number;
			if (keys[Keyboard.UP]) force = 1/2*Math.PI;
			else if (keys[Keyboard.DOWN]) force = 3/2*Math.PI;
			else if (keys[Keyboard.RIGHT]) force = 2*Math.PI;
			else if (keys[Keyboard.LEFT]) force = Math.PI;
			else if (keys[Keyboard.SHIFT]) torque = -5;
			else if (keys[Keyboard.ENTER]) torque = 5;
			else if (keys[Keyboard.SPACE] && !holdingSpace)
			{
				Main.instance.sprites[activeBody].body.vel = new Point();
				Main.instance.sprites[activeBody].body.angVel = 0;
				/*
				activeBody++;
				if (activeBody > Main.instance.sprites.length-1) activeBody = 0;
				Main.instance.sprites[activeBody].body.vel = new Point();
				Main.instance.sprites[activeBody].body.angVel = 0;
				*/
				holdingSpace = true;
			}
			
			
			if (force) {
				updateVector(force, body);
				body.force = body.force.add(new Point(400*Math.cos(force), -400*Math.sin(force)));
			} else if (torque) {
				updateVector(torque*1/2*Math.PI, body);
				body.torque += 500*torque;
			} else vector.visible = false;
		}
	}
}
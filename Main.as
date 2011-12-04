
package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.*;
	
	import impulse.*;
	import impulse.core.*;
	import impulse.display.*;
	import impulse.util.ArrayUtil;
	import impulse.util.DynamicEvent;

	public class Main extends Sprite
	{
		private var timer:Timer;
		private var engine:Engine;
		public var sprites:Array = new Array();
		//private var dragger:SpriteDragger;
		private var forcer:SpriteForcer;
		public var grid:Grid;
		public var visualizer:GJKVisualizer;
		private var currentTime:Number;
		private var fps:TextField;
		public var debugger:TextField;
		private const TARGET_FPS:Number = 80;
		public static var instance:Main;
		private var pauseToggled:Boolean;
		private var stepMode:Boolean = false;
		private var stepForward:Boolean = true;
		
		public function Main()
		{
			//arr.splice(0,3,66,99);
			//trace ("foo" + arr);
			//return;
			
			/*
			var simplex:Array = new Array();
			simplex.push(new Point(0,10));	//c
			simplex.push(new Point(10,0));	//b
			simplex.push(new Point(1,1));	//a
			trace(ImpulseEngine.doTriangleSimplex(simplex));
			return;
			*/
			
			grid = new Grid(this);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stage.frameRate = TARGET_FPS;
			
			engine = new Engine(new BruteForceStrategy());
			
			if (stepMode) engine.fixedStepSize = 0.05;
			
			engine.addEventListener("collision", collision);
			
			instance = this;
			forcer = new SpriteForcer(this.stage);
			engine.addEventListener("addForces", forcer.addForces);
			createBg();
			//createRectangle(80, 60, 1, 150, 100, 0xf00000);
			
			createRectangle(new Point(250, 220), 0, 400, 20, Number.MAX_VALUE, Grid.darkRed);
			//createCircle(new Point(250, 320), 80, 1, Grid.darkRed);
			createRectangle(new Point(250, 110), Math.PI/6, 200, 50, 1, 0x00f000);
			//createCircle(new Point(300, 150), 50, 1, Grid.green);
			
			/*
			engine.bodies[0].setState(273.8131170226815, 147.92547314011813, 28.75649273446034);
			engine.bodies[1].setState(250, 220.15393254420297, 0.0000027252764686383305);
			*/
			
			
			/*
			var verts:Array = new Array();
			verts.push(new Point(-60,0));
			verts.push(new Point(60,0));
			verts.push(new Point(0,60));
			createPolygon(verts, 1, 100, 200, 0x0000ff);
			*/
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);

			fps = new TextField();
			debugger = new TextField();
			debugger.x = 50;
			
			debugger.width = 300;
			addChild(fps);
			addChild(debugger);
			
			timer = new Timer(1000/TARGET_FPS);
			timer.addEventListener(TimerEvent.TIMER, step);
			currentTime = getTimer();
			timer.start();
		}
		
		public function collision(e:DynamicEvent):void
		{
			var b1:Body = e.b1;
			var b2:Body = e.b2;
			//trace("collision between " + b1.id + " and " + b2.id);		
		}
		
		public function createRectangle(pos:Point, rot:Number, width:Number, height:Number, mass:Number, color:Number):RectangleSprite
		{
			var b:RectangleBody = new RectangleBody(pos, rot, width, height, mass);
			engine.add(b);
			b.updateAABR();
			var s:RectangleSprite = new RectangleSprite(b, this, color);
			sprites.push(s);
			return s;		
		}
		
		public function createCircle(pos:Point, radius:Number, mass:Number, color:Number):CircleSprite
		{
			var b:CircleBody = new CircleBody(pos, radius, mass);
			engine.add(b);
			b.updateAABR();
			var s:CircleSprite = new CircleSprite(b, this, color);
			sprites.push(s);
			return s;	
		}
		
		public function createPolygon(pos:Point, rot:Number, verts:Array, mass:Number, x:Number, y:Number, color:Number):PolygonSprite
		{
			var b:PolygonBody = new PolygonBody(pos, rot, verts, mass);
			b.pos = new Point(x, y);
			engine.add(b);
			
			var s:PolygonSprite = new PolygonSprite(b, this, color);
			sprites.push(s);
			return s;
		}
			
		private function createBg():void
		{
			//var bg:Sprite = new Sprite();
			//graphics.beginFill(0xdddddd , 1);
			
			//graphics.drawRect(0, 0, 1900, 600);
			//graphics.endFill();
			//addChild(bg);
		}
		
		public function printStateInfo():void
		{
			for (var i:Number =	0; i < sprites.length; i++)
			{
				var b:Body = sprites[i].body;
				trace("body " + i);
				trace("pos: " + b.pos);
				trace("rot: " + b.rot);
			}
		}
		
		public function keyDownHandler(e:KeyboardEvent):void
		{	
			if (e.keyCode == 80 && !pauseToggled)	//"p"
			{
				if (engine.paused) engine.endPause();
				else engine.startPause();
				pauseToggled = true;	
			}
			
			if (e.keyCode == 70)	//"f"
			{
				stepForward = true;
			} else if (e.keyCode == 73) //"i"
			{
				printStateInfo();
			} else if (e.keyCode == Keyboard.BACKSPACE)
			{
				var b:Body = engine.bodies[1];
				b.vel = new Point(0, -50);
				Engine.stopDebugger = true;
			}
			
		}
		
		public function keyUpHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == 80) pauseToggled = false;
		}	
				
		public function step(e:TimerEvent):void
		{
			if (stepMode)
			{
				if (!stepForward) return;
				stepForward = false;
				grid.clear();
				GJKVisualizer.draw(sprites[0].body, sprites[1].body);
				for each (var s:ImpulseSprite in sprites) s.redraw();
				engine.stepForward();	
			}
			else
			{
				if (engine.paused) return;
				grid.clear();
				GJKVisualizer.draw(sprites[0].body, sprites[1].body);
				for each (var sp:ImpulseSprite in sprites) sp.redraw();
				engine.onEnterFrame();	//do physics
				fps.text = engine.fps.toPrecision(3);	//display fps
			}
		}
	}
}

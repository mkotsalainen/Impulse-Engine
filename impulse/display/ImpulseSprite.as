package impulse.display
{
	import flash.display.Sprite;
	import impulse.core.*;
	import flash.display.*;
	import flash.geom.*;
	import impulse.*;
	import flash.events.*;
	
	//MAYBE WE SHOULD SUB Shape instead
	public class ImpulseSprite extends Sprite
	{		
		public var body:Body;
		public var color:Number;
		public var g:Graphics;
		
		public function ImpulseSprite(body:Body, parent:DisplayObjectContainer, color:Number)
		{
			this.body = body;
			body.addEventListener("bodyUpdated", bodyUpdated);
			parent.addChild(this);
			this.color = color;
			g = graphics;
			cacheAsBitmap = true;
		}
		
		public function drawShape():void
		{
			if (Settings.drawCollisionMargin)
			{
				
				//graphics.beginFill(color);
				g.beginFill(0x000000, 0.3);
				drawShapeWithCM();
				g.endFill();
			
				g.beginFill(color, 1);
				drawShapeNoCM();
				g.endFill();
			}
			else
			{
				g.beginFill(color, 1);
				drawShapeWithCM();
				g.endFill();
			}
			
			drawAxes();
		}
		
		protected function drawShapeWithCM():void
		{
			drawPoly(body.verts);
		}
		
		protected function drawShapeNoCM():void
		{
			drawPoly(body.vertsNoCM);
		}
		
		public function drawPoly(verts:Array):void
		{
			g.moveTo(verts[0].x, verts[0].y);
			for (var i:Number = 0; i < verts.length; i++)
			{
				g.lineTo(verts[i].x, verts[i].y);
			}
		}
		
		public function drawAxes():void
		{
			g.lineStyle(2);
			g.moveTo(0,0);
			g.lineTo(10, 0);	//x
			g.moveTo(0,0);
			g.lineTo(0,10);		//y
		}
		
		public function drawAABR():void
		{
			var r:Rectangle = body.AABR;
			Grid.instance.g.lineStyle(1, Grid.green);
			Grid.instance.g.drawRect(r.left, r.top, r.width, r.height);
		}
		
		public function redraw():void
		{ 
			//apply body state variables to sprite
			transform.matrix = body.localToWorldSpace;
			if (Settings.drawAABR) drawAABR();
		}
		
		public function bodyUpdated(e:Event):void
		{
			throw new ArgumentError("method should be overidden");
		}
	}
}
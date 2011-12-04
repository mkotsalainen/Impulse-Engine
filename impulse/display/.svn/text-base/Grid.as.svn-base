package impulse.display
{
	import flash.display.*;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.text.*;
	import impulse.util.*;
	
	public class Grid extends Sprite
	{
		public var points:Array;
		public var g:Graphics;
		public static var instance:Grid;
		public var lineColor:Number = 0x666666;
		public var fillColor:Number = 0x000000;
		
		public var lineThickness:Number = 0.5;
		public static var ZERO_VEC:Point = new Point(0,0);
		
		public static var white:Number = 0xffffff;
		public static var black:Number = 0;
		public static var red:Number = 0xff0000;
		public static var green:Number = 0x00ff00;
		public static var blue:Number = 0x0000ff;
		public static var yellow:Number = 0xffff00;
		public static var grey:Number = 0x666666;
		public static var darkRed:Number = 0x992222;
		public static var darkGreen:Number = 0x009900;
		public static var darkBlue:Number = 0x000099;
		
		public static var origo:Point = new Point();
		public static var moveOrigo:Boolean = false;
		
		public function Grid(parent:DisplayObjectContainer)
		{
			instance = this;
			parent.addChild(this);
			g = graphics;
			g.lineStyle(2,grey);	
			//g.beginFill(0x009900,1);
		}
		
		public function drawPoint(p:Point, color:Number = 0xffffff, label:String = null, labelOffset:Point = null, radius:Number = 1):void
		{
			p = p.add(origo);
			g.moveTo(p.x,p.y);	//There seems to be a bug in flashplayer, because this is needed before drawCircle or it freaks out
			g.lineStyle(lineThickness, color);
			g.beginFill(color, radius);
			g.drawCircle(p.x, p.y, radius);
			g.endFill();
			g.lineStyle(lineThickness, lineColor);
			
			if (label)
			{
				var tf:TextField = new TextField();
				tf.selectable = false;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.text = label;
				tf.x = p.x+2;
				tf.y = p.y-2;
				if (labelOffset)
				{
					tf.x += labelOffset.x;
					tf.y += labelOffset.y;
				}
				addChild(tf);
			}
		}
		
		public function drawText(text:String, x:Number, y:Number, scale:Number = 1) : void
		{
			var tf:TextField = new TextField();
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.scaleX = scale; tf.scaleY = scale;
			tf.text = text;
			tf.x = x + origo.x;
			tf.y = y + origo.y;
			addChild(tf);

		}

		public function drawPoly(arr:Array, color:Number = 0xffffff, vertInfo:Boolean = false) : void
		{
			g.lineStyle(lineThickness, color);
			g.moveTo(arr[0].x + origo.x, arr[0].y + origo.y);
			var offset:Point = new Point(10,10);
			if (vertInfo) displayVertInfo(arr[0], offset);
			
			for (var i:Number = 1; i < arr.length; i++) {
				var p:Point = arr[i]; 
				g.lineTo(p.x + origo.x, p.y + origo.y);
				if (vertInfo) displayVertInfo(p, offset);
			}
			g.lineTo(arr[0].x + origo.x, arr[0].y + origo.y);
			g.lineStyle(lineThickness, lineColor);
		}
		
		public function displayVertInfo(v:Point, offset:Point):void
		{
			drawText(Vec.str(v,3), v.x + offset.x, v.y + offset.y + 10, .8);
		}
		
		public function drawVec(v:Point, p:Point, color:Number = 0xffffff):void
		{
			drawPoint(p, color);
			p = p.add(origo);
			g.lineStyle(lineThickness, color);
			g.moveTo(p.x, p.y);
			g.lineTo(p.x+v.x, p.y+v.y);
			g.endFill();
			g.lineStyle(lineThickness, lineColor);
		}
		
		public function clear():void
		{
			updateOrigo();
			
			parent.setChildIndex(this, parent.numChildren - 1);	
			g.clear();
			g.lineStyle(lineThickness, lineColor);	
			for (var i:Number = 0; i < numChildren; i++)
			{
				removeChildAt(i);
			}
						
			//drawPoint(new Point(stage.stageWidth/2, stage.stageHeight/2));
			//g.beginFill(0,1);
			//drawGrid();		
		}
		
		public function drawOrigo(color:Number = 0):void
		{
			drawPoint(new Point(), color);
		}
		
		private function updateOrigo():void
		{
			if (!moveOrigo) return;
			
			origo.x = Main.instance.stage.stageWidth/3;
			origo.y = Main.instance.stage.stageHeight/2;
		}
		
		private function drawGrid():void
		{	
			g.moveTo(0, 0)
			g.lineTo(stage.stageWidth, 0);
			g.moveTo(0, 0);
			g.lineTo(0, stage.stageHeight);
		}
	}
}

package
{
	import flash.geom.Point;
	import flash.display.*;
	import flash.events.*;
	import impulse.core.*;
	import impulse.util.*;
	
	public class ClosestPointTest extends Sprite
	{
		private var g:Graphics;
		
		public function ClosestPointTest()
		{	
			g = graphics;
			
			reset();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouse);
		}
		
		private function createBg():void
		{
			var bg:Sprite = new Sprite();
			graphics.beginFill(0xdddddd , 1);
			graphics.drawRect(0, 0, 1900, 600);
			graphics.endFill();
			addChild(bg);
		}
		
		private function reset():void
		{
			g.clear();
			g.lineStyle(1,0);
			g.beginFill(0);
			createBg();
		}
		
		public function doSegment(p:Point):void
		{
			var a:Point = new Point(100, 100);
			var b:Point = new Point(200, 200);
			
			g.moveTo(a.x, a.y);
			g.lineTo(b.x, b.y);
			
			g.lineStyle(2, 0xff0000);
			var cp:Point = ClosestPoint.segment(p, a, b);
			g.drawRect(cp.x-1, cp.y-1, 2, 2);
		}
		
		public function doTriangle(p:Point):void
		{
			var a:Point = new Point(300, 180);
			var b:Point = new Point(400, 200);
			var c:Point = new Point(350, 100);
			
			g.moveTo(a.x, a.y);
			g.lineStyle(1, 0x00ff00, 1);
			g.beginFill(0x00ff00, 0.5);
			g.lineTo(b.x, b.y);
			g.lineTo(c.x, c.y);
			g.endFill();
			
			g.lineStyle(2, 0xff0000);
			var cp:Point = ClosestPoint.triangle(p, a, b, c);
			g.drawRect(cp.x-1, cp.y-1, 2, 2);
		}
		
		public function doCorner(p:Point):void
		{
			var a:Point = new Point(300, 180);
			var b:Point = new Point(460, 200);
			var c:Point = new Point(350, 170);
			
			g.moveTo(a.x, a.y);
			g.lineStyle(1, 0x00ff00, 1);
			g.beginFill(0x00ff00, 0.5);
			g.lineTo(b.x, b.y);
			g.lineTo(c.x, c.y);
			g.endFill();
			
			var simplex:Array = new Array(a, b, c);
			reduceSimplexToClosestEdge(simplex, p);
			
			g.lineStyle(2, 0xff0000);
			g.moveTo(simplex[0].x, simplex[0].y);
			g.lineTo(simplex[1].x, simplex[1].y);
			
			//var cp:Point = ClosestPoint.triangle(p, a, b, c);
			//g.drawRect(cp.x-1, cp.y-1, 2, 2);
		}
		
		private static function reduceSimplexToClosestEdge(simplex:Array, origo:Point) : void
		{
			if (simplex.length != 3) return;

			var a:Point = simplex[0];
			var b:Point = simplex[1];
			var c:Point = simplex[2];	//the last added point is the corner
			
			var ca:Point = a.subtract(c);
			var cb:Point = b.subtract(c);
			var co:Point = origo.subtract(c);
			
			var da:Number = Vec.dot(co, ca) / ca.length;
			var db:Number = Vec.dot(co, cb) / cb.length;
			
			trace("" + da + ":" + db);
			if (da > db) simplex.splice(0, 3, a, c);
			else simplex.splice(0, 3, b, c);
		}
		
		public function mouse(e:MouseEvent):void
		{
			reset();
			var p:Point = new Point(e.localX, e.localY);
			doSegment(p);
			doCorner(p);
		}
	}
}
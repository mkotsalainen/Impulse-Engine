package
{
	import flash.display.*;
	import flash.ui.Mouse;
	import flash.events.*;
	import flash.geom.Point;
	import impulse.core.*;
	import impulse.display.Grid;
	import impulse.util.*;
	
	public class ConvexHullTest extends Sprite
	{
		private var g:Graphics;
		private var verts:Array;
		
		public function ConvexHullTest()
		{
			verts = new Array();
			
			var grid:Grid = new Grid(this);
			g = graphics;
			
			createBg();
			stage.addEventListener(MouseEvent.CLICK, mouse);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key);
		}
		
		private function createBg():void
		{
			var bg:Sprite = new Sprite();
			graphics.beginFill(0xdddddd , 1);
			graphics.drawRect(0, 0, 1900, 600);
			graphics.endFill();
			addChild(bg);
		}	
		
		public function key(e:KeyboardEvent):void
		{
			//trace("key");
			trace("v" + verts);
			var m:Point = new Point(50, 50);
			//verts = new Array(new Point(-m.x,m.y), new Point(0,m.y/2), new Point(m.x,m.y), new Point(m.x,-m.y), new Point(-m.x,-m.y));
			//verts = new Array(new Point(100,300), new Point(200,100), new Point(230,200), new Point(300,300))
			//(x=134, y=252),(x=175, y=109),(x=253, y=265),(x=183, y=211)
			verts = new Array(new Point(100, 300), new Point(300, 300), new Point(300, 200), new Point(200, 220), new Point(100, 200));
			
			//				*
			//*            
			//  *		*
			//     *
			//	     *
					
			//  *		*	
			verts = new Array(new Point(x=-85, y=-30),
			new Point(x=-100, y=-10),new Point(x=-115, y=-30), new Point(x=-115, y=50),
			new Point(x=-85, y=50), new Point(x=-55, y=-40), new Point(x=-70, y=-20),
			new Point(x=-85, y=-40), new Point(x=-85, y=40));
			
			//x=-85, y=-30),(x=-100, y=-10),(x=-115, y=-30),(x=-115, y=50),(x=-85, y=50),
			//(x=-55, y=-40),(x=-70, y=-20),(x=-85, y=-40),(x=-85, y=40),xxx(x=-55, y=40),
			//(x=-25, y=-30),(x=-40, y=-10),(x=-55, y=-30),(x=-55, y=50),(x=-25, y=50),
			//(x=-25, y=-70),(x=-40, y=-50),(x=-55, y=-70),(x=-55, y=10),(x=-25, y=10),
			//(x=-85, y=-70),(x=-100, y=-50),(x=-115, y=-70),(x=-115, y=10),(x=-85, y=10)
			for (var i:Number = 0; i < verts.length; i++)
			{
				verts[i] = verts[i].add(new Point(400, 200));	
			}
			//trace("hddd");
			var hull:Array = ConvexHull.create(verts);
			
			//MinkowskiCSO.drawPoly(hull, new Point(0,0));
			verts = new Array();
		}
		
		public function mouse(e:MouseEvent):void
		{
			if (verts.length == 0) {
				g.clear();
				g.lineStyle(1,0);
				g.beginFill(0);
				createBg();
			}
			
			//trace("mouse");
			g.drawCircle(e.localX, e.localY, 1);
			verts.push(new Point(e.localX, e.localY));
		}
	}
}
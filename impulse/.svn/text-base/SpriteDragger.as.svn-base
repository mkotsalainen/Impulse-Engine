package impulse
{
	import flash.events.MouseEvent;
	import flash.utils.*;
	import flash.display.*;
	import impulse.core.*;
	import impulse.display.*;
		
	public class SpriteDragger
	{
		public var activeSprite:ImpulseSprite;
		public var vector:Sprite;
		public var bodyPos:Vec;
		public var mousePos:Point = new Point(0,0);
		public const MAX_FORCE:Number = 100;
		//public var startDragWorldPos:Point;
		
		public function SpriteDragger(stage:Sprite)
		{
			Pointtor = new Sprite();
			stage.addChild(Pointtor);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);	
		}
		
		public function listen(sprite:Sprite):void
		{
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		public function mouseDownHandler(e:MouseEvent):void
		{
			activeSprite = ImpulseSprite(e.target);
			bodyPos = new Point(e.localX, e.localY);
			//startDragWorldPos = new Point(e.stageX, e.stageY);
		}
		
		public function mouseUpHandler(e:MouseEvent):void
		{
			activeSprite = null;
		}
		
		public function mouseMoveHandler(e:MouseEvent):void
		{
			mousePos = new Point(e.stageX, e.stageY);
		}
		
		private function drawPointtor(dispPoint:Point):void
		{
			Pointtor.parent.setChildIndex(Pointtor, Pointtor.parent.numChildren-1);
			
			var g:Graphics = Pointtor.graphics;
			g.clear();
			g.beginFill(0x0000ff , 1);
			g.moveTo(0,0);	//do we need this?
			g.lineStyle(2);
			g.lineTo(dispPoint.x, dispPoint.y);
			g.endFill();
		}
		
		public function step():void
		{
			if (!activeSprite) {
				Pointtor.graphics.clear();
				return;
			}
			
			var worldPos:Point = activeSprite.transform.matrix.transformPoint(bodyPos);
			
			Pointtor.x = worldPos.x;
			Pointtor.y = worldPos.y;
			
			var dispPoint:Point = mousePos.subtract(worldPos);
						
			drawPointtor(dispPoint);
			
			//len 0 - 300
			//var force:Number = MAX_FORCE * Math.min(1, dispPoint.length/100);
			
			//trace("force:"+force);
			dispPoint.normalize(MAX_FORCE);
			
			//activeSprite.body.addForce(dispPoint, bodyPos);			
		}
	}
}
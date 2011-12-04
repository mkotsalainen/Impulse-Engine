package impulse.core
{
	import flash.geom.*;
	
	public class Util
	{
		//we should probably make an updateAABR as well
		
		public static function calculateAABR(verts:Array):Rectangle
		{		
			var AABR:Rectangle = new Rectangle();
			AABR.left = verts[0].x;
			AABR.top = verts[0].y;
			for (var i:Number = 0; i < verts.length; i++)
			{
				var p:Point = verts[i];
				if (p.x < AABR.left) AABR.left = p.x;
				else if (p.x > AABR.right) AABR.right = p.x;
				
				if (p.y > AABR.bottom) AABR.bottom = p.y;
				else if (p.y < AABR.top) AABR.top = p.y;
			}
			AABR.left -= Body.AABRMargin;
			AABR.top -= Body.AABRMargin;
			AABR.width += Body.AABRMargin;
			AABR.height += Body.AABRMargin;
			
			return AABR;
		}
	}
}
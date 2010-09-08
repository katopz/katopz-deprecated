package com.sleepydesign.display
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class DrawUtil
	{
		public static function drawRect(rect:Rectangle, color:int = 0x000000, alpha:Number = 1.0, lineColor:int = -1):Sprite
		{
			var containter:Sprite = new Sprite();
			
			if (lineColor != -1)
				containter.graphics.lineStyle(1, lineColor);
			else
				containter.graphics.lineStyle();

			containter.graphics.beginFill(color, alpha);
			containter.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			containter.graphics.endFill();
			return containter;
		}
	}
}
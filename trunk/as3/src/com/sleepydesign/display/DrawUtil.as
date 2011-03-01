package com.sleepydesign.display
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class DrawUtil
	{
		public static function drawRect(rect:Rectangle, color:int = 0x000000, alpha:Number = 1.0, lineColor:int = -1):Sprite
		{
			var containter:Sprite = new Sprite();
			drawRectTo(containter.graphics, rect, color, alpha, lineColor);

			return containter;
		}

		public static function drawRectTo(graphics:Graphics, rect:Rectangle, color:int = 0x000000, alpha:Number = 1.0, lineColor:int = -1):void
		{
			if (lineColor != -1)
				graphics.lineStyle(1, lineColor);
			else
				graphics.lineStyle();

			graphics.beginFill(color, alpha);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			graphics.endFill();
		}
	}
}
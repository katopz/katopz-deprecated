package com.sleepydesign.utils
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class DrawUtil
	{
		public static function drawBitmapRect(rect:Rectangle, bitmapData:BitmapData):Sprite
		{
			var containter:Sprite = new Sprite();
			drawBitmapRectTo(containter.graphics, rect, bitmapData);
			
			return containter;
		}
		
		public static function drawBitmapRectTo(graphics:Graphics, rect:Rectangle, bitmapData:BitmapData):void
		{
			graphics.lineStyle();
			graphics.beginBitmapFill(bitmapData);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			graphics.endFill();
		}
		
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

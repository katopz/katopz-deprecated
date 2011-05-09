package com.sleepydesign.display
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class DrawUtil
	{
		public static function drawGrid(col:Number = 4, row:Number = 4, colSpan:int = 100, rowSpan:int = 100, lineColor:uint = 0x000000, thickness:Number = 0.25, bgColor:uint = 0xFFFFFF, bgAlpha:int = 0):Sprite
		{
			var canvas:Sprite = new Sprite();
			canvas.graphics.beginFill(bgColor, bgAlpha);
			canvas.graphics.lineStyle(thickness, lineColor);

			//col
			var currentX:Number = 0;

			for (var i:int = 0; i <= col; i++)
			{
				canvas.graphics.moveTo(currentX, 0);
				canvas.graphics.lineTo(currentX, row * rowSpan);

				currentX += colSpan;
			}

			//row
			var currentY:Number = 0;

			for (var j:int = 0; j <= row; j++)
			{
				canvas.graphics.moveTo(0, currentY);
				canvas.graphics.lineTo(colSpan*col, currentY);
				currentY += rowSpan;
			}

			canvas.graphics.drawRect(0, 0, canvas.width, canvas.height);

			canvas.graphics.endFill();

			return canvas;
		}

		public static function drawRect(rect:Rectangle, color:int = 0x000000, alpha:Number = 1.0, lineColor:int = -1):Sprite
		{
			var canvas:Sprite = new Sprite();
			drawRectTo(canvas.graphics, rect, color, alpha, lineColor);

			return canvas;
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
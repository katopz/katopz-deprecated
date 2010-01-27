package com.sleepydesign.display
{
	import flash.display.Sprite;

	public class DrawUtil
	{
		public static function drawRect(width:Number = 100, height:Number = 100, color:int = 0x000000, alpha:Number = 1.0, lineColor:int = -1):Sprite
		{
			var containter:Sprite = new Sprite();
			if(lineColor!=-1)
				containter.graphics.lineStyle(1, lineColor);
			else
				containter.graphics.lineStyle();
				
			containter.graphics.beginFill(color, alpha);
			containter.graphics.drawRect(0,0, width, height);
			containter.graphics.endFill();
			return containter;
		}
	}
}
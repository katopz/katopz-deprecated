package com.sleepydesign.display
{
	import flash.display.Sprite;

	public class DrawTool
	{
		public static function drawRect(width:Number = 100, height:Number = 100, color:uint = 0x000000, alpha:Number = 1.0):Sprite
		{
			var containter:Sprite = new Sprite();
			containter.graphics.beginFill(color, alpha);
			containter.graphics.drawRect(0,0, width, height);
			containter.graphics.endFill();
			return containter;
		}
	}
}
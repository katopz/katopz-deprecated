package com.sleepydesign.graphics.tools
{
	import flash.display.Sprite;

	public class Anchor extends Sprite
	{
		public function Anchor(id:String="", size:int = 6, fillColor:Number = 0xFFFF00):void
		{
			name = "anchor_" + id;
			
			graphics.lineStyle(0.5, 0x000000);
			graphics.moveTo(size, -size);
			graphics.beginFill(fillColor, 0.5);
			graphics.lineTo(size, size);
			graphics.lineTo(-size, size);
			graphics.lineTo(-size, -size);
			graphics.lineTo(size, -size);
			graphics.endFill();
		}
	}
}
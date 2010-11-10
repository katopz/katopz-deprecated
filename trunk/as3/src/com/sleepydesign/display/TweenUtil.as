package com.sleepydesign.display
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class TweenUtil
	{
		public static function getTweenList(clip:DisplayObjectContainer):Array
		{
			var list:Array = [];
			var numChildren:int = clip.numChildren;
			for (var i:int = 0; i < numChildren; i++)
			{
				var sprite:Sprite = clip.getChildAt(i) as Sprite;
				if (sprite)
					list[i] = {x: sprite.x, y: sprite.y, scaleX: sprite.scaleX, scaleY: sprite.scaleY, alpha: sprite.alpha};
			}
			return list;
		}
	}
}
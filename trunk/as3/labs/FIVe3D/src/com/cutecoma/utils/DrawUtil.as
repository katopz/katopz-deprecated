package com.cutecoma.utils
{
	import flash.display.Sprite;

	public class DrawUtil
	{
		public static function drawRect(width:Number = 100, height:Number = 100, color:uint = 0x000000, alpha:Number = 1.0):Sprite
		{
			var _sprite:Sprite = new Sprite();
			_sprite.graphics.beginFill(color, alpha);
			_sprite.graphics.drawRect(0,0, width, height);
			_sprite.graphics.endFill();
			
			return _sprite;
		}
	}
}
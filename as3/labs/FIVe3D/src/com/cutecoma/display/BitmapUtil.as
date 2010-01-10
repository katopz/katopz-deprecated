package com.cutecoma.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class BitmapUtil
	{
		public static function drawRect(width:Number = 100, height:Number = 100, color:uint = 0x000000, alpha:Number = 1.0):Bitmap
		{
			return new Bitmap(new BitmapData(width, height, alpha<1.0, color));
		}
		
		public static function getARGB(color:uint):Object
		{
			var c : Object = {};
			c.a = color >> 24 & 0xFF;
			c.r = color >> 16 & 0xFF;
			c.g = color >> 8 & 0xFF;
			c.b = color & 0xFF;
			return c;
		}
	}
}
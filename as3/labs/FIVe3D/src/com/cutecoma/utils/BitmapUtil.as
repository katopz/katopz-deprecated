package com.cutecoma.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class BitmapUtil
	{
		public static function drawRect(width:Number = 100, height:Number = 100, color:uint = 0x000000, alpha:Number = 1.0):Bitmap
		{
			return new Bitmap(new BitmapData(width, height, alpha<1.0, color));
		}
	}
}
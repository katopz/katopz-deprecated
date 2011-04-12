package com.sleepydesign.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapUtil
	{
		public static function drawRect(width:Number = 100, height:Number = 100, color:uint = 0x000000, alpha:Number = 1.0):Bitmap
		{
			return new Bitmap(new BitmapData(width, height, alpha < 1.0, color));
		}

		public static function getARGB(color:uint):Object
		{
			var c:Object = {};
			c.a = color >> 24 & 0xFF;
			c.r = color >> 16 & 0xFF;
			c.g = color >> 8 & 0xFF;
			c.b = color & 0xFF;
			return c;
		}

		public static function getBitmap(asset:DisplayObject, isTranslate:Boolean = true, rectangle:Rectangle = null):Bitmap
		{
			if (!asset)
				throw new Error("Required asset!");

			var bitmap:Bitmap;
			if (!(asset is Bitmap))
				bitmap = new Bitmap(getBitmapData(asset, isTranslate, rectangle));
			else
				bitmap = new Bitmap(Bitmap(asset).bitmapData);

			bitmap.transform.matrix = asset.transform.matrix;
			return bitmap;
		}

		public static function getBitmapData(asset:DisplayObject, isTranslate:Boolean = true, rectangle:Rectangle = null):BitmapData
		{
			if (!asset)
				throw new Error("Required asset!");

			if (asset.width != 0 || asset.height != 0)
			{
				if (!rectangle)
					rectangle = asset.getBounds(asset);

				var bitmapData:BitmapData;

				var matrix:Matrix = new Matrix();

				if (isTranslate)
				{
					bitmapData = new BitmapData(rectangle.width, rectangle.height, true, 0x00000000);
					matrix.translate(-rectangle.x, -rectangle.y);
				}
				else
				{
					bitmapData = new BitmapData(rectangle.x + rectangle.width, rectangle.y + rectangle.height, true, 0x00000000);
						//bitmapData = new BitmapData(rectangle.width, rectangle.height, true, 0x00000000);
				}

				bitmapData.draw(asset, matrix, asset.transform.colorTransform); //, null, rectangle, true);

				return bitmapData;
			}
			else
			{
				return null;
			}
		}

		public static function replaceColor(bitmapData:BitmapData, color:uint, replaceColor:uint):void
		{
			bitmapData.threshold(bitmapData, bitmapData.rect, new Point(0, 0), "==", color, replaceColor, 0xFFFFFFFF, false);
		}

		public static function removeColor(bitmapData:BitmapData, color:uint, glowColor:uint):void
		{
			bitmapData.threshold(bitmapData, new Rectangle(0, 0, bitmapData.width, bitmapData.height), new Point(0, 0), "==", color, 0x00000000, 0xFFFFFFFF, false);
			
			if (glowColor > 0)
				bitmapData.applyFilter(bitmapData, bitmapData.rect, new Point(), new GlowFilter(glowColor, 300, 6, 6, 1.8, 3, true, false));
		}
	}
}
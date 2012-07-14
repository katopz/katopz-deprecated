package com.sleepydesign.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class BitmapUtil
	{
		public static function getBitmapRect(width:Number = 100, height:Number = 100, color:uint = 0x000000, alpha:Number = 1.0):Bitmap
		{
			return new Bitmap(new BitmapData(width, height, alpha < 1.0, color));
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

				rectangle.width = rectangle.width ? rectangle.width : asset.width;
				rectangle.height = rectangle.height ? rectangle.height : asset.height;

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

		// sizing --------------------------------------------------------------------------------------------

		public static function resizeBitmap(bitmapData:BitmapData, width:Number, height:Number):Bitmap
		{
			return (new Bitmap(resizeBitmapData(bitmapData, width, height)));
		}

		public static function resizeBitmapData(bitmapData:BitmapData, width:Number, height:Number):BitmapData
		{
			const resizedBitmapData:BitmapData = new BitmapData(width, height);
			var ratio:Number = (width / bitmapData.width);

			var top:Number = 0;
			var left:Number = 0;

			if (bitmapData.width < bitmapData.height)
			{
				ratio = (width / bitmapData.width);
				top = (bitmapData.height * ratio);
				top = ((top - height) - (top * 0.5));
			}
			else
			{
				if (bitmapData.width > bitmapData.height)
				{
					ratio = (height / bitmapData.height);
					left = (bitmapData.width * ratio);
					left = ((left - width) - (left * 0.5));
				}
			}

			const resizedMatrix:Matrix = new Matrix(ratio, 0, 0, ratio, left, top);
			resizedBitmapData.draw(bitmapData, resizedMatrix);

			return (resizedBitmapData);
		}

		public static function scaleBitmapData(bitmapData:BitmapData, scale:Number):BitmapData
		{
			if (scale == 1)
			{
				return bitmapData;
			}
			else
			{
				const resizedBitmapData:BitmapData = new BitmapData(bitmapData.width * scale, bitmapData.height * scale, true, 0x00000000);
				var resizedMatrix:Matrix = new Matrix(scale, 0, 0, scale, 0, 0);
				resizedBitmapData.draw(bitmapData, resizedMatrix, null, null, null, true);
				resizedMatrix = null;

				return resizedBitmapData;
			}
		}

		public static function scaleBitmap(bitmapData:BitmapData, scale:Number):Bitmap
		{
			return new Bitmap(scaleBitmapData(bitmapData, scale));
		}
	}
}

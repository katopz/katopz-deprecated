package com.cutecoma.image.editors
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class GraphicUtil
	{
		public static function getBitmap(asset:DisplayObject, isTranslate:Boolean = true):Bitmap
		{
			if(!asset)
				throw new Error("Required asset!");
				
			var bitmap:Bitmap;
			if (!(asset is Bitmap))
			{
				bitmap = new Bitmap(getBitmapData(asset, isTranslate));
			}
			else
			{
				bitmap = new Bitmap(Bitmap(asset).bitmapData);
			}

			bitmap.transform.matrix = asset.transform.matrix;
			return bitmap;
		}

		public static function getBitmapData(asset:DisplayObject, isTranslate:Boolean = true, rectangle:Rectangle = null):BitmapData
		{
			if(!asset)
				throw new Error("Required asset!");
			
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
			}

			bitmapData.draw(asset, matrix, asset.transform.colorTransform, null, null, true);

			return bitmapData;
		}
	}
}

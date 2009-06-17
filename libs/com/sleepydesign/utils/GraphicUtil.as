/**
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.utils {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class GraphicUtil 
	{
		public static function getBitmap( asset:DisplayObject, isTranslate:Boolean=true, scrollRect:Rectangle=null) : Bitmap
		{
			var bitmap:Bitmap;
			if(!(asset is Bitmap))
			{
				bitmap = new Bitmap(getBitmapData(asset, isTranslate, scrollRect));
				
			}else{
				bitmap = new Bitmap(Bitmap(asset).bitmapData);
			}
			
			bitmap.transform.matrix = asset.transform.matrix;
			return bitmap;
		}
		
		public static function getBitmapData( asset:DisplayObject, isTranslate:Boolean=true, scrollRect:Rectangle=null) : BitmapData
		{
			if(asset.width+asset.height>0)
			{
				var rectangle:Rectangle  = scrollRect?scrollRect:asset.getBounds(asset);
				var bitmapData:BitmapData;
				
				var matrix:Matrix = new Matrix();
				
				if(isTranslate)
				{
					bitmapData = new BitmapData(rectangle.width, rectangle.height, true, 0x00000000);
					matrix.translate( -rectangle.x, -rectangle.y);
				}else{
					bitmapData = new BitmapData(rectangle.x+rectangle.width+10, rectangle.y+rectangle.height+10, true, 0x00000000);
				}
				
				bitmapData.draw(asset, matrix, asset.transform.colorTransform);
				
				return bitmapData;
			}else {
				return null;
			}
		}
	}
}

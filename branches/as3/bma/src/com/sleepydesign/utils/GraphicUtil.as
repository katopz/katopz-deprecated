/**
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.utils {
	
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class GraphicUtil {

		public static function createRect(iTarget:Sprite,iParent:*=null){
			var rect = iTarget.getRect(iTarget.parent);
			//trace(rect)
			var square:Sprite = new Sprite();
			square.graphics.beginFill(0x000000);
			square.graphics.drawRect(0, 0, rect.width, rect.height);
			if(!iParent){
				iTarget.addChild(square);
			}else{
				iParent.addChild(square);
			}
			
			return square;
		}
		
		public static function getBitmapData( asset:DisplayObject ,isTranslate:Boolean=true) : BitmapData
		{
			if(asset.width+asset.height>0){
				var bitmapData = new BitmapData(asset.width, asset.height, true, 0x00000000);
				
				var bounds:Rectangle  = asset.getBounds(asset);
				var mtx:Matrix = new Matrix();
				
				//mtx.scale( .5, .5 );
				//trace(-bounds.x, -bounds.y);
				if(isTranslate){
					mtx.translate( -bounds.x, -bounds.y);
				}
				//mtx = asset.transform.matrix
				bitmapData.draw(asset, mtx, asset.transform.colorTransform);
				
				return bitmapData;
			}else {
				return null;
			}
		}
	}
	
}

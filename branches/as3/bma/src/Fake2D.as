/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;

	public class Fake2D extends Sprite{
		
			public function Fake2D(iFlood,iDepth:Number=20,iScale:Number=0.5){
			
			var colorTrans:ColorTransform = new ColorTransform();

			var w = iFlood.width;
			var h = iFlood.height;

			iFlood.visible =false

			var percent;
			var bmp_data = new BitmapData(w, h, true, 0x00000000);
			bmp_data.draw(iFlood,iFlood.transform.matrix);
			var multiply = 0.65
			var factor = 0.5
			var gap = 1
			
			for (var i = 0; i<iDepth; i++) {
				
				percent = i/(iDepth-1);
				var bmp = new Bitmap(bmp_data);
				addChild(bmp);
				//bmp.scaleX = percent*factor+(1-factor)
				
				bmp.scaleX = percent*iScale+(1-iScale)
				
				bmp.x = (w-bmp.width)/2
				bmp.y = i*gap-iDepth//i*1-iDepth*3+40;
				colorTrans.redMultiplier = percent/2+multiply;
				colorTrans.greenMultiplier = percent/2+multiply;
				colorTrans.blueMultiplier = percent/2+multiply;
				new Transform(bmp).colorTransform = colorTrans;
				
			}
			
		}	
	}
	
}
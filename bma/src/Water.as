/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package {

	import flash.geom.*
	import flash.display.*

	public class Water extends Sprite{
		
		public function Water(iRect:Rectangle=null,alpha:Number=0.1,iRotation:Number=180){
			
			if(iRect){
				var fillType:String = GradientType.LINEAR;
				var colors:Array = [0x0033FF, 0x0099FF];
				var alphas:Array = [0, alpha];
				var ratios:Array = [0x00, 0xFF];
				var matr:Matrix = new Matrix();
				matr.rotate(iRotation)
				var spreadMethod:String = SpreadMethod.PAD;

				graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
				graphics.drawRect(iRect.x,iRect.y,iRect.width,iRect.height);
				graphics.lineStyle(0.5,0x0099FF,0.5)
				graphics.lineTo(iRect.x,iRect.y)
				graphics.lineTo(iRect.x+iRect.width,iRect.y)
			}
		}
		
	}

}
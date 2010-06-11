package away3dlite.sprites.utils
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;

	public class BitmapUtil
	{
		/**
		 * Create Sequence BitmapData from movieClip frame
		 * 
		 * @param movieClip
		 * @param width
		 * @param height
		 * @return Sequence BitmapData
		 * 
		 */
		public static function getSequenceBitmapData(movieClip:MovieClip, width:Number, height:Number):BitmapData
		{
			var _totalFrames:int = movieClip.totalFrames;
			var _bitmapData:BitmapData = new BitmapData(width * _totalFrames, height, true, 0x00000000);
			
			for (var i:int = 0; i < _totalFrames; i++)
			{
				movieClip.gotoAndStop(i + 1);
				_bitmapData.draw(movieClip, new Matrix(1, 0, 0, 1, (i * width), 0));
			}
			
			return _bitmapData;
		}
	}
}
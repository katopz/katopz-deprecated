package net.badimon.five3D.materials
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ClipMaterial
	{
		private var _currentFrame:uint = 1;
		private var _totalFrames:uint;
		
		public var bitmapData:BitmapData;
		public var rect:Rectangle;
		
		public function ClipMaterial(movieClip:MovieClip)
		{
			_totalFrames = movieClip.totalFrames;
			var _width:Number = movieClip.width;
			var _height:Number = movieClip.height;
			rect = new Rectangle(0, 0, _width, _height);
			
			bitmapData = new BitmapData(_width * _totalFrames, _height, true, 0x00FF0000);
			
			for (var i:int = 0; i < _totalFrames; i++)
			{
				movieClip.gotoAndStop(i + 1);
				bitmapData.draw(movieClip, new Matrix(1, 0, 0, 1, i * _width + _width / 2, _height / 2));
			}
		}
		
		public function set currentFrame(value:int):void
		{
			// play frame
			if (++_currentFrame >= _totalFrames)
				_currentFrame = 1;
			
			// seek
			rect.x = _currentFrame * rect.width;
		}
	}
}
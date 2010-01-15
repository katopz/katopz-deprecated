package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.badimon.five3D.display.Sprite2D;
	import net.badimon.five3D.display.Sprite3D;
	import net.badimon.five3D.templates.Five3DTemplate;

	[SWF(width="1132", height="654", frameRate="30", backgroundColor="#000000")]
	public class TestMovieClip extends Five3DTemplate
	{
		[Embed(source="assets/ThaiMap.swf", symbol="LightClip")]
		private var LightClip:Class;
		private var _lightClip:MovieClip = new LightClip as MovieClip;

		private var _candles:Array;
		private var _texture:BitmapData;

		private var _totalFrames:int;
		private var _bitmapData:BitmapData;
		private var _bitmap:Bitmap;
		private var _rect:Rectangle = new Rectangle(0, 0, 20, 20);
		private var _point:Point = new Point();
		
		private var _canvas3D:Sprite3D;
		
		override protected function onInit():void
		{
			_canvas3D = new Sprite3D();
			_scene.addChild(_canvas3D);
			_canvas3D.singleSided = true;
			_canvas3D.mouseEnabled = false;
			_canvas3D.x = -50;
			_canvas3D.y = 0;
			_canvas3D.z = 830;
			_canvas3D.rotationX = -60;
			
			// create candles
			var w:int = 20;
			var h:int = 20;
			_candles = [];

			var _candle:Candle;
			for (var i:int = 0; i < 10; i++)
			{
				_candles[i] = _candle = new Candle(String(i), Math.random() * 1132, Math.random() * 654);
				_candle.currentFrame = Math.random() * _lightClip.totalFrames;
				_candle.totalFrames = _lightClip.totalFrames;
				_candle.sprite2D = new Sprite2D();
				_candle.sprite2D.graphics.beginFill(0xFF0000);
				_candle.sprite2D.graphics.drawRect(0,0,20,20);
				_candle.sprite2D.graphics.endFill();
				
				_candle.sprite2D.x = _candle.x;
				_candle.sprite2D.y = _candle.y;
				
				_canvas3D.addChild(_candle.sprite2D);
			}

			// create canvas
			_bitmapData = new BitmapData(1132, 654, true, 0x00000000);
			_bitmap = new Bitmap(_bitmapData);
			_bitmap.blendMode = BlendMode.ADD;
			
			addChild(_bitmap);

			// create texture
			var _cilp_width:Number = _lightClip.width;
			var _cilp_height:Number = _lightClip.height;
			_texture = new BitmapData(_cilp_width * _lightClip.totalFrames, _cilp_height, true, 0x00FF0000);
			//_textures = [];
			_totalFrames = _lightClip.totalFrames;
			for (i = 0; i < _totalFrames; i++)
			{
				_lightClip.gotoAndStop(i + 1);
				_texture.draw(_lightClip, new Matrix(1, 0, 0, 1, i * _cilp_width + _cilp_width / 2, _cilp_height / 2));
			}
			
			// debug
			addChild(new Bitmap(_texture));
		}
		
		override protected function onPreRender():void
		{
			_canvas3D.rotationZ++;
			
			_bitmapData.fillRect(_bitmapData.rect, 0x00000000);
			
			_bitmapData.lock();
			for each(var _candle:Candle in _candles)
			{
				if (++_candle.currentFrame >= _candle.totalFrames)
					_candle.currentFrame = 1;

				_rect.x = _candle.currentFrame * _rect.width;

				_point.x = _candle.sprite2D.x;
				_point.y = _candle.sprite2D.y;
				
				_bitmapData.copyPixels(_texture, _rect, _point, null, null, true);
			}
			_bitmapData.unlock();
		}
	}
}
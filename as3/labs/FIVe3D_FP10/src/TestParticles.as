package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.badimon.five3D.display.Clip2D;
	import net.badimon.five3D.display.Particles3D;
	import net.badimon.five3D.display.Sprite3D;
	import net.badimon.five3D.materials.ClipMaterial;
	import net.badimon.five3D.templates.Five3DTemplate;

	[SWF(width="1132", height="654", frameRate="30", backgroundColor="#000000")]
	public class TestParticles extends Five3DTemplate
	{
		[Embed(source="assets/ThaiMap.swf", symbol="LightClip")]
		private var LightClip:Class;
		private var _lightClip:MovieClip = new LightClip as MovieClip;

		private var _candles:Array;
		private var _texture:BitmapData;

		private var _totalFrames:int;
		private var _bitmapData:BitmapData;
		private var _bitmap:Bitmap;
		private var _rect:Rectangle = new Rectangle(0, 0, 10, 10);
		private var _point:Point = new Point();
		
		private var _canvas3D:Sprite3D;
		
		// effect
		private var _effectBitmap:Bitmap;
		private var _effectBitmapData:BitmapData;
		private var _blurFilter:BlurFilter = new BlurFilter(4, 4, 1);
		private var _colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0.9, 0]);

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
			
			// create canvas
			_bitmapData = new BitmapData(1132, 654, true, 0x00000000);
			_bitmap = new Bitmap(_bitmapData);
			_bitmap.blendMode = BlendMode.ADD;
			
			_effectBitmapData = _bitmapData.clone();
			_effectBitmap = new Bitmap(_effectBitmapData, PixelSnapping.AUTO, false);
			_effectBitmap.blendMode = BlendMode.ADD;
			addChild(_effectBitmap);
			
			addChild(_bitmap);
			
			_particles = new Particles3D(_canvas3D, _bitmapData);
			
			var _clipMaterial:ClipMaterial = new ClipMaterial(_lightClip);
			for (var i:int = 0; i < 1000; i++)
			{
				_particles.addParticle(new Clip2D(
					Math.random() * 1132/2-Math.random() * 1132/2, Math.random() * 654/2-Math.random() * 654/2, 0, 
					_clipMaterial,
					10, 10
				));
			}
				
			// debug
			addChild(new Bitmap(_texture));
		}
		private var _particles:Particles3D
		private var _point0:Point = new Point();
		override protected function onPreRender():void
		{
			_canvas3D.rotationZ++;
			_particles.render(_scene);
			
			/*
			_bitmapData.fillRect(_bitmapData.rect, 0x00000000);
			
			_bitmapData.lock();
			
			var _bmpRectangle:Rectangle = _bitmapData.rect;
			
			for each(var _candle:Candle in _candles)
			{
				// play frame
				if (++_candle.currentFrame >= _candle.totalFrames)
					_candle.currentFrame = 1;
				_rect.x = _candle.currentFrame * _rect.width;

				_candle.particle2D.render(_scene);
				
				// position
				_point.x = _stageWidth_2+_candle.particle2D.screenX;
				_point.y = _stageHeight_2+_candle.particle2D.screenY;
				
				// draw
				_bitmapData.copyPixels(_texture, _rect, _point, null, null, true);
			}
			_bitmapData.unlock();
			*/
			// effect
			/*
			_effectBitmapData.lock();
			_effectBitmapData.copyPixels(_bitmapData, _bmpRectangle, _point0, null, null, true);
			_effectBitmapData.applyFilter(_effectBitmapData, _bmpRectangle, _point0, _blurFilter);
			_effectBitmapData.applyFilter(_effectBitmapData, _bmpRectangle, _point0, _colorMatrixFilter);
			_effectBitmapData.unlock();
			*/
		}
	}
}
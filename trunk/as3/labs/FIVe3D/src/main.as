package
{
	import com.cutecoma.events.CCMouseEvent;
	import com.cutecoma.templates.Template;
	import com.cutecoma.ui.CCMouse;
	import com.cutecoma.utils.DrawUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;

	import net.badimon.five3D.display.Bitmap3D;
	import net.badimon.five3D.display.Sprite3D;

	/*
	   TODO:
	   /1. create fake dot data array (1000 x 1000 = 1,000,000)
	   /2. read data and write to map as set pixel (10,000-100,000)
	   /3. add view controller move/pan/rotate
	   4. add click to view msg (getPixel)
	   5. create candle with perlin noise flame (BitmapSprite Clip?)
	   6. add button and move to prefer angle view for place candle
	   7. add dialog to get user input (name, msg)
	   8. send data to server (time, x, y, name, msg)
	   9. add blur/glow effect
	   10. add LOD setpixel <-> copypixel
	 */
	[SWF(width="640",height="480",frameRate="30",backgroundColor="#000000")]
	public class main extends Template
	{
		// const
		private const SCREEN_WIDTH:int = 640;
		private const SCREEN_HEIGHT:int = 480;
		
		private const _matrix:Matrix = new Matrix(1, 0, 0, 1, SCREEN_WIDTH * .5, SCREEN_HEIGHT * .5);
		private const _point:Point = new Point(0, 0);

		// assets
		[Embed(source="assets/ThaiMap.swf",symbol="ThaiMap")]
		private var ThaiMapSWF:Class;

		// data
		private var candles:Array;

		// canvas
		private var _canvas3D:Sprite3D;
		private var _candleBitmap3D:Bitmap3D
		
		// effect
		private var _effectLayer:Sprite;
		private var _effectBitmapData:BitmapData;

		// status
		private var _transformDirty:Boolean = false;

		override protected function onInit():void
		{
			setupData();
			setupCanvas();
			setupView();
			setupUI();
			start();
		}

		private function setupData():void
		{
			//fake data
			candles = [];

			var totalPoint:int = 100000;
			for (var i:int = 0; i < totalPoint; i++)
			{
				var _candle:Candle = new Candle(String(i), int(1000 * Math.random()), int(1000 * Math.random()));
				candles[i] = _candle;
			}
		}

		private function setupCanvas():void
		{
			_canvas3D = new Sprite3D();
			_canvas3D.mouseEnabled = false;

			// map
			var _mapSprite:Sprite = new ThaiMapSWF() as Sprite;
			var _mapBitmapData:BitmapData = new BitmapData(_mapSprite.width, _mapSprite.height, true, 0x000000);
			_mapBitmapData.draw(_mapSprite);

			var _mapBitmap3D:Bitmap3D = new Bitmap3D(_mapBitmapData);
			_mapBitmap3D.x = -_mapBitmapData.width / 2;
			_mapBitmap3D.y = -_mapBitmapData.height / 2;
			//_canvas3D.addChild(_mapBitmap3D);

			// candles
			var _candlesBitmapData:BitmapData = new BitmapData(_mapSprite.width, _mapSprite.height, true, 0x00000000);

			// data -> BitmapData
			var i:int = candles.length;
			var _candle:Candle;
			_candlesBitmapData.lock();
			while (i--)
			{
				_candle = Candle(candles[i]);
				if (_mapBitmapData.getPixel32(_candle.x, _candle.y) > 0)
					_candlesBitmapData.setPixel32(_candle.x, _candle.y, 0xFFFFFFFF * Math.random() / 2 + 0xFFFFFFFF / 2);
			}
			_candlesBitmapData.unlock();

			// bitmap -> _canvas3D
			_candleBitmap3D = new Bitmap3D(_candlesBitmapData);
			_candleBitmap3D.x = -_candleBitmap3D.bitmapData.width / 2;
			_candleBitmap3D.y = -_candleBitmap3D.bitmapData.height / 2;

			_canvas3D.addChild(_candleBitmap3D);
			_scene.addChild(_canvas3D);
		}

		private function setupView():void
		{
			// angle
			_canvas3D.rotationX = -60;
			_canvas3D.rotationY = 0;
			_canvas3D.rotationZ = 0;
		}

		private function setupUI():void
		{
			// add hitArea
			var _hitArea:Sprite = DrawUtil.drawRect(SCREEN_WIDTH, SCREEN_HEIGHT, 0x000000);
			_hitArea.blendMode = BlendMode.ERASE;
			addChild(_hitArea);

			var _ccMouse:CCMouse = new CCMouse(_hitArea);
			_ccMouse.addEventListener(CCMouseEvent.MOUSE_DRAG, onDrag);
			_ccMouse.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		}

		override protected function setupLayer():void
		{
			_effectBitmapData = new BitmapData(SCREEN_WIDTH, SCREEN_HEIGHT, false, 0x000000);
			var _effectBitmap:Bitmap = new Bitmap(_effectBitmapData, PixelSnapping.NEVER, false);
			addChild(_effectBitmap);
		}

		private function onDrag(event:CCMouseEvent):void
		{
			_canvas3D.x += event.data.dx;
			_canvas3D.z += event.data.dy * Math.sin(90 - _canvas3D.rotationX);
			_canvas3D.y += event.data.dy;

			_transformDirty = true;
		}

		private function onWheel(event:MouseEvent):void
		{
			_canvas3D.y += 5 * event.delta * Math.sin(60);
			_canvas3D.z += 5 * event.delta * Math.cos(60);
		}

		override protected function onPreRender():void
		{
			var _x:int = int(_candleBitmap3D.mouseX);
			var _y:int = int(_candleBitmap3D.mouseY);

			// point
			title = _x + "," + _y;

			// a/
			title += " | " + (_candleBitmap3D.bitmapData.getPixel32(_x, _y) <= 0x000000);
		}

		override protected function onPostRender():void
		{
			if (_transformDirty)
			{
				_effectBitmapData.lock();
				_effectBitmapData.draw(_canvas3D, _matrix);
				_effectBitmapData.applyFilter(_effectBitmapData, _effectBitmapData.rect, _point, new BlurFilter(4, 4, 1));
				_effectBitmapData.applyFilter(_effectBitmapData, _effectBitmapData.rect, _point, new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0.8, 0]));
				_effectBitmapData.unlock();
			}
		}
	}
}
package
{
	import com.cutecoma.events.CCMouseEvent;
	import com.cutecoma.ui.CCMouse;
	import com.cutecoma.utils.DrawUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
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
	   3. add view controller move/pan/rotate
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
		[Embed(source="assets/ThaiMap.swf", symbol="ThaiMap")]
		private var ThaiMapSWF:Class;
		
		private var _canvas3D:Sprite3D;
		private var candles:Array;
		
		private var _candlesEffectBitmap:Bitmap;
		private var _effectLayer:Sprite;
		private var _effectBitmapData:BitmapData;
		
		private var _matrix:Matrix = new Matrix(1,0,0,1,640*.5,480*.5);
		private var _transformDirty:Boolean = false;
		
		private var _point:Point = new Point(0, 0);
		
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
			
			var totalPoint:int=100000;
			for(var i:int=0;i<totalPoint;i++)
			{
				var _candle:Candle = new Candle(String(i), int(1000*Math.random()), int(1000*Math.random()));
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
			
			var _bitmap3D:Bitmap3D = new Bitmap3D(_mapBitmapData);
			_bitmap3D.x = -_mapBitmapData.width/2;
			_bitmap3D.y = -_mapBitmapData.height/2;
			_canvas3D.addChild(_bitmap3D);
			_bitmap3D
			
			// candles
			var _candlesBitmapData:BitmapData = new BitmapData(500, 500, true, 0x000000);
			
			// data -> BitmapData
			var i:int = candles.length;
			var _candle:Candle;
			_candlesBitmapData.lock();
			while(i--)
			{
				_candle = Candle(candles[i]);
				_candlesBitmapData.setPixel(_candle.x, _candle.y, 0xFFFFFF*Math.random()/2 + 0xFFFFFF/2);
			}
			_candlesBitmapData.unlock();
			
			// bitmap -> _canvas3D
			var _candleBitmap3D:Bitmap3D = new Bitmap3D(_candlesBitmapData);
			_candleBitmap3D.x = -_candleBitmap3D.bitmapData.width/2;
			_candleBitmap3D.y = -_candleBitmap3D.bitmapData.height/2;
			
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
			var _hitArea:Sprite = DrawUtil.drawRect(640,480,0x000000);
			_hitArea.blendMode = BlendMode.ERASE;
			addChild(_hitArea);
			
			var _ccMouse:CCMouse = new CCMouse(_hitArea);
			_ccMouse.addEventListener(CCMouseEvent.MOUSE_DRAG, onDrag);
		}
		
		override protected function setupLayer():void
		{
			_effectBitmapData = new BitmapData(640,480, false, 0x000000);
			_candlesEffectBitmap = new Bitmap(_effectBitmapData, PixelSnapping.NEVER, false);
			addChild(_candlesEffectBitmap);
		}
		
		private function onDrag(event:CCMouseEvent):void
		{
			_canvas3D.x += event.data.dx;
			_canvas3D.y += event.data.dy;
			
			//_canvas3D.z =
			trace(_canvas3D.x, _canvas3D.y, _canvas3D.z) 
			
			// hover
			/*
			
			_______o (x,y,z)
			     /
			   / r
			o/_30___
			
			*/
			
			_transformDirty = true;
		}
		

		
		override protected function onPreRender():void
		{
			//_canvas3D.rotationZ = mouseX;
			//_transformDirty = true;
		}
		
		override protected function onPostRender():void
		{
			if(_transformDirty)
			{
				_effectBitmapData.lock();
				_effectBitmapData.draw(_canvas3D, _matrix);
				_effectBitmapData.applyFilter(_effectBitmapData, _effectBitmapData.rect, _point, new BlurFilter(4, 4, 1));
				_effectBitmapData.applyFilter(_effectBitmapData, _effectBitmapData.rect, _point, new ColorMatrixFilter( [ 1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0.8,0 ] ) );
				_effectBitmapData.unlock();
			}
		}
	}
}
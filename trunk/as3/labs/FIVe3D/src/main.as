package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	
	import net.badimon.five3D.display.Bitmap3D;
	import net.badimon.five3D.display.Sprite3D;

	/*
	   TODO:
	   1. create fake dot data array (1000 x 1000 = 1,000,000)
	   2. read data and write to map as set pixel (10,000-100,000)
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
		[Embed(source="assets/thai_map.png")]
		private var ThaiMapPNG:Class;
		
		private var _mapCanvas:Sprite3D;
		private var _candleCanvas:Sprite3D;
		private var _candleEffectCanvas:Sprite3D;
		private var candles:Array;
		
		//private var _candlesEffectBitmapData:BitmapData;
		private var _candlesEffectBitmap:Bitmap;
		
		override protected function onInit():void
		{
			setupData();
			setupLayer();
			setupView();
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
		
		private function setupLayer():void
		{
			_mapCanvas = new Sprite3D();
			
			var bitmap:Bitmap = new ThaiMapPNG as Bitmap
			var _bitmap3D:Bitmap3D = new Bitmap3D(bitmap.bitmapData);
			//_mapCanvas.addChild(_bitmap3D);
			//_scene.addChild(_mapCanvas);
			
			//candles
			var _candlesBitmapData:BitmapData = new BitmapData(500, 500, false, 0x000000);
			
			// data -> BitmapData
			var i:int = candles.length;
			while(i--)
			{
				var _candle:Candle = Candle(candles[i]);
				_candlesBitmapData.setPixel(_candle.x, _candle.y, 0xFFFFFF*Math.random());
			}
			
			// bitmap -> _mapCanvas
			var _candleBitmap3D:Bitmap3D = new Bitmap3D(_candlesBitmapData);
			_candleBitmap3D.x = -_candleBitmap3D.bitmapData.width/2;
			_candleBitmap3D.y = -_candleBitmap3D.bitmapData.height/2;
			
			_mapCanvas.addChild(_candleBitmap3D);
			_scene.addChild(_mapCanvas);
			
			//effect
			/*
			effectLayer = new Sprite();
			addChild(effectLayer);
			effectLayer.filters = [new BlurFilter(8,8,1)];
			*/
			effectBitmapData = new BitmapData(640,480, true, 0xFFFFFF);
			_candlesEffectBitmap = new Bitmap(effectBitmapData);
			addChild(_candlesEffectBitmap);
			_candlesEffectBitmap.blendMode = BlendMode.ADD;
		}
		
		private var effectLayer:Sprite;
		private var effectBitmapData:BitmapData;
		private function setupView():void
		{
			// angle
			_mapCanvas.rotationX = -45;
			_mapCanvas.rotationY = 0;
			_mapCanvas.rotationZ = 0;
		}
		
		override protected function onPreRender():void
		{
			_mapCanvas.rotationZ++;// data -> BitmapData
			var _matrix:Matrix = new Matrix();
			_matrix.tx = 640/2
			_matrix.ty = 480/2
			
			effectBitmapData.draw(_mapCanvas,_matrix);
			_candlesEffectBitmap.filters = [new BlurFilter(8,8,1)];
		}
	}
}
package
{
	import com.cutecoma.containers.Preloader;
	import com.cutecoma.display.CCSprite;
	import com.cutecoma.display.DrawTool;
	import com.cutecoma.events.CCMouseEvent;
	import com.cutecoma.net.LoaderTool;
	import com.cutecoma.templates.Five3DTemplate;
	import com.cutecoma.ui.CCMouse;
	import com.cutecoma.utils.XMLUtil;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import data.CandleData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.badimon.five3D.display.Bitmap3D;
	import net.badimon.five3D.display.Particles;
	import net.badimon.five3D.display.Sprite2D;
	import net.badimon.five3D.display.Sprite3D;

	/*
	   TODO:
	   /1. create fake dot data array (1000 x 1000 = 1,000,000)
	   /2. read data and write to map as set pixel (10,000-100,000)
	   /3. add view controller move/pan/rotate
	   4. add click to view msg (getPixel)
	   5. create candle with perlin noise flame (BitmapSprite Clip?)
	   /6. add button and move to prefer angle view for place candle
	   \7. add dialog to get user input (name, msg)
	   \8. send data to server (time, x, y, name, msg)
	   \9. add blur/glow effect
	   10. add LOD setpixel <-> copypixel
	   11. add mask
	 */
	[SWF(width="1132",height="758",frameRate="30",backgroundColor="#000000")]
	public class main extends Five3DTemplate
	{
		// const
		private const SCREEN_WIDTH:int = 1132;
		private const SCREEN_HEIGHT:int = 758;
		
		private const DEFAULT_ANGLE:int = 60;
		
		private const DEFAULT_X:int = 0;
		private const DEFAULT_Y:int = -145;
		private const DEFAULT_Z:int = 0;
		
		private const USE_EFFECT:Boolean = false;
		private const EFFECT_TIMEOUT_NUM:int = 30;

		private const HIT_ARGB:uint = 202020;//"17170";
		
		private const SPRITE_SCALE:Number = .1;

		private const _matrix:Matrix = new Matrix(1, 0, 0, 1, SCREEN_WIDTH * .5, SCREEN_HEIGHT * .5);
		private const _point:Point = new Point(0, 0);

		// assets
		[Embed(source="assets/ThaiMap.swf",symbol="ThaiMap")]
		private var ThaiMapSWF:Class;

		[Embed(source="assets/ThaiMap.swf",symbol="CandleButton")]
		private var CandleButton:Class;

		[Embed(source="assets/ThaiMap.swf",symbol="CandleClip")]
		private var CandleClip:Class;
		private var _candleClip:Sprite;

		// loader
		private var _loader:Preloader;

		// data
		private var _xmlData:XML;
		private var candles:Array;
		private var _dropPoint:Point = new Point();

		// canvas
		private var _canvas3D:Sprite3D;
		private var _candleCanvas3D:Sprite3D;
		private var _candleBitmap3D:Bitmap3D;
		private var _mapBitmap3D:Bitmap3D;

		// effect
		private var _effectLayer:Sprite;
		private var _effectBitmapData:BitmapData;
		private var _blurFilter:BlurFilter = new BlurFilter(4, 4, 1);
		private var _colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0.9, 0]);

		// status
		private var _status:String;
		private var _transformDirty:Boolean = false;
		private var _dirtyNum:int = 0;

		// UI
		private var _candleButton:Sprite;
		private var _hitArea:Sprite;
		
		// layer
		//private var contentLayer:CCSprite = new CCSprite();
		private var systemLayer:CCSprite = new CCSprite();
		
		override protected function onInit():void
		{
			visible = false;
			alpha = .5;

			TweenPlugin.activate([AutoAlphaPlugin]);
			
			addChild(systemLayer);
			LoaderTool.loaderClip = systemLayer.addChild(new Preloader(systemLayer, SCREEN_WIDTH, SCREEN_HEIGHT));

			// get external config
			LoaderTool.loadXML("config.xml", function(event:Event):void
			{
				if(event.type!="complete")return;
				_xmlData = event.target.data;
				getData(XMLUtil.getXMLById(_xmlData, "GET_CANDLES").@src);
			});
		}

		private function getData(uri:String):void
		{
			status = "preload";
			
			LoaderTool.loadVars(uri, function(event:Event):void
			{
				if(event.type!="complete")return;
				var _candleList:Array = String(event.target.data.candles).split(";");
				setupData(_candleList);
			});
		} 
		
		private function setupData(candleList:Array):void
		{
			candles = [];
			var totalPoint:int = candleList.length;
			for (var i:int = 0; i < totalPoint; i++)
			{
				var _candleData:* = candleList[i].split(",");
				var _candle:Candle = new Candle(_candleData[0], int(_candleData[1]), int(_candleData[2]));
				candles[i] = _candle;
			}
			onDataComplete();
		}
		
		private function onDataComplete():void
		{
			status = "init";

			setupCanvas();
			setupView();
			//setupMask();
			setupUI();
			addChild(systemLayer);

			status = "intro";

			start();
		}

		private function setupCanvas():void
		{
			_canvas3D = new Sprite3D();
			_scene.addChild(_canvas3D);
			_canvas3D.singleSided = true;
			_canvas3D.mouseEnabled = false;

			_candleCanvas3D = new Sprite3D();
			_candleCanvas3D.singleSided = true;
			_candleCanvas3D.mouseEnabled = false;

			// map
			var _mapSprite:Sprite = new ThaiMapSWF() as Sprite;
			var _mapBitmapData:BitmapData = new BitmapData(_mapSprite.width, _mapSprite.height, true, 0x000000);
			_mapBitmapData.draw(_mapSprite);

			_mapBitmap3D = new Bitmap3D(_mapBitmapData, true, 10, 10);
			_mapBitmap3D.x = -_mapBitmapData.width/2;
			_mapBitmap3D.y = -_mapBitmapData.height/2;
			_mapBitmap3D.singleSided = true;
			_canvas3D.addChild(_mapBitmap3D);
			_mapBitmap3D.clipRect = new Rectangle(-1132-1132, -758-758, 1132*2+1132, 758*2+758);

			// candles
			var _candlesBitmapData:BitmapData = new BitmapData(_mapSprite.width, _mapSprite.height, true, 0x00000000);

			// data -> BitmapData
			var i:int = candles.length;
			var _candle:Candle;
			_candlesBitmapData.lock();
			
			_candleClip = new CandleClip() as Sprite;
			var _candleBitmapData:BitmapData = new BitmapData(_candleClip.width*SPRITE_SCALE, _candleClip.height*SPRITE_SCALE, true, 0xFF0000);
			_candleBitmapData.draw(_candleClip, new Matrix(SPRITE_SCALE, 0, 0, SPRITE_SCALE, _candleBitmapData.width/2, _candleBitmapData.height));

			while (i--)
			{
				_candle = Candle(candles[i]);
				if (_mapBitmapData.getPixel32(_candle.x, _candle.y) > 0)
				{
					// particle
					_candlesBitmapData.setPixel32(_candle.x, _candle.y, 0xFFFFCC00 + 0x00003300 * Math.random());
					
					// sprite2D
					var _sprite2D:Sprite2D = new Sprite2D();
					_sprite2D.x = _candle.x - _candlesBitmapData.width/2 - _candleBitmapData.width/2;
					_sprite2D.y = _candle.y - _candlesBitmapData.height/2 - _candleBitmapData.height;
					_sprite2D.graphics.beginBitmapFill(_candleBitmapData);
					_sprite2D.graphics.drawRect(0, 0, _candleBitmapData.width, _candleBitmapData.height);
					_sprite2D.graphics.endFill();
					_sprite2D.cacheAsBitmap = true;
					
					_candleCanvas3D.addChild(_sprite2D);
				}
			}
			_candlesBitmapData.unlock();

			// bitmap -> _canvas3D
			
			/*
			_candleBitmap3D = new Bitmap3D(_candlesBitmapData, true);
			_candleCanvas3D.addChild(_candleBitmap3D);
			_candleBitmap3D.x = -_candleBitmap3D.bitmapData.width / 2;
			_candleBitmap3D.y = -_candleBitmap3D.bitmapData.height / 2;
			_candleBitmap3D.singleSided = true;
			*/
			
			_canvas3D.addChild(_candleCanvas3D);
			
			// -------------------------------------------------------------
			// try setPixel
			
			var particles:Particles = new Particles(particlesBitmapData = new BitmapData(SCREEN_WIDTH, SCREEN_WIDTH));
			_canvas3D.addChild(particles);
			
			/*
			i = candles.length;
			while (i--)
			{
				
			}
			*/
		}
		
		private var particlesBitmapData:BitmapData;
		private var particles:Particles;
		
		private function setupView():void
		{
			_canvas3D.x = -50;
			_canvas3D.y = -120;
			_canvas3D.z = 830;
			
			_canvas3D.rotationX = 0;
			_canvas3D.rotationY = 0;
			_canvas3D.rotationZ = 0;
		}

		public function show():void
		{
			TweenLite.to(this, 0.25, {autoAlpha: 1});
		}

		public function hide():void
		{
			TweenLite.to(this, 0.25, {autoAlpha: 0});
		}

		/*
		   private function setupMask():void
		   {
		   var mat:Matrix = new Matrix();
		   var colors:Array = [0xFFFFFF, 0xFFFFFF];
		   var alphas:Array = [1, 0];
		   var ratios:Array = [200, 255];

		   mat.createGradientBox(SCREEN_WIDTH, SCREEN_HEIGHT);
		   var maskingShape:Shape = new Shape();
		   maskingShape.graphics.lineStyle();
		   maskingShape.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, mat);
		   maskingShape.graphics.drawEllipse(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
		   maskingShape.graphics.endFill();

		   maskingShape.cacheAsBitmap = true;
		   _scene.cacheAsBitmap = true;

		   _scene.mask = maskingShape;
		   }
		 */

		private function setupUI():void
		{
			// add hitArea
			_hitArea = DrawTool.drawRect(SCREEN_WIDTH, SCREEN_HEIGHT, 0x000000);
			_hitArea.blendMode = BlendMode.ERASE;
			addChild(_hitArea);

			var _ccMouse:CCMouse = new CCMouse(_hitArea);
			_ccMouse.addEventListener(CCMouseEvent.MOUSE_DRAG, onDrag);
			_ccMouse.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);

			_candleButton = new CandleButton() as Sprite;
			_candleButton.x = 1036;
			_candleButton.y = 590;
			_candleButton.buttonMode = true;
			addChild(_candleButton);

			/*
			   // add bound
			   var _boundArea:Sprite = DrawUtil.drawRect(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0xFF0000, .5);
			   _boundArea.x = SCREEN_WIDTH/2 - _boundArea.width/2;
			   _boundArea.y = SCREEN_HEIGHT/2 - _boundArea.height/2;
	
			   //_boundArea.blendMode = BlendMode.ERASE;
			   addChild(_boundArea);
			 */
		}

		private function onCandleButtonClick(event:MouseEvent):void
		{
			status = "drag";
		}

		private function onCandleDrop(event:MouseEvent):void
		{
			trace("onCandleDrop");

			_dropPoint.x = int(_mapBitmap3D.mouseX);
			_dropPoint.y = int(_mapBitmap3D.mouseY);

			// drop-in map?
			//var _ARGB:Object = BitmapTool.getARGB(_mapBitmap3D.bitmapData.getPixel32(_dropPoint.x, _dropPoint.y));
			//var _ARGBString:String = String(_ARGB.r) + String(_ARGB.g) + String(_ARGB.b);
			
			var _ARGB:int = _mapBitmap3D.bitmapData.getPixel32(_dropPoint.x, _dropPoint.y)
			
			// debug
			title = _dropPoint.toString() + " | " + _ARGB;

			// only hit area
			//if (_ARGBString != HIT_ARGB)
			//	return;

			//if (_candleBitmap3D.bitmapData.getPixel32(_dropPoint.x, _dropPoint.y) <= 0x000000)
			if (_ARGB < 0 )
			{
				status = "drop";
			//}else if(_hitArea.hitTestPoint(mouseX, mouseY)){
			//	status = "drag";
			}
			else
			{
				status = "drop-out";
			}
		}

		private function onExploreClick(event:Event):void
		{
			trace(event.target, event.currentTarget,event);
		}
		
		private function set status(value:String):void
		{
			trace(" ! Status : " + value);
			_status = value;
			switch (_status)
			{
				case "preload":
					_loader = new Preloader(this);
					addChild(_loader);
					break;
				case "init":
					removeChild(_loader);
					break;
				case "intro":
					// fade in
					TweenLite.to(this, 2, {autoAlpha: 1, onComplete: function():void
						{
							// go idle
							TweenLite.to(this, 2, {autoAlpha: 1, onComplete: function():void
							{
								status = "idle";
							}});
						}});
					break;
				case "idle":
					// go default angle
					TweenLite.to(_canvas3D, 1, {x:DEFAULT_X, y:DEFAULT_Y, z:DEFAULT_Z, rotationX: -DEFAULT_ANGLE, rotationY: 0, rotationZ: 0});
					
					// wait for drag, explore
					var onExplore:Function;
					stage.addEventListener(MouseEvent.MOUSE_DOWN, onExplore = function():void
						{
							stage.removeEventListener(MouseEvent.MOUSE_DOWN, onExplore);
							status = "explore";
						});
					
					// wait for candle click
					_candleButton.removeEventListener(MouseEvent.CLICK, onCandleButtonClick);
					_candleButton.addEventListener(MouseEvent.CLICK, onCandleButtonClick);
					break;
				case "explore":
					// move cam to defined position
					TweenLite.to(_canvas3D, 1, {x:DEFAULT_X, y:DEFAULT_Y, z:DEFAULT_Z, rotationX: -DEFAULT_ANGLE, rotationY: 0, rotationZ: 0});
					
					// click to view
					stage.addEventListener(MouseEvent.MOUSE_DOWN, onExploreClick);
					break;
				case "drag":
					// no more click
					_candleButton.removeEventListener(MouseEvent.CLICK, onCandleButtonClick);
					
					// draging in bound
					TweenLite.to(_candleButton, 0.25, {autoAlpha: 0.25});
					TweenLite.to(_candleClip, 0.25, {autoAlpha: 1});

					addChild(_candleClip);
					_candleClip.startDrag(true);

					// wait for drop
					stage.addEventListener(MouseEvent.MOUSE_DOWN, onCandleDrop);
					break;
				case "drop":
					// drop
					_candleClip.stopDrag();
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, onCandleDrop);
					
					// get id
					var _id:String = new Date().valueOf() as String;

					// get position
					var candleData:CandleData = new CandleData(_id, _dropPoint.x, _dropPoint.y);

					// wait for text input
					status = "input";
					
					// wait for candle click
					TweenLite.to(_candleButton, 0.25, {autoAlpha: 1});
					_candleButton.addEventListener(MouseEvent.CLICK, onCandleButtonClick);				
					break;
				case "drop-out":
					// drop
					_candleClip.stopDrag();
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, onCandleDrop);
					
					TweenLite.to(_candleClip, 0.25, {autoAlpha: 0, onComplete: function():void
						{
							_candleClip.parent.removeChild(_candleClip);
						}});
					// go explore
					
					
					// wait for candle click
					TweenLite.to(_candleButton, 0.25, {autoAlpha: 1});
					_candleButton.addEventListener(MouseEvent.CLICK, onCandleButtonClick);
					break;
				case "input":
					// wait for submit
					title += "...wait for input";

					// wait for server response
					break;
				case "submit":
					// view msg
					// go idle
					break;
			}
		}

		private function dragHandler(event:Event):void
		{
			if (_candleClip)
				_candleClip.stopDrag();
		}

		public function destroy():void
		{
			if (_candleButton)
				_candleButton.removeEventListener(MouseEvent.CLICK, onCandleButtonClick);

			if (_candleClip)
				removeChild(_candleClip);
		}

		override protected function setupLayer():void
		{
			// guide
			addChild(LoaderTool.loadAsset("../src/assets/bg.png"));

			_effectBitmapData = new BitmapData(SCREEN_WIDTH, SCREEN_HEIGHT, true, 0x000000);
			var _effectBitmap:Bitmap = new Bitmap(_effectBitmapData, PixelSnapping.NEVER, false);
			addChild(_effectBitmap);
		}

		private function onDrag(event:CCMouseEvent):void
		{
			_canvas3D.x += event.data.dx;
			_canvas3D.z += event.data.dy * Math.sin(90 - _canvas3D.rotationX);
			_canvas3D.y += event.data.dy;

			setDirty();
		}

		private function onWheel(event:MouseEvent):void
		{
			var _x:Number = _canvas3D.x;
			var _y:Number = _canvas3D.y;
			var _z:Number = _canvas3D.z;

			_y = _y + 5 * event.delta * Math.sin(DEFAULT_ANGLE);
			_z = _z + 5 * event.delta * Math.cos(DEFAULT_ANGLE);

			if(_z>-320)
			{
				_canvas3D.setPosition(_x, _y, _z);
				setDirty();
			}
		}

		private function setDirty():void
		{
			_dirtyNum = 0;
			_transformDirty = true;
		}

		override protected function onPreRender():void
		{
			if (_status == "idle")
			{
				_canvas3D.rotationZ++;
				setDirty();
			} 
			
			if (_transformDirty)
			{
				
			}
		}

		override protected function onPostRender():void
		{
			if (_transformDirty)
			{
				if (USE_EFFECT)
				{
					_effectBitmapData.lock();
					_effectBitmapData.draw(_candleCanvas3D, _matrix);
					_effectBitmapData.applyFilter(_effectBitmapData, _effectBitmapData.rect, _point, _blurFilter);
					_effectBitmapData.applyFilter(_effectBitmapData, _effectBitmapData.rect, _point, _colorMatrixFilter);
					_effectBitmapData.unlock();
				}

				if (_dirtyNum++ > EFFECT_TIMEOUT_NUM)
				{
					_transformDirty = false;
					_dirtyNum = 0;
				}
			}
		}
	}
}
package
{
	import com.greensock.TweenLite;
	import com.sleepydesign.components.DialogBalloon;
	import com.sleepydesign.data.DataProxy;
	import com.sleepydesign.display.DrawUtil;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.FormEvent;
	import com.sleepydesign.events.MouseUIEvent;
	import com.sleepydesign.managers.EventManager;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.skins.Preloader;
	import com.sleepydesign.ui.MouseUI;
	import com.sleepydesign.utils.StringUtil;
	import com.sleepydesign.utils.XMLUtil;
	
	import data.CandleData;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.URLVariables;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	import net.badimon.five3D.display.Bitmap3D;
	import net.badimon.five3D.display.Sprite2D;
	import net.badimon.five3D.display.Sprite3D;
	import net.badimon.five3D.templates.Five3DTemplate;

	/*
	   TODO:
	
	 */
	//[SWF(width="1680",height="822",frameRate="30",backgroundColor="#000000")]
	[SWF(width="1132", height="654", frameRate="30", backgroundColor="#000000")]
	public class CandlePage extends Five3DTemplate
	{
		// const
		private const DEFAULT_ANGLE:int = 60;
		
		private const DEFAULT_X:int = 0;
		private const DEFAULT_Y:int = -80;
		private const DEFAULT_Z:int = 0;
		
		private var USE_EFFECT:Boolean = false;
		private const EFFECT_TIMEOUT_NUM:int = 30;
		
		private const IDLE_DELAY:int = 3;

		private const HIT_ARGB:uint = 202020;//"17170";
		
		private const SPRITE_SCALE:Number = .1;
		private const USER_SPRITE_SCALE:Number = .25;

		private var _matrix:Matrix;
		private const _point:Point = new Point(0, 0);

		// assets
		[Embed(source="assets/ThaiMap.swf",symbol="ThaiMap")]
		private var ThaiMapSWF:Class;
		private var _mapSprite:Sprite = new ThaiMapSWF() as Sprite;

		[Embed(source="assets/ThaiMap.swf",symbol="CandleButton")]
		private var CandleButton:Class;
		private var _candleButton:Sprite = new CandleButton() as Sprite;

		[Embed(source="assets/ThaiMap.swf",symbol="CandleClip")]
		private var CandleClip:Class;
		private var _candleClip:Sprite = new CandleClip() as Sprite;
		
		/*
		[Embed(source="assets/ThaiMap.swf",symbol="ForeGroundClip")]
		private var ForeGroundClip:Class;
		private var _foreGroundClip:Sprite = new ForeGroundClip as Sprite;
		*/
		
		[Embed(source="assets/ThaiMap.swf",symbol="LightClip")]
		private var LightClip:Class;
		private var _lightClip:MovieClip;// = new LightClip as MovieClip;
		
		[Embed(source="assets/ThaiMap.swf",symbol="MarkerClip")]
		private var MarkerClip:Class;
		private var _markerClip:Sprite = new MarkerClip as Sprite;
		
		[Embed(source="assets/ThaiMap.swf",symbol="MapIconClip")]
		private var MapIconClip:Class;
		private var _mapIconClip:Sprite = new MapIconClip() as Sprite;
		
		// loader
		private var _loader:Preloader;

		// data
		private var _xmlData:XML;
		private var _candles:Array;
		private var _dropPoint:Point = new Point();

		// canvas
		private var _canvas3D:Sprite3D;
		private var _candleCanvas3D:Sprite3D;
		private var _ballonCanvas3D:Sprite3D;
		private var _candleBitmap3D:Bitmap3D;
		private var _mapBitmap3D:Bitmap3D;
		private var _mapBitmapData:BitmapData;

		// effect
		private var _effectLayer:Sprite = new SDSprite();
		private var _effectBitmapData:BitmapData;
		private var _blurFilter:BlurFilter = new BlurFilter(4, 4, 1);
		private var _colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0.9, 0]);

		// status
		private var _status:String;
		private var _transformDirty:Boolean = false;
		private var _dirtyNum:int = 0;

		// UI
		private var _hitArea:Sprite;
		
		// layer
		private var systemLayer:SDSprite = new SDSprite();
		
		// modal
		private var submitPage:SDSprite;
		private var searchPage:SDSprite;
		private var _mapPage:Five3DTemplate;
		
		override protected function onInit():void
		{
			debug = !false;
			
			visible = false;
			alpha = 0;
			//show();

			addChild(systemLayer);
			LoaderUtil.loaderClip = new Preloader(systemLayer, _stageWidth, _stageHeight);

			// get external config
			LoaderUtil.loadXML("config.xml", function(event:Event):void
			{
				if(event.type!="complete")return;
				_xmlData = event.target.data;
				
				USE_EFFECT = (XMLUtil.getXMLById(_xmlData, "USE_EFFECT").@value=="true");
				IDLE_TIME = 30*int(StringUtil.getDefaultIfNull(XMLUtil.getXMLById(_xmlData, "IDLE_TIME").@value, "3"));
				
				IDLE_TIMES= [];
				IDLE_TIMES.push((StringUtil.getDefaultIfNull(XMLUtil.getXMLById(_xmlData, "IDLE_N_TIME").@value, "3")));
				IDLE_TIMES.push((StringUtil.getDefaultIfNull(XMLUtil.getXMLById(_xmlData, "IDLE_NE_TIME").@value, "3")));
				IDLE_TIMES.push((StringUtil.getDefaultIfNull(XMLUtil.getXMLById(_xmlData, "IDLE_M_TIME").@value, "3")));
				IDLE_TIMES.push((StringUtil.getDefaultIfNull(XMLUtil.getXMLById(_xmlData, "IDLE_S_TIME").@value, "3")));
				
				getData(XMLUtil.getXMLById(_xmlData, "GET_CANDLES").@src);
			});
			
			//search
			Search.addEventListener(Event.CLOSE, function(event:Event):void
			{
				if(searchPage)
					searchPage.destroy();
				status = "explore";
			});
						
			Search.addEventListener(Event.OPEN, function(event:Event):void
			{
				status = "search";
			});
			
			draw();
			
			// resize
			root.stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function draw():void
		{
			//trace(" ! draw : " + _stageWidth, _stageHeight);
			//pos
			var _x0:int = int((_stageWidth-root.stage.stageWidth)/2);
			var _y0:int = int((_stageHeight-root.stage.stageHeight)/2);
			
			_candleButton.x = _x0 + root.stage.stageWidth - 100;
			_candleButton.y = _y0 + root.stage.stageHeight - 200;
			
			_mapIconClip.x = _x0 + root.stage.stageWidth - _mapIconClip.width - 20; 
			_mapIconClip.y = _y0 + 20; 
			
			if(submitPage)
			{
				//submitPage.x = _x0;// - submitPage.width/2;
				//submitPage.y = _y0;// - submitPage.height/2;
			}
		}
		
		private function onResize(event:Event):void
		{
			draw();
		}
		
		private function getData(uri:String, isReload:Boolean=false):void
		{
			trace(" ! getData : " + uri);
			//status = "preload";
			
			LoaderUtil.loadVars(uri, function(event:Event):void
			{
				if(event.type!="complete")return;
				var _candleList:Array = String(event.target.data.candles).split(";");
				setupData(_candleList);
				
				if(!isReload)
				{
					//status = "init";
	
					setupCanvas();
					setupView();
					setupUI();
					addChild(systemLayer);
	
					status = "intro";
	
					start();
				}else{
					setupCandles();
				}
				
				// next page?
				if(event.target.data.next)
				{
					// delay abit
					trace(" ! delay : " + event.target.data.delay);
					TweenLite.to(systemLayer, int(event.target.data.delay) || 10, {onComplete: function reloadData():void
					{
						getData(uri.split("?")[0] + "?page=" + event.target.data.next, true);
						//getData("serverside/getCandles2.php", true);
					}});
				}
			});
		} 
		
		private var candleDict:Dictionary = new Dictionary(true);
		
		private function setupData(candleList:Array):void
		{
			// dispose
			disposeBalloon();
			
			if(_candles)
			{
				var _oldLength:int = _candles.length;
				var _sprite2D:Sprite2D;
				while(_oldLength--)
				{
					_sprite2D = Candle(_candles[_oldLength]).sprite2D;
					if(_sprite2D)
						_candleCanvas3D.removeChild(_sprite2D);
				}
			}
			
			_candles = [];
				
			var totalPoint:int = candleList.length;
			for (var i:int = 0; i < totalPoint; i++)
			{
				var _candleData:* = candleList[i].split(",");
				
				// dup?
				var _id:String = String(_candleData[0]);
				var _candle:Candle;
				if(!candleDict[_id])
				{
					// new
					_candle = new Candle(_candleData[0], int(_candleData[1]), int(_candleData[2]));
					// cache
					candleDict[_id] = _candle;
				}else{
					// restore
					_candle = candleDict[_id];
					if(_candle.sprite2D)
						_candleCanvas3D.addChild(_sprite2D);
				}
				
				// add
				_candles.push(_candle);
			}
		}
		
		private function setupCandles():void
		{
			// candles
			var _candlesBitmapData:BitmapData = new BitmapData(_mapSprite.width, _mapSprite.height, true, 0x00000000);

			// data -> BitmapData
			var i:int = _candles.length;
			var _candle:Candle;
			_candlesBitmapData.lock();
			
			var _candleBitmapData:BitmapData = new BitmapData(_candleClip.width*SPRITE_SCALE, _candleClip.height*SPRITE_SCALE, true, 0x000000);
			_candleBitmapData.draw(_candleClip, new Matrix(SPRITE_SCALE, 0, 0, SPRITE_SCALE, _candleBitmapData.width/2, _candleBitmapData.height));

			while (i--)
			{
				_candle = Candle(_candles[i]);
				if (_mapBitmapData.getPixel32(_candle.x, _candle.y) > 0)
				{
					// particle
					_candlesBitmapData.setPixel32(_candle.x, _candle.y, 0xFFFFCC00 + 0x00003300 * Math.random());
					
					// sprite2D
					var _sprite2D:Sprite2D = new Sprite2D();
//_sprite2D.scaled = false;
					_sprite2D.name = "candle_"+_candle.id;
					_sprite2D.x = _candle.x - _mapBitmapData.width/2;
					_sprite2D.y = _candle.y - _mapBitmapData.height/2;
					_sprite2D.graphics.beginBitmapFill(_candleBitmapData, new Matrix(1,0,0,1,-_candleBitmapData.width/2, -_candleBitmapData.height));
					_sprite2D.graphics.drawRect(-_candleBitmapData.width/2, -_candleBitmapData.height, _candleBitmapData.width, _candleBitmapData.height);
					_sprite2D.graphics.endFill();
					_sprite2D.cacheAsBitmap = true;
//_sprite2D.clipRect = new Rectangle(-1132, -654, 1132*2, 654*2);
					_sprite2D.buttonMode = true;
					_sprite2D.useHandCursor = true;
					_candle.sprite2D = _sprite2D;
					
					_lightClip = new LightClip as MovieClip;
					_lightClip.y = -10;
					_lightClip.gotoAndPlay(int(Math.random()*_lightClip.totalFrames));
					_lightClip.cacheAsBitmap = true;
					_lightClip.mouseEnabled = false;
					_sprite2D.addChild(_lightClip);
					
					_candleCanvas3D.addChild(_sprite2D);
				}
			}
			_candlesBitmapData.unlock();
		}
		
		private var _mapCanvas3D:Sprite3D;
		
		private function setupCanvas():void
		{
			_canvas3D = new Sprite3D();
			_scene.addChild(_canvas3D);
			_canvas3D.singleSided = true;
			_canvas3D.mouseEnabled = false;

			_candleCanvas3D = new Sprite3D();
			_candleCanvas3D.singleSided = true;
			_candleCanvas3D.mouseEnabled = false;
			
			_ballonCanvas3D = new Sprite3D();
			_ballonCanvas3D.singleSided = true;
			_ballonCanvas3D.mouseEnabled = false;

			_mapCanvas3D = new Sprite3D();
			_mapCanvas3D.singleSided = true;
			_mapCanvas3D.mouseEnabled = false;
			
			_mapBitmapData = new BitmapData(_mapSprite.width, _mapSprite.height, true, 0x000000);
			_mapBitmapData.draw(_mapSprite);
			
			_mapBitmap3D = new Bitmap3D(_mapBitmapData, true);
			_mapBitmap3D.x = -_mapBitmapData.width/2;
			_mapBitmap3D.y = -_mapBitmapData.height/2;
			_mapBitmap3D.singleSided = true;
			_mapCanvas3D.addChild(_mapBitmap3D);
			_canvas3D.addChild(_mapCanvas3D);
			//TODO:TEST
			//_mapBitmap3D.clipRect = new Rectangle(-1132, -654, 1132*2, 654*2);

			setupCandles();

			_canvas3D.addChild(_candleCanvas3D);
			_canvas3D.addChild(_ballonCanvas3D);
			
			// -------------------------------------------------------------

			_effectLayer.mouseChildren = false;
			_effectLayer.mouseEnabled = false;
			addChild(_effectLayer);
			
			/*
			_foreGroundClip.mouseChildren = false;
			_foreGroundClip.mouseEnabled = false;
			addChild(_foreGroundClip);
			*/
			
			addChild(_mapIconClip);
			_mapIconClip.useHandCursor = true;
			_mapIconClip.buttonMode = true;
			_mapIconClip.addEventListener(MouseEvent.CLICK, onMiniMapClick);
			
			addChild(stats);
			addChild(debugText);
		}
		
		private function onMiniMapClick(event:MouseEvent):void
		{
			if(Map.currentMapID != event.target.name)
			{
				Map.currentMapID = event.target.name;
				hide();
				TweenLite.to(_mapPage, 0.5, {autoAlpha:1, onComplete:function():void{
					_mapPage.start();
					loopMap(MAP_IDS.indexOf(Map.currentMapID));
				}});
			}else{
				if(_mapPage)
				{
					hide();
					TweenLite.to(_mapPage, 0.5, {autoAlpha:1, onComplete:function():void{
						_mapPage.start();
						loopMap(MAP_IDS.indexOf(Map.currentMapID));
					}});
				}
			}
		}
		
		private function setupView():void
		{
			_canvas3D.x = -50;
			_canvas3D.y = 0;
			_canvas3D.z = 830;
			
			_canvas3D.rotationX = 0;
			_canvas3D.rotationY = 0;
			_canvas3D.rotationZ = 0;
		}

		public function show():void
		{
			TweenLite.to(_scene, 0.5, {autoAlpha: 1});
			start();
		}

		public function hide():void
		{
			TweenLite.to(_scene, 0.5, {autoAlpha: 0});
			stop();
		}

		private function setupUI():void
		{
			var _mouseUI:MouseUI = new MouseUI(stage);
			_mouseUI.addEventListener(MouseUIEvent.MOUSE_DRAG, onDrag);
			_mouseUI.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);

			/*
			   // add bound
			   var _boundArea:Sprite = DrawUtil.drawRect(_stageWidth/2, _stageHeight/2, 0xFF0000, .5);
			   _boundArea.x = _stageWidth/2 - _boundArea.width/2;
			   _boundArea.y = _stageHeight/2 - _boundArea.height/2;
	
			   //_boundArea.blendMode = BlendMode.ERASE;
			   addChild(_boundArea);
			 */
		}

		private function onCandleButtonClick(event:MouseEvent):void
		{
			status = "input";
		}

		private function onCandleDrop(event:MouseEvent):void
		{
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
			//trace(event.target, event.currentTarget,event);
			// it's candle
			if(event.target is Sprite2D && String(event.target.name).indexOf("candle_")==0)
				setupOtherBalloon(event.target as Sprite2D);
		}
		
		private function set status(value:String):void
		{
			trace(" ! Status : " + value);
			Mouse.show();
			_candleButton.mouseEnabled = true;
			
			_status = value;
			switch (_status)
			{
				case "preload":
					break;
				case "init":
					break;
				case "intro":
					//hide thai map
					_canvas3D.visible = false;
					_canvas3D.alpha = 0;
					stop();
					
					// fade in
					TweenLite.to(this, 1, {autoAlpha: 1});/*, onComplete: function():void
					{
						// go idle
						//TweenLite.to(_canvas3D, 1, {x:DEFAULT_X, y:DEFAULT_Y, z:DEFAULT_Z, rotationX: -DEFAULT_ANGLE, rotationY: 0, rotationZ: 0});
						status = "idle";
					}});*/
					
					//load sub map
					LoaderUtil.load("MapPage.swf", function(event:Event):void
					{
						if(event.type=="complete")
						{
							_mapPage = event.target["content"] as Five3DTemplate;
							_mapPage.visible = false;
							_mapPage.alpha = 0;
							_mapPage.stop();
							addChild(_mapPage);
							
							_candleButton.buttonMode = true;
							addChild(_candleButton);
							_candleButton.visible = false;
							_candleButton.alpha = 0;
							TweenLite.to(_candleButton, .5, {autoAlpha: 1});
							
							status = "idle";
						}
					});
					
					break;
				case "idle":
					/*
					// go default angle
					TweenLite.to(_canvas3D, 1, {x:DEFAULT_X, y:DEFAULT_Y, z:DEFAULT_Z, rotationX: -DEFAULT_ANGLE, rotationY: 0, rotationZ: 0});
					
					setDirty();
					
					// wait for drag, explore
					var onExplore:Function;
					var _stage:Stage = root.stage;
					root.stage.addEventListener(MouseEvent.MOUSE_DOWN, onExplore = function():void
					{
						if(_status=="search" || _status=="input")
							return;
						
						_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onExplore);
						
						// move cam to defined position
						TweenLite.to(_mapCanvas3D, 1, {rotationZ: 0});
						TweenLite.to(_candleCanvas3D, 1, {rotationZ: 0});
						TweenLite.to(_ballonCanvas3D, 1, {rotationZ: 0});
						TweenLite.to(_canvas3D, 1, {x:DEFAULT_X, y:DEFAULT_Y, z:DEFAULT_Z, rotationX: -DEFAULT_ANGLE, rotationY: 0, rotationZ: 0, onComplete: function():void
						{
							// go explore
							if(_status!="input" && _status!="search")
								status = "explore";
						}});
						setDirty();
					});
					*/
					hide();
					TweenLite.to(_mapPage, 0.5, {autoAlpha:1, onComplete:function():void{
						
						Map.currentMapID = "_n";
						_mapPage.start();
						idleIndex = 0;
						
						// loop
						TweenLite.to(_mapPage, idleIndex, {autoAlpha:1, onComplete:function():void{
							loopMap();
						}});
					}});
					
					// wait for candle click
					_candleButton.removeEventListener(MouseEvent.CLICK, onCandleButtonClick);
					_candleButton.addEventListener(MouseEvent.CLICK, onCandleButtonClick);
					break;
				case "explore":
					// go default angle
					TweenLite.to(_canvas3D, 1, {x:DEFAULT_X, y:DEFAULT_Y, z:DEFAULT_Z, rotationX: -DEFAULT_ANGLE, rotationY: 0, rotationZ: 0 });
					setDirty();
					
					show();
				
					// click to view
					root.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onExploreClick);
					root.stage.addEventListener(MouseEvent.MOUSE_DOWN, onExploreClick);
					
					// wait for candle click
					TweenLite.to(_candleButton, 0.25, {autoAlpha: 1});
					_candleButton.removeEventListener(MouseEvent.CLICK, onCandleButtonClick);
					_candleButton.addEventListener(MouseEvent.CLICK, onCandleButtonClick);
					break;
				case "drag":
					TweenLite.to(_canvas3D, 1, { autoAlpha:1,
						x:-50, y:0, z:830, 
						rotationX: 0, rotationY: 0, rotationZ: 0
					});
					setDirty();
					
					// no more click
					_candleButton.removeEventListener(MouseEvent.CLICK, onCandleButtonClick);
					
					// draging in bound
					TweenLite.to(_candleButton, 0.25, {autoAlpha: 0.25});
					TweenLite.to(_candleClip, 0.25, {autoAlpha: 1});

					// mouse effct
					Mouse.hide();
					_markerClip.mouseEnabled = false;
					_candleClip.addChild(_markerClip);
					_candleClip.startDrag(true);
					
					addChild(_candleClip);
					_candleClip.startDrag(true);

					// wait for drop
					root.stage.addEventListener(MouseEvent.MOUSE_DOWN, onCandleDrop);
					break;
				case "drop":
					// drop
					_candleClip.removeChild(_markerClip);
					_candleClip.stopDrag();
					root.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onCandleDrop);
					
					// get id
					var _id:String = new Date().valueOf() as String;

					// get position
					var candleData:CandleData = new CandleData(_id, _dropPoint.x, _dropPoint.y);
					
					// wait for response
					mouseEnabled = false;
					submitPage.addEventListener(Event.CLOSE, function(event:Event):void
					{
						mouseEnabled = true;
						TweenLite.to(_candleButton, 0.25, {autoAlpha: 1});
						status = "view";
					});
					submitPage.addEventListener(Event.CANCEL, function(event:Event):void
					{
						mouseEnabled = true;
						TweenLite.to(_candleButton, 0.25, {autoAlpha: 1});
						status = "view";
					});

					// submit
					DataProxy.addData("$CANDLE_TIME", new Date().valueOf());
					DataProxy.addData("$CANDLE_X", _dropPoint.x);
					DataProxy.addData("$CANDLE_Y", _dropPoint.y);
					
					EventManager.dispatchEvent(new FormEvent(FormEvent.EXTERNAL_SUBMIT));
				break;
				case "drop-out":
					/*
						// drop
						_candleClip.stopDrag();
						root.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onCandleDrop);
						
						TweenLite.to(_candleClip, 0.25, {autoAlpha: 0, onComplete: function():void
						{
							_candleClip.parent.removeChild(_candleClip);
							
							// go explore
							status = "explore";
						}});
						
						// wait for candle click
						TweenLite.to(_candleButton, 0.25, {autoAlpha: 1});
						_candleButton.addEventListener(MouseEvent.CLICK, onCandleButtonClick);
					*/
					break;
				case "input":
					if(_mapPage)
					{
						TweenLite.to(_mapPage,0.5, {autoAlpha: 0, onComplete: function():void
						{
							_mapPage.stop();
						}});
						TweenLite.to(_scene,0.5, {autoAlpha:1});
					}
				
					_candleButton.mouseEnabled = false;
				
					// wait for server response
					LoaderUtil.load("SubmitPage.swf", function(event:Event):void
					{
						if(event.type=="complete")
						{
							submitPage = event.target["content"] as SDSprite;
							submitPage.alpha = 0;
							submitPage.visible = false;
							addChild(submitPage);
							
							// show
							TweenLite.to(submitPage, 0.5, {autoAlpha: 1});
							/*
							TweenLite.to(_candleClip, 0.25, {autoAlpha: 0, onComplete: function():void
							{
								_candleClip.parent.removeChild(_candleClip);
							}});
							*/
							
							// hide
							var _onDeactivate:Function;
							submitPage.addEventListener(FormEvent.DATA_CHANGE, _onDeactivate = function(event:Event):void
							{
								submitPage.removeEventListener(FormEvent.DATA_CHANGE, _onDeactivate);
								status = "drag";
							});
						}
					});
					break;
				case "view":
					// view msg
					setupUserBalloon(
						DataProxy.getDataByID("$CANDLE_MSG") + "<br/>" + DataProxy.getDataByID("$CANDLE_EMAIL"),
						_dropPoint.x,
						_dropPoint.y
					);
					
					// go explore
					TweenLite.to(_candleClip, 1, {autoAlpha: 0, onComplete: function():void
					{
						status = "explore";
					}});
					break;
				case "search":
					if(submitPage)
					{
						submitPage.destroy();
					}
					
					LoaderUtil.load("SearchPage.swf", function(event:Event):void
					{
						if(event.type=="complete")
						{
							searchPage = event.target["content"] as SDSprite;
							searchPage.alpha = 0;
							searchPage.visible = false;
							addChild(searchPage);
							
							// show
							TweenLite.to(searchPage, 0.5, {autoAlpha: 1});
							
							// hide
							searchPage.addEventListener(Event.CLOSE, function(event:Event):void
							{
								status = "search-done";
							});
						}
					});
				break;
				case "search-done":
					// view msg
					if(Search.isGetResult)
					{
						setupUserBalloon(
							DataProxy.getDataByID("$SEARCH_MSG") + "<br/>" + DataProxy.getDataByID("$SEARCH_EMAIL"),
							int(DataProxy.getDataByID("$SEARCH_X")),
							int(DataProxy.getDataByID("$SEARCH_Y"))
						);
					}
					
					// go idle
					TweenLite.to(_candleClip, 1, {autoAlpha: 0, onComplete: function():void
					{
						status = "explore";
					}});
				break;
			}
		}
		
		private var idleObject:Object={};
		private var idleIndex:int=0;
		private var IDLE_TIMES:Array;
		private var MAP_IDS:Array = ["_n","_ne","_m","_s"];
		
		private function loopMap(index:int=-1):void
		{
			if(index!=-1)
				idleIndex=index;
			
			if(++idleIndex==IDLE_TIMES.length)
				idleIndex = 0;
			
			trace(" ! loopMap : " + idleIndex);
			
			TweenLite.killTweensOf(idleObject);
			TweenLite.to(idleObject, IDLE_TIMES[idleIndex], {onComplete:function():void{
				Map.currentMapID = MAP_IDS[idleIndex];
				loopMap();
			}});
		}
		
		private var _sprite2D:Sprite2D;
		private function setupUserBalloon(msg:String, x:Number, y:Number):void
		{
			// msg
			var _baloon:DialogBalloon = new DialogBalloon
			(
				msg,
				new TextFormat("Tahoma", 12, 0xF4B800), 0x000000, 0xFFFFFF,4,8
			);
			_sprite2D = new Sprite2D();
			_baloon.y = -50;
			_baloon.alpha = 0;
			_baloon.visible = false;
			//_sprite2D.addChild(_baloon);
			_sprite2D.cacheAsBitmap = true;
			_sprite2D.x = x-_mapBitmap3D.bitmapData.width/2;
			_sprite2D.y = y-_mapBitmap3D.bitmapData.height/2;

			// candle
			var _candleBitmapData:BitmapData = new BitmapData(_candleClip.width*USER_SPRITE_SCALE, _candleClip.height*USER_SPRITE_SCALE, true, 0x000000);
			_candleBitmapData.draw(_candleClip, new Matrix(USER_SPRITE_SCALE, 0, 0, USER_SPRITE_SCALE, _candleBitmapData.width/2, _candleBitmapData.height));

			_sprite2D.graphics.beginBitmapFill(_candleBitmapData, new Matrix(1,0,0,1,-_candleBitmapData.width/2, -_candleBitmapData.height));
			_sprite2D.graphics.drawRect(-_candleBitmapData.width/2, -_candleBitmapData.height, _candleBitmapData.width, _candleBitmapData.height);
			_sprite2D.graphics.endFill();
			
			_lightClip = new LightClip as MovieClip;
			_lightClip.y = -17;
			_lightClip.gotoAndPlay(int(Math.random()*_lightClip.totalFrames));
			_lightClip.cacheAsBitmap = true;
			_lightClip.mouseEnabled = false;
			_sprite2D.addChild(_lightClip);
			
			_sprite2D.visible = false;
			_sprite2D.alpha = 0;
			
			TweenLite.to(_baloon, 1, {autoAlpha: 1, y:-20});
			TweenLite.to(_sprite2D, 1, {autoAlpha: 1});
					
			_candleCanvas3D.addChild(_sprite2D);
			
			var _balloon2D:Sprite2D = new Sprite2D();
			_balloon2D.addChild(_baloon);
			_balloon2D.x = _sprite2D.x;
			_balloon2D.y = _sprite2D.y;
			_balloon2D.scaled = false;
			_balloon2D.cacheAsBitmap = true;
			_balloon2D.mouseEnabled = false;
			_ballonCanvas3D.addChild(_balloon2D);
		}
		
		private var _lastBalloon:DialogBalloon;
		
		private function disposeBalloon():void
		{
			if(!_lastBalloon)return;
			
			var __lastBalloon:DialogBalloon = _lastBalloon;
			TweenLite.to(__lastBalloon, 1, {autoAlpha: 0, onComplete: function():void
			{
				var _balloon2D:Sprite2D = __lastBalloon.parent as Sprite2D;
				__lastBalloon.destroy();
				if(_balloon2D)
					_ballonCanvas3D.removeChild(_balloon2D);
			}});
		}
		
		private function setupOtherBalloon(_sprite2D:Sprite2D):void
		{
			// destroy
			if(_lastBalloon)
				disposeBalloon();
			
			// msg
			var _baloon:DialogBalloon = new DialogBalloon(
				"loading...",
				new TextFormat("Tahoma", 12, 0xF4B800), 0x000000, 0xFFFFFF,4,8
			);
			_baloon.y = -20;
			_baloon.filters = [new GlowFilter(0xFFCC00, .75,6,6,1)];
			
			var _balloon2D:Sprite2D = new Sprite2D();
			_balloon2D.addChild(_baloon);
			_balloon2D.x = _sprite2D.x;
			_balloon2D.y = _sprite2D.y;
			_balloon2D.scaled = false;
			_balloon2D.cacheAsBitmap = true;
			_balloon2D.mouseEnabled = false;
			_ballonCanvas3D.addChild(_balloon2D);
			
			// load msg
			LoaderUtil.requestVars(XMLUtil.getXMLById(_xmlData, "GET_CANDLE").@src, new URLVariables("id="+_sprite2D.name), function(event:Event):void
			{
				if(event.type=="complete")
				{
					_baloon.htmlText = event.target.data.msg + "<br/>" + event.target.data.email;
				}
			});
			
			_lastBalloon = _baloon;
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
			//_stageWidth = 1680;
			//_stageHeight = 822;
			
			_matrix = new Matrix(1, 0, 0, 1, _stageWidth * .5, _stageHeight * .5);
			
			// guide
			if (parent && parent==stage)
				addChild(LoaderUtil.loadAsset("bg.jpg"));

			// add hitArea
			_hitArea = DrawUtil.drawRect(_stageWidth, _stageHeight, 0x000000);
			_hitArea.blendMode = BlendMode.ERASE;
			addChild(_hitArea);
			
			_effectBitmapData = new BitmapData(_stageWidth, _stageHeight, true, 0x000000);
			_effectBitmap = new Bitmap(_effectBitmapData, PixelSnapping.NEVER, false);
			_baseLayer.addChild(_effectBitmap);
			addChild(_baseLayer);
		}
		
		private var _effectBitmap:Bitmap;
		private var _baseLayer:SDSprite = new SDSprite();
		
		private function onDrag(event:MouseUIEvent):void
		{
			if(!_scene.visible)return;
			
			if(_status=="search" || _status=="input")
				return;
							
			if(_status=="explore" || _status=="drag")
			{
				_canvas3D.x += event.data.dx;
				_canvas3D.z += event.data.dy * Math.sin(90 - _canvas3D.rotationX);
				_canvas3D.y += event.data.dy;
	
				setDirty();
			}
		}

		private function onWheel(event:MouseEvent):void
		{
			if(!_scene.visible)return;
			
			if(_status=="explore" || _status=="drag")
			{
				var _x:Number = _canvas3D.x;
				var _y:Number = _canvas3D.y;
				var _z:Number = _canvas3D.z;
	
				_y = _y + 5 * event.delta * Math.sin(DEFAULT_ANGLE);
				_z = _z + 5 * event.delta * Math.cos(DEFAULT_ANGLE);
	
				if(_z<-320)
				{
					_z = _canvas3D.z;
					_y = _canvas3D.y;
				}
				
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
			if (_status == "idle" && _canvas3D)
			{
				/*
				_canvas3D.rotationX = 0;
				_canvas3D.askRendering()
				_canvas3D.rotationY++;
				_canvas3D.askRendering();
				_canvas3D.rotationX = -DEFAULT_ANGLE;
				_canvas3D.askRendering();
				*/
				_mapCanvas3D.rotationZ++;
				_candleCanvas3D.rotationZ++;
				_ballonCanvas3D.rotationZ++;
				setDirty();
			}
			
			// move mouse?
			if(mouseX==_mouseX && mouseY==_mouseY)
			{
				// break limit?
				if(idleNum<IDLE_TIME)
				{
					// count down
					idleNum++;
				}else{
					//reset
					idleNum = 0;
					
					// idle activate if in explore mode
					if(_status=="explore")
						status = "idle";
				}
			}else{
				idleNum = 0;
			}
			
			// do not idle while i input or search
			if(_status=="input" || _status=="search")
				idleNum = 0;
			
			//title = _status+","+String(idleNum);
			// mem last position
			_mouseX = mouseX;
			_mouseY = mouseY;
			
			if(_mapBitmap3D)
			{
				var _x:int = int(_mapBitmap3D.mouseX);
				var _y:int = int(_mapBitmap3D.mouseY);
	
				var _ARGB:int = _mapBitmap3D.bitmapData.getPixel32(_x, _y);
				
				// debug
				title = _x +","+ _y + " | " + idleNum + " | " + _ARGB;
			}
		}
		
		private var _mouseX:Number = 0;
		private var _mouseY:Number = 0;
		private var idleNum:int = 0;
		private var IDLE_TIME:int = 3;
		private var _rect:Rectangle;
		
		override protected function onPostRender():void
		{
			if (_transformDirty)
			{
				if (USE_EFFECT)
				{
					_rect = _effectBitmapData.rect;
					_effectBitmapData.lock();
					_effectBitmapData.draw(_candleCanvas3D, _matrix);
					_effectBitmapData.applyFilter(_effectBitmapData, _rect, _point, _blurFilter);
					_effectBitmapData.applyFilter(_effectBitmapData, _rect, _point, _colorMatrixFilter);
					_effectBitmapData.unlock();
					
					if(!_effectLayer.contains(_effectBitmap))
					{
						_effectLayer.addChild(_effectBitmap);
						TweenLite.to(_effectLayer, 0.5, {autoAlpha:1});
					}
				}

				if (_dirtyNum++ > EFFECT_TIMEOUT_NUM)
				{
					_transformDirty = false;
					_dirtyNum = 0;
					
					if (USE_EFFECT)
					TweenLite.to(_effectLayer, 3, {autoAlpha: 0, onComplete: function():void
					{
						_baseLayer.addChild(_effectBitmap);
					}});
				}
			}
		}
	}
}
package
{
	import away3dlite.core.clip.Clipping;
	import away3dlite.templates.BasicTemplate;
	
	import com.greensock.TweenLite;
	import com.sleepydesign.utils.FileUtil;
	import com.sleepydesign.utils.LoaderUtil;
	import com.sleepydesign.utils.SystemUtil;
	
	import flars.FLARManager;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.*;
	
	import qr.QRManager;

	/**
	 * QRCodeReader + FLARToolKit PoC (libspark rev. 3199, sandy rev. 1138)
	 * @license GPLv2
	 * @author makc
	 *
	 * @see http://www.openqrcode.com/
	 *
	 * [Step #1]
	 * 1.1 Flash	<-- HTML[UserURL, ModelURL]
	 * 1.2 Flash 	--> Request[URL] --> Server
	 * 1.3 Flash 	<-- Session[UserID] <-- Server
	 * 
	 * [Step #2]
	 * 2.1 User 	--> Image[QR, AR] 	--> Flash : Model ID, Projection Matrix
	 * 2.2 Flash 	--> MD5[DES[UserID, UserName, Time, ModelID]]	--> Server
	 * 2.3 Flash 	<-- Model[Link]	<-- Server
	 * 
	 * [Step #3]
	 * 3.2 Flash 	--> Model[Link] --> Server
	 * 3.3 Flash 	<-- Model[Mesh, Texture, Animation]	<-- Server
	 */
	[SWF(backgroundColor="0x333333", frameRate="30", width="320", height="240")]
	public class reader extends BasicTemplate
	{
		// screen
		private const SCREEN_WIDTH:int = 320;
		private const SCREEN_HEIGHT:int = 240;

		// capture size
		private const CANVAS_WIDTH:int = 320;
		private const CANVAS_HEIGHT:int = 240;

		// 3.2cm = 90px
		private const QR_SIZE:int = 90;
		
		// config
		private const USER_DATA:String = "userData";
		private const key:String = "ｪｩｵｴｪｴｦｬ｢ＯＯｺ";

		// root
		private var base:Sprite;
		private var cameraContainer:Sprite;

		// fake
		[Embed(source='../bin/codes/1K_E7BFAC.png')]
		private var ImageData:Class;
		
		private var fakeContainer:Sprite;
		private var fake:Sprite;
		private var _fakeBitmap:Bitmap;
		
		// Camera
		private var isCam:Boolean = false;
		
		// Debug
		private var _rbmp:Bitmap;
		
		// manager
		private var _QRReader:QRManager;
		private var _FLARManager:FLARManager;
		
		// result
		private var _modelViewer:ModelViewer;
		private var _itemNameTextField:TextField;
		
		// state
		private var _isQRDecoded:Boolean = false;
		private var _quality:String;
		
		public function reader()
		{
			//setting
			/*
			Oishi.USE_DEDUG = false;
			Oishi.USE_CAMERA = true;
			Oishi.USE_CONTEXT = true;
			
			Oishi.POSITION_Y = 320;
			Oishi.POSITION_Z = -100;
			
			Oishi.ROTATION_X = -90;
			Oishi.ROTATION_Z = -90;
			
			Oishi.SCALE_X = -1;
			Oishi.SCALE_Z = -1;
			*/
			
			Oishi.USE_DEDUG = true;
			Oishi.USE_CAMERA = false;
			
			// base
			base = new Sprite();
			addChild(base);
			//base.x = 160/2;
			//base.y = 120/2;

			// no cam test
			fakeContainer = new Sprite();
			base.addChild(fakeContainer);
			
			// fake code
			fake = new Sprite();
			fakeContainer.addChild(fake);

			fake.x = CANVAS_WIDTH / 2 - QR_SIZE / 2;
			fake.y = CANVAS_HEIGHT / 2 - QR_SIZE / 2;

			// cam test
			cameraContainer = new Sprite();
			base.addChild(cameraContainer);
		}

		public function show():void
		{
			start();
			visible = true;
		}
		
		public function hide():void
		{
			reset();
			stop();
			visible = false;
		}
		
		override protected function setupStage():void
		{
			// no setup stage need
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		override protected function onInit():void
		{
			view.x = SCREEN_WIDTH/2;
			view.y = SCREEN_HEIGHT/2;
			view.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
			
			view.clipping = new Clipping();
			
			view.buttonMode = false;
			view.mouseEnabled = false;
			view.mouseEnabled3D = false;

			camera.zoom = 6;
			camera.focus = 100;

			_modelViewer = new ModelViewer(scene);
			
			debug = Oishi.USE_DEDUG;
			
			if(!debug)
			{
				stats.visible = false;
				debugText.visible = false;
			}
			
			// get model data
			LoaderUtil.loadXML(Oishi.MODEL_DATA_URL, onGetModelData);
		}
		
		public static function getModelNameByCode(target:String):String
		{
			if(Oishi.MODEL_XML)
				return Oishi.MODEL_XML.ingredient.(code == target).name.text();
			else{
				trace("[ERROR] Must load xml data first!");
				return null;
			}
		}
		
		public static function getModelSourceByCode(target:String):String
		{
			if(Oishi.MODEL_XML)
				return Oishi.MODEL_XML.ingredient.(code == target).src.text();
			else{
				trace("[ERROR] Must load xml data first!");
				return null;
			}
		}
		
		private function onGetModelData(event:Event):void
		{
			// wait until complete
			if(event.type!="complete")return;

			Oishi.MODEL_XML = event.target["data"];
			
			//tell all
			Oishi.dispatchEvent(new Event(Event.COMPLETE));
			
			initARQR();
			
			// cam as default
			if(Oishi.USE_CAMERA)
				toggleCamera();
		}
		
		private function initARQR():void
		{
			// AR
			_FLARManager = new FLARManager(this, new BitmapData(CANVAS_WIDTH, CANVAS_HEIGHT, false, 0));
			
			// QR
			_QRReader = new QRManager(new BitmapData(CANVAS_HEIGHT, CANVAS_HEIGHT, false, 0));
			_QRReader.addEventListener(Event.COMPLETE, onQRCodeComplete);
			
			// lite
			camera.projection.fieldOfView = _FLARManager.fieldOfView;
			camera.projection.focalLength = _FLARManager.focalLength;
			
			//debug
			_rbmp = new Bitmap(_QRReader.homography);
			_rbmp.scaleX = _rbmp.scaleY = .25;
			_rbmp.y = 110;
			_rbmp.visible = debug;
			addChild(_rbmp);
			
			// add test image in the background
			setBitmap(Bitmap(new ImageData));

			// menu
			if(Oishi.USE_CONTEXT)
			{
				SystemUtil.addContext(this, "ARQRCode version 1.5");
				SystemUtil.addContext(this, "Toggle Camera", function ():void{toggleCamera()});
				SystemUtil.addContext(this, "Toggle Debug", function ():void{toggleDebug()});
				
				SystemUtil.addContext(this, "Open QRCode", function ():void{FileUtil.openImage(onImageReady)});
				SystemUtil.addContext(this, "Open Model", function ():void{FileUtil.openXML(onOpenModel)});
				SystemUtil.addContext(this, "Open Texture", function ():void{FileUtil.openImage(onTextureReady)});
				
				
				SystemUtil.addContext(this, "Open Model (Compress)", function ():void
				{
					FileUtil.openCompress(onOpenModel)
				});
				SystemUtil.addContext(this, "Save Model (Compress)", function ():void
				{
					if(ModelViewer.currentXML)
					{
						var _srcURLs:Array = ModelViewer.currentURI.split("/");
						var _fileName:String = _srcURLs.pop();
						FileUtil.saveCompress(ModelViewer.currentXML.toXMLString(), _fileName.split(".")[0]+".bin");
					}
				});
				
				SystemUtil.addContext(this, "Reset Code", function ():void{reset()});
			}

			// debug
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		// for dev time
		private function onTextureReady(event:Event):void
		{
			if(event.type == Event.COMPLETE)
				_modelViewer.setTexture(event.target.content);
		}
		
		private function onOpenModel(event:Event):void
		{
			if(event.type == Event.COMPLETE)
			{
				_modelViewer.parse(new XML(event["data"]));
			} else if(event.type == Event.SELECT){
				ModelViewer.currentURI = event.target["name"];
			}
		}
		
		private function onModelDecodeComplete(event:Event):void
		{
			if(event.type == Event.COMPLETE)
			{
				var _vars:URLVariables = new URLVariables(String(event.target["data"])); 
				
				if(_vars.src)
					_modelViewer.load(_vars.src);
			}
		}
		
		private function onQRCodeComplete(event:Event):void
		{
			_isQRDecoded = true;
			
			var _srcURL:String = getModelSourceByCode(QRManager.result);
			if(_srcURL)
			{
				_modelViewer.load(_srcURL);
			}
			else
			{
				trace("[ERROR] Model source not found!");
			}
			
			// dispatch
			Oishi.setCode(QRManager.result);
		}
		
		public function toggleDebug():void
		{		
			debug = !debug;
			stats.visible = debug;
			debugText.visible = debug;
			_rbmp.visible = debug;
		}
		
		public function toggleCamera():void
		{
			isCam = !isCam;

			if(!isCam)
			{
				fakeContainer.visible = true;
				cameraContainer.visible = false;
			}else{
				fakeContainer.visible = false;
				cameraContainer.visible = true;
			}

			reset();
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			if(!isCam)
			TweenLite.to(fake, .5, {
				rotationX:60*Math.random()-60*Math.random(),
				rotationY:60*Math.random()-60*Math.random(),
				rotationZ:60*Math.random()-60*Math.random()
			});
		}

		override protected function onPreRender():void
		{
			if(!visible)return;
			
			if(isCam)
			{
				if(!_FLARManager.video)
				{
					_FLARManager.setCamera(CANVAS_WIDTH, CANVAS_HEIGHT, 30);
					cameraContainer.addChild(_FLARManager.cameraBitmap);
				}
				
				_FLARManager.drawVideo();
			}

			process();

			if(_isQRDecoded)
			{
				_modelViewer.updateAnchor();
				_modelViewer.updateAnimation();
			}else{
				_modelViewer.visible = false;
			}
			
			if(view.visible != _modelViewer.visible)
				view.visible = _modelViewer.visible;
		}

		private function onImageReady(event:Event):void
		{
			if(event.type == Event.COMPLETE)
			{
				if(_fakeBitmap)
				{
					_fakeBitmap.parent.removeChild(_fakeBitmap);
					_fakeBitmap = null;
				}

				setBitmap(event.target.content);
			}
		}

		public function reset():void
		{
			_isQRDecoded = false;
			
			try{
				_QRReader.reset();
			}catch(e:*){trace(e);}
			
			try{
				_modelViewer.reset();
			}catch(e:*){trace(e);}
		}
		
		private function setBitmap(bitmap:Bitmap):void
		{
			reset();
			
			title = "reset";
			
			if(_fakeBitmap)
			{
				_fakeBitmap.parent.removeChild(_fakeBitmap);
				_fakeBitmap = null;
			}
			
			_fakeBitmap = bitmap;
			_fakeBitmap.width = _fakeBitmap.height = QR_SIZE;
			_fakeBitmap.smoothing = true;

			fake.addChild(_fakeBitmap);
		}
		
		private function process():void
		{
			// prevent error
			//try{
			if(!_FLARManager || !_FLARManager.ready)return;
			
			var n:Number;
			
			if(!isCam)
			{
				n = _FLARManager.getDetectNumber(fakeContainer);
			}else{
				n = _FLARManager.getDetectNumber(cameraContainer);
			}
			
			title = "AR : " + n;
			
			_modelViewer.setRefererPoint(_FLARManager.getStuff());
			
			// marker more than 2
			if (n > 2)
			{
				_modelViewer.setAxis(_FLARManager.getAxis());
				
				if(!_isQRDecoded)
				{
					var _point4:* = _FLARManager.getPoint();
					
					// now read QR code
					_QRReader.processHomography(_FLARManager._bitmapData, CANVAS_HEIGHT, CANVAS_HEIGHT, _point4.p0, _point4.p1, _point4.p2, _point4.p3);
					
					title += " | QR : processing... | ";
				}else{
					title += " | QR : " + QRManager.result + " | ";
				}
			}else{
				if(QRManager.result!="")
				{
					title += " | QR : " + QRManager.result + " | ";
				}else{
					title += " | QR : n/a  | ";
				}
			}
			
			//}catch(e:*){}
		}
	}
}
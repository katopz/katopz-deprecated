package
{
	import away3dlite.core.clip.Clipping;
	import away3dlite.templates.BasicTemplate;
	
	import com.adobe.crypto.MD5;
	import com.greensock.TweenLite;
	import com.sleepydesign.crypto.DES;
	import com.sleepydesign.crypto.PBE;
	import com.sleepydesign.utils.DataUtil;
	import com.sleepydesign.utils.DebugUtil;
	import com.sleepydesign.utils.FileUtil;
	import com.sleepydesign.utils.LoaderUtil;
	import com.sleepydesign.utils.ObjectUtil;
	import com.sleepydesign.utils.StringUtil;
	import com.sleepydesign.utils.SystemUtil;
	
	import flars.FLARManager;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
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
	 * 
	 * G2, G6, G7, G8
	 * ข้าว, กุ้ง, ไข่, หอมใหญ่
	 * 058454, 26B0EA, 2AFF7A, 2BD35D
	 * 
	 */
	[SWF(backgroundColor="0x333333", frameRate="30", width="320", height="240")]
	public class main extends BasicTemplate
	{
		// screen
		private const SCREEN_WIDTH:int = 320;
		private const SCREEN_HEIGHT:int = 240;

		// capture size
		private const CANVAS_WIDTH:int = 320;
		private const CANVAS_HEIGHT:int = 240;

		// 3.2cm = 90px
		private const QR_SIZE:int = 90;
		
		private const CAMERA_BY_DEFAULT:Boolean = true;//Camera.names.length>0;
		
		// config
		private var USER_URL:String = "serverside/userData.txt";
		private var MODEL_URL:String = "serverside/modelData.txt";
		
		//private var USER_URL:String = "http://127.0.0.1/Classes/katopz/branches/as3/ARQRCode/bin/serverside/userData.php";
		//private var MODEL_URL:String = "http://127.0.0.1/Classes/katopz/branches/as3/ARQRCode/bin/serverside/modelData.php";
		
		private const USER_DATA:String = "userData";
		private const key:String = "ｪｩｵｴｪｴｦｬ｢ＯＯｺ";

		// root
		private var base:Sprite;
		private var cameraContainer:Sprite;

		// fake
		[Embed(source='../codes/G2_058454.png')]
		private var ImageData:Class;
		
		private var fakeContainer:Sprite;
		private var fake:Sprite;
		private var _fakeBitmap:Bitmap;
		
		// Camera
		private var isCam:Boolean = false;
		
		// manager
		private var _QRReader:QRManager;
		private var _FLARManager:FLARManager;
		
		// result
		private var _modelViewer:ModelViewer;
		private var _itemNameTextField:TextField;
		
		// state
		private var _isQRDecoded:Boolean = false;
		public var isOnline:Boolean = true;
		
		//logo
		//[Embed(source='OISHI_LOGO.png')]
		//private var OISHILogo:Class;
		
		public function main()
		{
			// base
			base = new Sprite();
			addChild(base);
			//base.x = 160/2;
			//base.y = 120/2;

			// no cam test
			fakeContainer = new Sprite();
			base.addChild(fakeContainer);
			
			isOnline = isOnline && SystemUtil.isHTTP(this);

			// fake code
			fake = new Sprite();
			fakeContainer.addChild(fake);

			fake.x = CANVAS_WIDTH / 2 - QR_SIZE / 2;
			fake.y = CANVAS_HEIGHT / 2 - QR_SIZE / 2;

			// cam test
			cameraContainer = new Sprite();
			base.addChild(cameraContainer);
			
			//logo
			//var logo:Bitmap = new OISHILogo() as Bitmap 
			//addChild(logo);
			//logo.x = 640-logo.width;
			//logo.y = 480-logo.height;
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
			
			//get flashvars
			var _flashvars:Object = SystemUtil.getFlashVars(stage);
			
			trace(" ! USER_URL : "+_flashvars["USER_URL"]);
			trace(" ! MODEL_URL : "+_flashvars["MODEL_URL"]);
			
			// init
			USER_URL = StringUtil.isNull(_flashvars["USER_URL"])?USER_URL:_flashvars["USER_URL"];
			MODEL_URL = StringUtil.isNull(_flashvars["MODEL_URL"])?MODEL_URL:_flashvars["MODEL_URL"];

			// get user data
			LoaderUtil.loadVars(USER_URL, onGetUserData);
			
			// add some text
			_itemNameTextField = new TextField();
			_itemNameTextField.defaultTextFormat = new TextFormat("Tahoma", 20, 0xFFFFFF);
			_itemNameTextField.autoSize = TextFieldAutoSize.CENTER;
			_itemNameTextField.x = SCREEN_WIDTH/2 - _itemNameTextField.width/2;
			_itemNameTextField.y = SCREEN_HEIGHT/2 + 100;
			_itemNameTextField.filters = [new GlowFilter(0x000000, .6, 4,4,2 )];
			
			//deprecated//addChild(_itemNameTextField);
			
			DebugUtil.init(this, 0, SCREEN_HEIGHT/2+130);
			
			DebugUtil.enable = false;
			debug = false;
			
			removeChild(stats);
			removeChild(debugText);
		}
	
		private function onGetUserData(event:Event):void
		{
			// wait until complete
			if(event.type!="complete")return;

			trace(" ! onGetUserData");
			
			// grab user data
			var _userData:URLVariables = URLVariables(event.target["data"]);
			
			// sore
			DataUtil.addData(USER_DATA, _userData);
			
			// debug
			if(debug)
			{
				ObjectUtil.print(DataUtil.getDataByName(USER_DATA));
				
				DebugUtil.label.text = DataUtil.getDataByName(USER_DATA);
				DebugUtil.addText(USER_URL);
			}
			
			initARQR();
			
			// cam as default
			if(CAMERA_BY_DEFAULT)
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
			
			// debug
			/*
			var rbmp:Bitmap = new Bitmap(_QRReader.homography);
			rbmp.scaleX = rbmp.scaleY = .5;
			rbmp.y = 110;
			addChild(rbmp);
			*/

			// add test image in the background
			setBitmap(Bitmap(new ImageData));

			// menu
			SystemUtil.addContext(this, "ARQRCode version 1.2");
			SystemUtil.addContext(this, "Toggle Camera", function ():void{toggleCamera()});
			
			SystemUtil.addContext(this, "Open QRCode", function ():void{FileUtil.openImage(onImageReady)});
			SystemUtil.addContext(this, "Open Model", function ():void{FileUtil.openXML(onOpenModel)});
			SystemUtil.addContext(this, "Open Texture", function ():void{FileUtil.openImage(onTextureReady)});
			
			SystemUtil.addContext(this, "Reset Code", function ():void{reset()});

			// debug
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		// for dev time
		private function onTextureReady(event:Event):void
		{
			DebugUtil.trace(" ^ onTextureReady : " + event);
			if(event.type == Event.COMPLETE)
				_modelViewer.setTexture(event.target.content);
		}
		
		private function onOpenModel(event:Event):void
		{
			if(event.type == Event.COMPLETE)
			{
				DebugUtil.trace(" ^ onOpenModel");
				_modelViewer.parse(new XML(event["data"]));
			}
		}
		
		private function onModelDecodeComplete(event:Event):void
		{
			if(event.type == Event.COMPLETE)
			{
				DebugUtil.trace(" ^ onModelDecodeComplete");
				var _vars:URLVariables = new URLVariables(String(event.target["data"])); 
				
				if(_vars.src)
				{
					DebugUtil.clear();
					DebugUtil.addText(" ! Model : " + _vars.name+", "+_vars.src);
					
					_modelViewer.load(_vars.src);
					_itemNameTextField.text = _vars.name;
				}else{
					DebugUtil.trace(" ! Error : " + String(event.target["data"]));
					DebugUtil.addText(" ! Error : " + String(event.target["data"]));
					_itemNameTextField.text = "Error";
				}
			}
			
			DebugUtil.trace(event);
		}
		
		private function onQRCodeComplete(event:Event):void
		{
			DebugUtil.trace(" ^ onQRCodeComplete");
			_isQRDecoded = true;
			
			var _data:* = DataUtil.getDataByName(USER_DATA);
			var _vars:URLVariables = URLVariables(_data);
			_vars.code = QRManager.result;
			_vars.time = new Date().valueOf();
			
			//DebugUtil.trace(" ! Encypt : " + PBE.encypt(key));
			//DebugUtil.trace(" ! Decypt : " + PBE.decypt(PBE.encypt(key)));
			
			var _key:String = PBE.decypt(key);
			DebugUtil.trace(" ! Decypt Key : " + _key);
			DebugUtil.addText(" ! Decypt Key : " + _key);
			
			//reset
			_vars.session = "";
			_vars.hash = "";
			
			var _cipher:String = DES.encypt(_key, _vars.toString()+"&");
			_vars.session = DES.toHex(_cipher);
			_vars.hash = MD5.hash(_vars.toString());
			
			DebugUtil.trace(" * Hash : " + _vars.toString());
			DebugUtil.trace(" ! Encypt : " + DES.toHex(_cipher));
			DebugUtil.trace(" ! Decypt : " + DES.decypt(_key, _cipher));
			DebugUtil.trace(" ! Hash : " + _vars.hash);
			
			DebugUtil.addText(" * Hash : " + _vars.toString());
			DebugUtil.addText(" ! Encypt : " + DES.toHex(_cipher));
			DebugUtil.addText(" ! Decypt : " + DES.decypt(_key, _cipher));
			DebugUtil.addText(" ! Hash : " + _vars.hash);
			
			_itemNameTextField.text = "loading...";
			
			_modelViewer.visible = false;
			
			DebugUtil.trace(" ! isOnline : " + isOnline);
			DebugUtil.addText(" ! isOnline : " + isOnline);
			if(isOnline)
			{
				// for real use
				LoaderUtil.request(MODEL_URL + "?"+_vars.toString(), _vars, onModelDecodeComplete);
			}
			else
			{
				// for testing
				var _name:String;
				var _src:String;
				 
				if(QRManager.result=="058454")
				{
					_name="ข้าว";
					_src="serverside/G2.dae";
				}
				else if(QRManager.result=="26B0EA")
				{
					_name="กุ้ง";
					_src="serverside/G6.dae";
				}
				else if(QRManager.result=="2AFF7A")
				{
					_name="ไข่";
					_src="serverside/G7.dae";
				}
				else if(QRManager.result=="2BD35D")
				{
					_name="หอมใหญ่";
					_src="serverside/G8.dae";
				}
				else if(QRManager.result=="378E05")
				{
					_name="หมูสับ";
					_src="serverside/G10.dae";
				}
				else if(QRManager.result=="CCF29C")
				{
					_name="น้ำปลา";
					_src="serverside/T5.dae";
				}
				else if(QRManager.result=="B71B5C")
				{
					_name="น้ำซุปแดง";
					_src="serverside/T1.dae";
				}
				else if(QRManager.result=="C071FB")
				{
					_name="พริก";
					_src="serverside/T2.dae";
				}
				else if(QRManager.result=="353869")
				{
					_name="มะนาว";
					_src="serverside/G9.dae";
				}
				else
				{
					_name="Oishi";
					_src="serverside/Logo.dae";
				}
				
				_modelViewer.load(_src);
				_itemNameTextField.text = _name;
				
				
				/* 15/12/09
				ข้าวผัดกุ้ง - ข้าว/ไข่/หอมใหญ่/กุ้ง
				ข้าวไข่เจียวหมูสับ - ข้าว/ไข่/หมูสับ/น้ำปลา
				ต้มยำกุ้ง - กุ้ง/น้ำซุปแดง/พริก/มะนาว
				
				หมูสับ = G10
				น้ำปลา = T5
				น้ำซุปแดง = T1
				พริก = T2
				มะนาว = G9
				*/
			}
			
			// dispatch
			Oishi.setCode(QRManager.result);
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
				//view.visible = true;
				//stage.quality = "medium";
				
				_modelViewer.updateAnchor();
				_modelViewer.updateAnimation();
			}else{
				//view.visible = false;
				//stage.quality = "low";
				_modelViewer.visible = false;
			}
			
			if(view.visible != _modelViewer.visible)
				view.visible = _modelViewer.visible;
		}

		private function onImageReady(event:Event):void
		{
			DebugUtil.trace(" ^ onImageReady : " + event);

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
			_QRReader.reset();
			_modelViewer.reset();
				
			_itemNameTextField.text = "";
				
			DebugUtil.clear();
		}
		
		private function setBitmap(bitmap:Bitmap):void
		{
			DebugUtil.trace(" ! setBitmap");
			
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
			try{
			if(!_FLARManager || !_FLARManager.ready)return;
			
			var n:Number;
			
			if(!isCam)
			{
				n = _FLARManager.getDetectNumber(fakeContainer);
			}else{
				n = _FLARManager.getDetectNumber(cameraContainer);
			}
			
			title = "AR : " + n;
			
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
			
			_modelViewer.setRefererPoint(_FLARManager.getStuff());
			}catch(e:*){}
		}
	}
}
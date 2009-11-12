package
{
	import away3dlite.templates.BasicTemplate;
	
	import com.greensock.TweenLite;
	import com.sleepydesign.utils.FileUtil;
	import com.sleepydesign.utils.LoaderUtil;
	import com.sleepydesign.utils.ObjectUtil;
	import com.sleepydesign.utils.SystemUtil;
	
	import flars.FLARManager;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLVariables;
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
	 * 1.1 Loading Effect
	 * 1.2 Server 	--> Session[UserID] --> Flash
	 * 1.3 User 	--> Image[QR, AR] 	--> Model ID, Projection Matrix
	 * 1.4 Wait for User playing/proceed to next step
	 *
	 * [Step #2]
	 * 2.1 Loading Effect
	 * 2.2 Flash 	--> Encypt[Time, UserID, ModelID]	--> Server
	 * 2.3 Flash 	<-- Model[Mesh, Texture, Animation]	<-- Server
	 * 2.4 Spawn Effect
	 *
	 * [Step #3]
	 * 3.1 Wait for user input for next step
	 * 3.2 Flip Effect to next ingradient
	 * 3.3 Repeat step 1.2 --> 3.2 until finish condition?
	 *
	 * [Step #4]
	 * 4.1 Loading Effect
	 * 4.2 Flash 	--> Encypt[Time, UserID, ModelID, ModelID]	--> Server
	 * 4.3 Flash 	<-- Model[Mesh, Texture, Animation]			<-- Server
	 * 4.4 Spawn Effect
	 *
	 */
	[SWF(backgroundColor="0x333333", frameRate="30", width="640", height="480")]
	public class main extends BasicTemplate
	{
		// screen
		private const SCREEN_WIDTH:int = 640;
		private const SCREEN_HEIGHT:int = 480;

		// capture size
		private const CANVAS_WIDTH:int = 320;
		private const CANVAS_HEIGHT:int = 240;

		// 3.2cm = 90px
		private const QR_SIZE:int = 90;
		
		// config
		private var MODEL_URL:String = "serverside/modelData.php";
		private var USER_URL:String = "serverside/userData.php";

		// root
		private var base:Sprite;
		private var cameraContainer:Sprite;

		// fake
		[Embed(source='../bin/assets/A2A916.png')]
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
		
		// state
		private var _isQRDecoded:Boolean = false;

		public function main()
		{
			// base
			base = new Sprite();
			addChild(base);
			base.x = 160;
			base.y = 120;

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
			
			alpha = 0.1;
		}

		override protected function onInit():void
		{
			view.x = SCREEN_WIDTH/2;
			view.y = SCREEN_HEIGHT/2;
			view.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
			
			view.buttonMode = false;
			view.mouseEnabled = false;
			view.mouseEnabled3D = false;

			camera.zoom = 6;
			camera.focus = 100;

			_modelViewer = new ModelViewer(scene);

			// get user data
			LoaderUtil.loadVars(USER_URL, onGetUserData);
			
			initARQR();
		}
	
		private function onGetUserData(event:Event):void
		{
			// wait until complete
			if(event.type!="complete")return;

			// grab user data
			var _userData:URLVariables = URLVariables(event.target["data"]);
			
			// debug
			ObjectUtil.print(_userData);
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
			var rbmp:Bitmap = new Bitmap(_QRReader.homography);
			rbmp.scaleX = rbmp.scaleY = .5;
			rbmp.y = 160;
			addChild(rbmp);

			// add test image in the background
			setBitmap(Bitmap(new ImageData));

			// menu
			SystemUtil.addContext(this, "Open QRCode", function ():void{FileUtil.openImage(onImageReady)});
			SystemUtil.addContext(this, "Toggle Camera", onToggleCamera);
			SystemUtil.addContext(this, "Reset Code", function ():void{reset()});
			SystemUtil.addContext(this, "Open Model", function ():void{FileUtil.openXML(onOpenModel)});
			SystemUtil.addContext(this, "Open Texture", function ():void{FileUtil.openImage(onTextureReady)});

			// debug
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		// for dev time
		private function onTextureReady(event:Event):void
		{
			trace(" ^ onTextureReady : " + event);
			if(event.type == Event.COMPLETE)
				_modelViewer.setTexture(event.target.content);
		}
		
		private function onOpenModel(event:Event):void
		{
			trace(" ^ onOpenModel");
			if(event.type == Event.COMPLETE)
				_modelViewer.parse(event["data"]);
		}
		
		private function onQRCodeComplete(event:Event):void
		{
			trace(" ^ onQRCodeComplete");
			
			// TODO : send back user session, code
			_modelViewer.load(MODEL_URL);
			
			/*
			if(QRReader.result=="A2A916")
			{
				_modelViewer.load("assets/J7.dae");
			}else{
				_modelViewer.load("assets/G2.dae");
			}
			*/
			
			_isQRDecoded = true;
			
			// debug
			//title = "QR : " + QRReader.result + " | ";
		}

		private function onToggleCamera(event:ContextMenuEvent):void
		{
			isCam = !isCam;

			if(!isCam)
			{
				fakeContainer.visible = true;
				cameraContainer.visible = false;
			}else{
				fakeContainer.visible = false;
				cameraContainer.visible = true;
				
				cameraContainer.addChild(_FLARManager.cameraBitmap);
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
			if(isCam)
			{
				if(!_FLARManager.video)
					_FLARManager.setCamera(CANVAS_WIDTH, CANVAS_HEIGHT, 30);
				
				_FLARManager.drawVideo();
			}

			process();

			if(_isQRDecoded)
			{
				view.visible = true;
				stage.quality = "medium";
				
				_modelViewer.updateAnchor();
				_modelViewer.updateAnimation();
			}else{
				view.visible = false;
				stage.quality = "low";
			}
		}

		private function onImageReady(event:Event):void
		{
			trace(" ^ onImageReady : " + event);

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

		private function reset():void
		{
			_isQRDecoded = false;
			_QRReader.reset();
			_modelViewer.reset();
		}
		
		private function setBitmap(bitmap:Bitmap):void
		{
			trace(" ! setBitmap");
			
			reset();
			
			title = "reset";
			
			if(_fakeBitmap)
			{
				_fakeBitmap.parent.removeChild(_fakeBitmap);
				_fakeBitmap = null;
			}
			
			_fakeBitmap = bitmap;
			_fakeBitmap.width = _fakeBitmap.height = QR_SIZE;

			fake.addChild(_fakeBitmap);

			// show time
			process();
		}
		
		private function process():void
		{
			var n:Number;
			
			if(!isCam)
			{
				n = _FLARManager.getDetectNumber(fakeContainer);
			}else{
				n = _FLARManager.getDetectNumber(cameraContainer);
			}
			
			if (n > 2)
			{
				title = "AR : " + n;
				
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
				//trace("new one?")
				if(QRManager.result!="")
				{
					title += " | QR : " + QRManager.result + " | ";
				}else{
					title += " | QR : n/a  | ";
				}
			}
			
			_modelViewer.setRefererPoint(_FLARManager.getStuff());
		}
	}
}
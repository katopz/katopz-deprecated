package away3dlite.templates
{
	import away3dlite.arcane;
	import away3dlite.core.clip.*;
	import away3dlite.core.render.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	import org.libspark.flartoolkit.support.away3dlite.FLARCamera3D;

	[Event(name="init", type="flash.events.Event")]
	[Event(name="init", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]

	use namespace arcane;

	/**
	 * Template setup designed for FLARToolKit use.
	 *
	 * @see http://www.libspark.org/svn/as3/FLARToolKit
	 */
	public class FLARTemplate extends Template
	{
		private var _loader:URLLoader;
		private var _cameraFile:String;
		private var _codeFile:String;
		private var _width:int;
		private var _height:int;
		private var _codeWidth:int;

		protected var _param:FLARParam;
		protected var _code:FLARCode;
		protected var _raster:FLARRgbRaster_BitmapData;
		protected var _detector:FLARSingleMarkerDetector;

		protected var _webcam:Camera;
		protected var _video:Video;
		protected var _capture:Bitmap;
		
		//
		
		protected var _base:Sprite;
		protected var _camera3d:FLARCamera3D;
		
		protected var _resultMat:FLARTransMatResult = new FLARTransMatResult();

		/** @private */
		arcane override function init():void
		{
			super.init();

			view.renderer = renderer || new BasicRenderer();
			view.clipping = clipping || new RectangleClipping();
		}
		
		protected function initAR(cameraFile:String, codeFile:String, canvasWidth:int = 320, canvasHeight:int = 240, codeWidth:int = 80):void
		{
			_cameraFile = cameraFile;
			_width = canvasWidth;
			_height = canvasHeight;
			_codeFile = codeFile;
			_codeWidth = codeWidth;

			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(Event.COMPLETE, _onLoadParam);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			_loader.load(new URLRequest(_cameraFile));
			
			initView();
		}
		
		private function initView():void
		{
			_base = addChild(new Sprite()) as Sprite;
		}

		private function _onLoadParam(e:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, _onLoadParam);
			_param = new FLARParam();
			_param.loadARParam(_loader.data);
			_param.changeScreenSize(_width, _height);

			_loader.dataFormat = URLLoaderDataFormat.TEXT;
			_loader.addEventListener(Event.COMPLETE, _onLoadCode);
			_loader.load(new URLRequest(_codeFile));
			
			view.camera = _camera3d = new FLARCamera3D(_param, 600/1000);
		}

		private function _onLoadCode(e:Event):void
		{
			_code = new FLARCode(32, 32);
			_code.loadARPatt(_loader.data);

			_loader.removeEventListener(Event.COMPLETE, _onLoadCode);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, dispatchEvent);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatchEvent);
			_loader = null;

			// setup webcam
			trace("setup webcam")
			_webcam = Camera.getCamera();
			if (!_webcam)
				throw new Error('No webcam!!!!');

			// setup ARToolkit
			_raster = new FLARRgbRaster_BitmapData(new BitmapData(_width, _height));
			_capture = new Bitmap(BitmapData(_raster.bitmapData), PixelSnapping.AUTO, true);
			_detector = new FLARSingleMarkerDetector(_param, _code, _codeWidth);
			_detector.setContinueMode(true);
			
			_capture.width = 320;
			_capture.height = 240;
			_base.addChild(_capture);

			dispatchEvent(new Event(Event.INIT));
		}
		
		override protected function onPreRender():void
		{
			_capture.bitmapData.draw(_video);
			
			var detected:Boolean = false;
			try {
				detected = _detector.detectMarkerLite(_raster, 80) && _detector.getConfidence() > 0.5;
			} catch (e:Error) {}
			
			if (detected) {
				_detector.getTransformMatrix(_resultMat);
				trace(_resultMat);
			} else {
			}
		}

		/** @private */
		protected function build():void
		{
			// override me
		}

		/**
		 * The renderer object used in the template.
		 */
		public var renderer:Renderer;

		/**
		 * The clipping object used in the template.
		 */
		public var clipping:Clipping;
	}
}
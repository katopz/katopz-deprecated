package
{

	import flash.display.Sprite;
	import flash.events.Event;

	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.pv3d.FLARCamera3D;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.stats.StatsView;


	[SWF(width=640, height = 480, backgroundColor = 0x0)]

	public class PV3DARApp extends ARAppBase
	{

		private static const PATTERN_FILE:String = "Data/patt.hiro";
		private static const CAMERA_FILE:String = "Data/camera_para.dat";

		protected var _base:Sprite;
		protected var _viewport:Viewport3D;
		protected var _camera3d:FLARCamera3D;
		protected var _scene:Scene3D;
		protected var _renderer:LazyRenderEngine;
		protected var _baseNode:FLARBaseNode;

		protected var _resultMat:FLARTransMatResult = new FLARTransMatResult();


		public function PV3DARApp()
		{
		}

		protected override function init(cameraFile:String, codeFile:String, canvasWidth:int = 320, canvasHeight:int = 240, codeWidth:int = 80):void
		{
			addEventListener(Event.INIT, _onInit, false, int.MAX_VALUE);
			super.init(cameraFile, codeFile);
		}

		private function _onInit(e:Event):void
		{
			removeEventListener(Event.INIT, _onInit);

			_base = addChild(new Sprite()) as Sprite;

			_capture.width = 640;
			_capture.height = 480;
			_base.addChild(_capture);


			_viewport = _base.addChild(new Viewport3D(320, 240)) as Viewport3D;
			_viewport.scaleX = 640 / 320;
			_viewport.scaleY = 480 / 240;
			_viewport.x = -4; // 4pix ???

			_camera3d = new FLARCamera3D(_param);

			_scene = new Scene3D();
			_baseNode = _scene.addChild(new FLARBaseNode()) as FLARBaseNode;

			_renderer = new LazyRenderEngine(_scene, _camera3d, _viewport);

			stage.addChild(new StatsView(_renderer));

			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}

		private function _onEnterFrame(e:Event = null):void
		{
			_capture.bitmapData.draw(_video);
			if (_detector.detectMarkerLite(_raster, 80) && _detector.getConfidence() > 0.4)
			{
				_detector.getTransformMatrix(_resultMat);
				_baseNode.setTransformMatrix(_resultMat);

				_baseNode.visible = true;
			}
			else
			{
				_baseNode.visible = false;
			}
			_renderer.render();
		}

		public function set mirror(value:Boolean):void
		{
			if (value)
			{
				_base.scaleX = 1;
				_base.scaleY = 1;
				_base.x = 0;
			}
			else
			{
				_base.scaleX = 1;
				_base.x = 0;
			}
		}

		public function get mirror():Boolean
		{
			return _base.scaleX < 0;
		}

	}

}
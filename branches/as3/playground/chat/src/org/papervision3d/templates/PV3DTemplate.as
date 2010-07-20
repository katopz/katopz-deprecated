package org.papervision3d.templates
{
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import net.hires.debug.Stats;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	
	public class PV3DTemplate extends Sprite
	{
		protected var _stageWidth:Number = stage ? stage.stageWidth : NaN;
		protected var _stageHeight:Number = stage ? stage.stageHeight : NaN;
		
		protected var _screenRect:Rectangle;
		
		protected var _viewport:Viewport3D;
		protected var _scene:Scene3D;
		protected var _camera:Camera3D;
		protected var _renderer:BasicRenderEngine;
		
		protected var stats:Stats;
		
		public function PV3DTemplate()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			// setup stage
			setupStage();
			
			// init 3D
			init();
		}
		
		protected function setupStage():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.MEDIUM;
			
			if(!_screenRect)
			{
				_screenRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
				_screenRect.width = _stageWidth ? _stageWidth : _screenRect.width;
				_screenRect.height = _stageHeight ? _stageHeight : _screenRect.height;
			}
			
			scrollRect = _screenRect;
			
			onStage();
		}
		
		protected function onStage():void
		{
			// override me
		}

		protected function init():void
		{
			addChild(_viewport = new Viewport3D(_stageWidth, _stageHeight));
			
			addChild(stats = new Stats);

			_renderer = new BasicRenderEngine();
			_scene = new Scene3D();
			_camera = new Camera3D();
			_camera.lookAt(new DisplayObject3D());

			start();

			onInit();
		}
		
		protected function onInit():void
		{
			// override me
		}
		
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			onPreRender();
			_renderer.renderScene(_scene, _camera, _viewport);
		}
		
		protected function onPreRender():void
		{
			// override me
		}
	}
}
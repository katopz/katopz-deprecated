package com.cutecoma.engine3d.templates
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	
	import com.cutecoma.engine3d.api.*;
	import com.cutecoma.engine3d.templates.*;
	import com.cutecoma.engine3d.ui.*;

	public class CCTemplate extends Sprite
	{
		private var _Mouse:MouseInput = null;
		private var _GFX:CCEngine = null;

		public function CCTemplate()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			stage.showDefaultContextMenu = false;

			_GFX = new CCEngine(new Viewport(stage.stageWidth, stage.stageHeight));
			addChild(_GFX);

			_Mouse = new MouseInput(this, _GFX);

			initialize();

			run();
		}

		public function draw():void
		{

		}

		private function run():void
		{
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		protected function initialize():void
		{

		}

		private function enterFrameHandler(event:Event = null):void
		{
			draw();
			_GFX.renderFrame();
		}

		public function get gfx():CCEngine
		{
			return _GFX;
		}

		private function stageResizeHandler(event:Event):void
		{
			_GFX.viewport = new Viewport(stage.stageWidth, stage.stageHeight);
		}
	}
}
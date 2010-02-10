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
		private var _Mouse:MouseInput;
		private var _gFX:CCEngine;

		public function CCTemplate()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			stage.showDefaultContextMenu = false;

			_gFX = new CCEngine(new Viewport(stage.stageWidth, stage.stageHeight));
			addChild(_gFX);

			_Mouse = new MouseInput(this, _gFX);

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
			_gFX.renderFrame();
		}

		public function get gfx():CCEngine
		{
			return _gFX;
		}

		private function stageResizeHandler(event:Event):void
		{
			_gFX.viewport = new Viewport(stage.stageWidth, stage.stageHeight);
		}
	}
}
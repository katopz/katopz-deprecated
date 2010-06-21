package com.cutecoma.playground.core
{
	import away3dlite.cameras.Camera3D;
	import away3dlite.containers.Scene3D;
	import away3dlite.containers.View3D;
	import away3dlite.core.base.Object3D;
	import away3dlite.templates.BasicTemplate;
	
	import com.cutecoma.game.core.IEngine3D;
	import com.cutecoma.playground.data.CameraData;
	import com.cutecoma.playground.data.ViewData;
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.display.SDSprite;
	
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;

	public class Engine3D extends BasicTemplate implements IEngine3D, IDestroyable
	{
		private var _systemLayer:SDSprite;

		public function set systemLayer(value:SDSprite):void
		{
			_systemLayer = value;
		}

		public function get systemLayer():SDSprite
		{
			return _systemLayer;
		}
		
		private var _contentLayer:SDSprite;

		public function set contentLayer(value:SDSprite):void
		{
			_contentLayer = value;
		}

		public function get contentLayer():SDSprite
		{
			return _contentLayer;
		}
		
		public function get view3D():View3D
		{
			return view;
		}
		
		public function get scene3D():Scene3D
		{
			return scene;
		}
		
		public var completeSignal:Signal = new Signal();
		
		public function Engine3D()
		{
			
		}
		
		override protected function onInit():void
		{
			completeSignal.dispatch();
		}
	}
}
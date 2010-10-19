package com.sleepydesign.display
{
	import com.greensock.TweenLite;
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.core.ITransitionable;
	import com.sleepydesign.events.IRemovableEventDispatcher;
	import com.sleepydesign.events.ListenerManager;
	import com.sleepydesign.utils.DisplayObjectUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;

	public class SDClip extends SDSprite implements IDestroyable, ITransitionable
	{
		private const STATUS_INIT:String = "STATUS_INIT";
		
		private const STATUS_SHOW:String = "STATUS_SHOW";
		private const STATUS_HIDE:String = "STATUS_HIDE";
		
		private const STATUS_ACTIVATE:String = "STATUS_ACTIVATE";
		private const STATUS_DEACTIVATE:String = "STATUS_DEACTIVATE";
		
		private const STATUS_SHOWN:String = "STATUS_SHOWN";
		private const STATUS_HIDDEN:String = "STATUS_HIDDEN";
		
		private var _status:String = STATUS_INIT;
		
		public function get status():String
		{
			return _status;
		}
		
		public var statusSignal:Signal = new Signal(String);
		
		public function SDClip()
		{
			
		}
		
		public function show():void
		{
			TweenLite.to(this, .25, {autoAlpha:1, onComplete:shown});
		}
		
		public function hide():void
		{
			TweenLite.to(this, .25, {autoAlpha:0, onComplete:hidden});
		}
		
		protected function shown():void
		{
			activate();
			statusSignal.dispatch(_status);
		}
		
		protected function hidden():void
		{
			deactivate();
			statusSignal.dispatch(_status);
		}
		
		public function activate():void
		{
			mouseEnabled = true;
			mouseChildren = true;
			
			visible = true;
			alpha = 1;
		}
		
		public function deactivate():void
		{
			mouseEnabled = false;
			mouseChildren = false;
			
			visible = false;
			alpha = 0;
		}

		override public function destroy():void
		{
			TweenLite.killTweensOf(this);
			
			super.destroy();
		}
	}
}
package com.sleepydesign.display
{
	import com.greensock.TweenLite;
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.core.ITransitionable;
	
	import flash.events.Event;
	
	import org.osflash.signals.Signal;

	public class SDClip extends SDSprite implements IDestroyable, ITransitionable
	{
		public static const STATUS_INIT:String = "STATUS_INIT";
		
		public static const STATUS_SHOW:String = "STATUS_SHOW";
		public static const STATUS_HIDE:String = "STATUS_HIDE";
		
		public static const STATUS_ACTIVATE:String = "STATUS_ACTIVATE";
		public static const STATUS_DEACTIVATE:String = "STATUS_DEACTIVATE";
		
		public static const STATUS_SHOWN:String = "STATUS_SHOWN";
		public static const STATUS_HIDDEN:String = "STATUS_HIDDEN";
		
		protected var _status:String = STATUS_INIT;
		
		public function get status():String
		{
			return _status;
		}
		
		protected var _statusSignal:Signal = new Signal(SDClip, String);

		public function get statusSignal():Signal
		{
			return _statusSignal;
		}
		
		public function SDClip()
		{
			_statusSignal.dispatch(this, _status = STATUS_INIT);
			addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
		}
		
		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			onInit();
		}
		
		protected function onInit():void
		{
			
		}
		
		public function show():void
		{
			TweenLite.to(this, .25, {autoAlpha:1, onComplete:shown});
			_statusSignal.dispatch(this, _status = STATUS_SHOW);
		}
		
		public function hide():void
		{
			TweenLite.to(this, .1, {autoAlpha:0, onComplete:hidden});
			_statusSignal.dispatch(this, _status = STATUS_HIDE);
		}
		
		protected function shown():void
		{
			activate();
			_statusSignal.dispatch(this, _status = STATUS_SHOWN);
		}
		
		protected function hidden():void
		{
			deactivate();
			_statusSignal.dispatch(this, _status = STATUS_HIDDEN);
		}
		
		public function activate():void
		{
			mouseEnabled = true;
			mouseChildren = true;
			
			visible = true;
			alpha = 1;
			
			_statusSignal.dispatch(this, _status = STATUS_ACTIVATE);
		}
		
		public function deactivate():void
		{
			mouseEnabled = false;
			mouseChildren = false;
			
			visible = false;
			alpha = 0;
			
			_statusSignal.dispatch(this, _status = STATUS_DEACTIVATE);
		}
		
		override public function destroy():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			
			TweenLite.killTweensOf(this);
			
			_statusSignal = null;
			
			super.destroy();
		}
	}
}
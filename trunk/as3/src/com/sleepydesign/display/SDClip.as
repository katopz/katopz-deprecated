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

		protected var _statusSignal:Signal = new Signal(String, SDClip);

		public function get statusSignal():Signal
		{
			return _statusSignal;
		}

		public function SDClip()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage, false, 0, true);
		}

		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			if(_statusSignal)
				_statusSignal.dispatch(_status = STATUS_INIT, this);
			onInit();
		}

		protected function onInit():void
		{

		}

		public function show():void
		{
			TweenLite.to(this, .25, {autoAlpha: 1, onComplete: shown});
			if(_statusSignal)
				_statusSignal.dispatch(_status = STATUS_SHOW, this);
		}

		public function hide():void
		{
			TweenLite.to(this, .1, {autoAlpha: 0, onComplete: hidden});
			if(_statusSignal)
				_statusSignal.dispatch(_status = STATUS_HIDE, this);
		}

		protected function shown():void
		{
			activate();
			if(_statusSignal)
				_statusSignal.dispatch(_status = STATUS_SHOWN, this);
		}

		protected function hidden():void
		{
			deactivate();
			if(_statusSignal)
				_statusSignal.dispatch(_status = STATUS_HIDDEN, this);
		}

		public function activate():void
		{
			mouseEnabled = true;
			mouseChildren = true;

			visible = true;
			alpha = 1;

			if(_statusSignal)
				_statusSignal.dispatch(_status = STATUS_ACTIVATE, this);
		}

		public function deactivate():void
		{
			mouseEnabled = false;
			mouseChildren = false;

			visible = false;
			alpha = 0;

			if(_statusSignal)
				_statusSignal.dispatch(_status = STATUS_DEACTIVATE, this);
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
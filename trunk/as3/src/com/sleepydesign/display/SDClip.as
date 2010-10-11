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

	public class SDClip extends SDSprite implements IRemovableEventDispatcher, IDestroyable, ITransitionable
	{
		public static const IS_SHOWN:String = "IS_SHOWN";
		public static const IS_HIDDEN:String = "IS_HIDDEN";
		
		public var transitionSignal:Signal = new Signal(String);
		
		public function SDClip()
		{
			super();
		}
		
		public function show():void
		{
			TweenLite.to(this, .25, {autoAlpha:1, onComplete:shown});
		}
		
		public function hide():void
		{
			TweenLite.to(this, .25, {autoAlpha:0, onComplete:hidden});
		}
		
		public function shown():void
		{
			mouseEnabled = true;
			mouseChildren = true;
			
			visble = false;
			alpha = 0;
			
			transitionSignal.dispatch(IS_SHOWN);
		}
		
		public function hidden():void
		{
			mouseEnabled = false;
			mouseChildren = false;
			
			visble = false;
			alpha = 0;
			
			transitionSignal.dispatch(IS_HIDDEN);
		}

		public function destroy():void
		{
			TweenLite.killTweensOf(this);
			
			super();
		}
	}
}
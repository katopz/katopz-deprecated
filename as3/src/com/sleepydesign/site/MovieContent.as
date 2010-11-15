package com.sleepydesign.site
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.display.SDMovieClip;
	import com.sleepydesign.system.DebugUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	dynamic public class MovieContent extends Content implements IDestroyable
	{
		private var _isClickable:Boolean = false;

		public function get isClickable():Boolean
		{
			return _isClickable;
		}

		public function set isClickable(value:Boolean):void
		{
			_isClickable = value;
			
			mouseChildren = mouseEnabled = isClickable;
			
			if(_isClickable)
			{
				removeEventListener(MouseEvent.CLICK, onClick);
				addEventListener(MouseEvent.CLICK, onClick, false, 0 , true);
			}
		}
		
		protected function get Clip():Class
		{
			var _Class:Class;
			return _Class;
		}

		private var _embedClip:SDMovieClip;

		public function get embedClip():SDMovieClip
		{
			return _embedClip;
		}

		override protected function onInit():void
		{
			TweenPlugin.activate([FramePlugin, AutoAlphaPlugin]);

			_embedClip = new SDMovieClip(Clip);
			_embedClip.addEventListener(Event.COMPLETE, onClipConstruct);
			addChild(_embedClip);
			
			cacheAsBitmap = true;
		}

		protected function onClipConstruct(event:Event):void
		{
			
		}
		
		protected function onClick(event:MouseEvent):void
		{
			DebugUtil.trace(event);
		}

		override public function destroy():void
		{
			removeEventListener(MouseEvent.CLICK, onClick);
			
			_embedClip.removeEventListener(Event.COMPLETE, onClipConstruct);
			_embedClip = null;
			
			super.destroy();
		}
	}
}
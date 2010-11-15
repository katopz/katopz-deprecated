package com.sleepydesign.display
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.utils.DisplayObjectUtil;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;

	dynamic public class SDMovieClip extends SDClip implements IDestroyable
	{
		public static const STATUS_INIT_FRAME:String = "STATUS_INIT_FRAME";
		
		protected var _ClipClass:Class;
		
		protected function get Clip():Class
		{
			return _ClipClass;
		}

		private var _clip:MovieClip;

		public function get clip():MovieClip
		{
			return _clip;
		}

		public function SDMovieClip(ClipClass:Class)
		{
			_ClipClass = ClipClass;
			
			TweenPlugin.activate([FramePlugin, AutoAlphaPlugin]);

			cacheAsBitmap = true;
			
			new Clip().addEventListener(Event.COMPLETE, onClipInit, false, 0, true);
		}

		private function onClipInit(event:Event):void
		{
			event.target.removeEventListener(Event.INIT, onClipInit);
			var loader:Loader = event.target.getChildAt(0) as Loader;
			_clip = loader.content as MovieClip;
			_clip.gotoAndStop(1);
			_clip.addEventListener(Event.ADDED_TO_STAGE, onClipAddToStage, false, 0, true);
			addChild(_clip);
			
			TweenLite.to(_clip, _clip.totalFrames / 30, {frame: _clip.totalFrames, onComplete: onClipComplete});
			
			_statusSignal.dispatch(STATUS_INIT_FRAME, this);
		}
		
		protected function onClipAddToStage(event:Event):void
		{
			//_clip.removeEventListener(Event.ADDED_TO_STAGE, onClipAddToStage);
			//TweenLite.to(_clip, _clip.totalFrames / 30, {frame: _clip.totalFrames, onComplete: onClipComplete});
		}

		protected function onClipComplete():void
		{
			//dispatchEvent(new Event(Event.COMPLETE));
		}

		/*
		protected var _isDestroyed:Boolean;

		public function get destroyed():Boolean
		{
			return _isDestroyed;
		}

		public function destroy():void
		{
			_clip = null;
			
			_isDestroyed = true;

			DisplayObjectUtil.removeChildren(this, true, true);

			try
			{
				if (parent != null)
					parent.removeChild(this);
			}
			catch (e:*)
			{
			}
		}
		*/
	}
}
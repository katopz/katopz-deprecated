package com.sleepydesign.display
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.sleepydesign.core.IDestroyable;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;

	dynamic public class SDMovieClip extends SDClip implements IDestroyable
	{
		public static const STATUS_INIT_FRAME:String = "STATUS_INIT_FRAME";

		protected var _embedClass:Class;

		protected function get embedClass():Class
		{
			return _embedClass;
		}

		private var _clip:MovieClip;

		public function get clip():MovieClip
		{
			return _clip;
		}

		public function SDMovieClip(embedClass:Class)
		{
			_embedClass = embedClass;

			TweenPlugin.activate([FramePlugin]);

			cacheAsBitmap = true;

			new embedClass().addEventListener(Event.COMPLETE, onClipInit, false, 0, true);
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
			event.target.removeEventListener(Event.ADDED_TO_STAGE, onClipAddToStage);
			//TweenLite.to(_clip, _clip.totalFrames / 30, {frame: _clip.totalFrames, onComplete: onClipComplete});
		}

		protected function onClipComplete():void
		{

		}

		override public function destroy():void
		{
			_embedClass = null;
			_clip = null;

			super.destroy();
		}
	}
}
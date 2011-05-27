package com.sleepydesign.skins
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.net.LoaderUtil;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class Preloader extends SDSprite
	{
		public static var backgroundColor:Number = 0xFFFFFF;

		private var _bg:Sprite;
		private var _containter:DisplayObjectContainer;

		private var _stage:Stage;

		protected var _customSize:Rectangle;

		private var _loaderClip:DisplayObject;

		public function get loaderClip():DisplayObject
		{
			return _loaderClip;
		}

		public function Preloader(containter:DisplayObjectContainer, customSize:Rectangle = null, loaderClip:DisplayObject = null)
		{
			_containter = containter;
			_stage = containter.stage;
			_customSize = customSize || new Rectangle(0, 0, _stage.stageWidth, _stage.stageHeight);

			containter.addChild(this);

			// bg
			_bg = new Sprite();
			_bg.x = _bg.y = 0;
			addChild(_bg);

			// loader
			LoaderUtil.defaultLoaderClip = _loaderClip = addChild(loaderClip || new MacLoadingClip()) as Sprite;
			_loaderClip.x = _customSize.width / 2;
			_loaderClip.y = _customSize.height / 2;

			mouseEnabled = false;
			alpha = 0;
			visible = false;

			// effect
			TweenPlugin.activate([AutoAlphaPlugin]);
			LoaderUtil.showLoader = function():void
			{
				mouseEnabled = true;
				create();
				TweenLite.killTweensOf(LoaderUtil.defaultLoaderClip);
				TweenLite.to(LoaderUtil.defaultLoaderClip, 0.5, {autoAlpha: 1});
			};

			LoaderUtil.hideLoader = function():void
			{
				mouseEnabled = false;
				create();
				TweenLite.killTweensOf(LoaderUtil.defaultLoaderClip);
				TweenLite.to(LoaderUtil.defaultLoaderClip, 0.5, {autoAlpha: 0});
			};

			// resize
			_stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
			create();
		}

		private function create():void
		{
			var _x0:Number = Number((_customSize.width - _stage.stageWidth) / 2);
			var _y0:Number = Number((_customSize.height - _stage.stageHeight) / 2);

			_bg.graphics.clear();
			_bg.graphics.beginFill(backgroundColor, 0.75);
			//_bg.graphics.drawRect(-_stage.stageWidth/2-_stageWidth/2, 0, _stage.stageWidth+_stageWidth, _stage.stageHeight);
			_bg.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			_bg.graphics.endFill();
			_bg.x = _x0;
			_bg.y = _y0;
		}

		private function onResize(event:Event):void
		{
			create();
		}

		override public function destroy():void
		{
			_stage.removeEventListener(Event.RESIZE, onResize);

			if (_loaderClip)
			{
				TweenLite.killTweensOf(_loaderClip);
				_loaderClip.visible = false;
				_loaderClip.parent.removeChild(_loaderClip);
			}

			if (_bg)
			{
				_bg.graphics.clear();
				_bg.parent.removeChild(_bg);
			}

			if (LoaderUtil.defaultLoaderClip == _loaderClip)
				LoaderUtil.defaultLoaderClip = null;

			super.destroy()
		}
	}
}
package com.sleepydesign.containers
{
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.display.DrawTool;
	import com.sleepydesign.net.LoaderTool;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;	
	
	public class Preloader extends SDSprite
	{
		public static const DEFAULT:String = "default";
		
		private var _loader:Sprite;
		private var _bg:Sprite;
		
		public function Preloader(containter:DisplayObjectContainer, width:Number = NaN, height:Number = NaN, type:String = DEFAULT)
		{
			// auto size
			if(containter.stage && !width && !height)
			{
				width = containter.stage.stageWidth;
				height = containter.stage.stageHeight;
			}
			
			// bg
			_bg = DrawTool.drawRect(width, height, 0x000000, 0.75);
			addChild(_bg);
			
			// loader
			_loader = addChild(new MacLoadingClip()) as Sprite;
			_loader.x = width/2;
			_loader.y = height/2;
			
			mouseEnabled = false;
			alpha = 0;
			visible = false;
			
			// effect
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			LoaderTool.showLoader = function():void
			{
				TweenLite.to(this, 0.5, {autoAlpha:1});
			};
			
			LoaderTool.hideLoader = function():void
			{
				TweenLite.to(this, 0.5, {autoAlpha:0});
			};
		}
			
		override public function destroy():void
		{
			if(_loader)
				_loader.parent.removeChild(_loader);
			
			if(_bg)
				_bg.parent.removeChild(_bg);
			
			if(LoaderTool.loaderClip==_loader)
				LoaderTool.loaderClip = null;
			
			super.destroy()
		}
	}
}
package com.cutecoma.containers
{
	import com.cutecoma.display.CCSprite;
	import com.cutecoma.display.DrawTool;
	import com.cutecoma.net.LoaderTool;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;	
	
	public class Preloader extends CCSprite
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
			
			// loader
			_loader = addChild(new MacLoadingClip()) as Sprite;
			_loader.alpha = 0;
			_loader.visible = false;
			_loader.mouseEnabled = false;
			_loader.x = width/2;
			_loader.y = height/2;
			
			// effect
			TweenPlugin.activate([AutoAlphaPlugin]);
			
			LoaderTool.showLoader = function():void
			{
				TweenLite.to(_loader, 0.5, {autoAlpha:1});
			};
			
			LoaderTool.hideLoader = function():void
			{
				TweenLite.to(_loader, 0.5, {autoAlpha:0});
			};
			
			LoaderTool.addLoaderTo(containter, _loader);
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
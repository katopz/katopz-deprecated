package com.sleepydesign.skins
{
	import com.greensock.TweenLite;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.net.LoaderUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;	
	
	public class Preloader extends SDSprite
	{
		public static const DEFAULT:String = "default";
		
		private var _loader:Sprite;
		private var _bg:Sprite;
		private var _containter:DisplayObjectContainer;
		
		private var _stageWidth:int;
		private var _stageHeight:int;
		
		public function Preloader(containter:DisplayObjectContainer, width:Number = NaN, height:Number = NaN, type:String = DEFAULT)
		{
			_containter = containter;
			
			// auto size
			if(containter.stage && !width && !height)
			{
				_stageWidth = width = containter.stage.stageWidth;
				_stageHeight = height = containter.stage.stageHeight;
			}
			containter.addChild(this);
			
			// bg
			_bg = new Sprite();
			_bg.x = width/2;
			_bg.y = height/2;
			addChild(_bg);
			
			// loader
			_loader = addChild(new MacLoadingClip()) as Sprite;
			_loader.x = width/2;
			_loader.y = height/2;
			
			mouseEnabled = false;
			alpha = 0;
			visible = false;
			
			// effect
			LoaderUtil.showLoader = function():void
			{
				mouseEnabled = true;
				draw();
				TweenLite.to(LoaderUtil.loaderClip, 0.5, {autoAlpha:1});
			};
			
			LoaderUtil.hideLoader = function():void
			{
				mouseEnabled = false;
				draw();
				TweenLite.to(LoaderUtil.loaderClip, 0.5, {autoAlpha:0});
			};
			
			// resize
			containter.stage.addEventListener(Event.RESIZE, onResize);
			draw();
		}
		
		private function draw():void
		{
			var _x0:int = int((_stageWidth-stage.stageWidth)/2);
			var _y0:int = int((_stageHeight-stage.stageHeight)/2);
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000, 0.75);
			_bg.graphics.drawRect(-stage.stageWidth/2, -stage.stageHeight/2, stage.stageWidth, stage.stageHeight);
			_bg.graphics.endFill();
			//_bg.x = _x0;
			//_bg.y = _y0;
		}
		
		private function onResize(event:Event):void
		{
			draw();
		}
			
		override public function destroy():void
		{
			_containter.stage.removeEventListener(Event.RESIZE, onResize);
			
			if(_loader)
				_loader.parent.removeChild(_loader);
			
			if(_bg)
				_bg.parent.removeChild(_bg);
			
			if(LoaderUtil.loaderClip==_loader)
				LoaderUtil.loaderClip = null;
			
			super.destroy()
		}
	}
}
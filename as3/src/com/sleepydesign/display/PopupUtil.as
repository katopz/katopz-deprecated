package com.sleepydesign.display
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;

	public class PopupUtil
	{
		private static var bitmap:SDBitmap;
		private static var container:DisplayObjectContainer;
		private static var currentPopup:DisplayObjectContainer;
		
		private static var _listener:Function;
		
		public static function init(popupObject:DisplayObjectContainer):void
		{
			if(!popupObject)
				return;
			
			//down
			if(popupObject.parent.contains(popupObject))
				popupObject.parent.removeChild(popupObject);
			
			popupObject.visible = false;
			popupObject.alpha = 0;
			popupObject.mouseEnabled = false;
		}
		
		public static function popup(container:DisplayObjectContainer, popupObject:DisplayObjectContainer):void
		{
			//down
			dispose();
			
			// deactivate
			var _rect:Rectangle;
			if(container.stage.scrollRect)
				_rect = container.stage.scrollRect;
			else
				_rect = container.stage.getRect(container.stage);
			bitmap = new SDBitmap(new BitmapData(_rect.width, _rect.height, true, 0x00000000));
			bitmap.bitmapData.draw(container.stage);
			TweenLite.to(bitmap, .5, {blurFilter:{blurX:8, blurY:8}});
			container.stage.addChild(bitmap);
			
			//up
			if(container.stage.contains(popupObject))
				container.stage.removeChild(popupObject);
			
			container.stage.addChild(popupObject);
			
			TweenPlugin.activate([AutoAlphaPlugin, BlurFilterPlugin]);
			popupObject.alpha = 0;
			TweenLite.to(popupObject, .5, {autoAlpha:1});
			
			popupObject.mouseEnabled = true;
			
			var _listener:Function = function(e:Event):void
			{
				e.target.removeEventListener(Event.REMOVED_FROM_STAGE, _listener);
				activate();
			}
			popupObject.addEventListener(Event.REMOVED_FROM_STAGE, _listener);
			
			// deactivate
			try{
				container.mouseChildren = false;
				container.mouseEnabled = false;
			}catch(e:*){
				//stage!
			}
			
			currentPopup = popupObject;
			PopupUtil.container = container;
		}
		
		public static function dispose():void
		{
			//down
			init(currentPopup);
			
			activate();
		}
		
		public static function activate():void
		{
			// activate
			if(container)
			{
				try{
					container.mouseChildren = true;
					container.mouseEnabled = true;
				}catch(e:*){
					//stage!
				}
			}
			
			currentPopup = null;
			
			if(bitmap && bitmap.parent.contains(bitmap))
			{
				TweenPlugin.activate([AutoAlphaPlugin, BlurFilterPlugin]);
				TweenLite.to(bitmap, .5, {autoAlpha:0, blurFilter:{blurX:0, blurY:0}, onComplete:function():void{
					bitmap.parent.removeChild(bitmap);
					bitmap.destroy();
					bitmap = null;
				}});
			}
		}
	}
}
package com.sleepydesign.display
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class PopupUtil
	{
		private static var bitmap:SDBitmap;
		private static var container:DisplayObjectContainer;
		private static var currentPopup:DisplayObjectContainer;
		
		public static function init(popupObject:DisplayObjectContainer):void
		{
			if(!popupObject)
				return;
			
			TweenLite.killTweensOf(popupObject);
			
			//down
			if(popupObject.parent && popupObject.parent.contains(popupObject))
				popupObject.parent.removeChild(popupObject);
			
			popupObject.visible = false;
			popupObject.alpha = 0;
			popupObject.mouseEnabled = false;
		}
		
		public static function popup(container:DisplayObjectContainer, popupObject:DisplayObjectContainer):void
		{
			if(currentPopup == popupObject)
				return;
			
			//down
			init(popupObject);
			
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
			TweenLite.to(popupObject, .5, {autoAlpha:1});
			
			popupObject.mouseEnabled = true;
			
			var _listener:Function = function(e:Event):void
			{
				e.target.removeEventListener(Event.REMOVED_FROM_STAGE, _listener);
				_listener = null;
				destroy();
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
		
		public static function popdown(handler:Function = null):void
		{
			if(!currentPopup)
				return;
			
			currentPopup.mouseEnabled = false;
			
			TweenPlugin.activate([AutoAlphaPlugin, BlurFilterPlugin]);
			TweenLite.to(bitmap, .25, {autoAlpha:0, blurFilter:{blurX:0, blurY:0}});
			TweenLite.to(currentPopup, .25, {autoAlpha:0, onComplete:popdownComplete, onCompleteParams:[handler]});
		}
		
		public static function popdownComplete(handler:Function):void
		{
			if(handler is Function)
				handler();
			destroy();
		}
		
		public static function destroy():void
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
			
			if(bitmap && bitmap.parent && bitmap.parent.contains(bitmap))
			{
				TweenLite.killTweensOf(bitmap);
				TweenPlugin.activate([AutoAlphaPlugin, BlurFilterPlugin]);
				var _bitmap:SDBitmap = bitmap;
				TweenLite.to(_bitmap, .5, {autoAlpha:0, blurFilter:{blurX:0, blurY:0}, onComplete:function():void{
					_bitmap.parent.removeChild(_bitmap);
					_bitmap.destroy();
					_bitmap = bitmap = null;
				}});
			}
			
			currentPopup = null;
		}
	}
}
package com.sleepydesign.display
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.sleepydesign.core.ITransitionable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class PopupUtil
	{
		private static var bitmap:Bitmap;
		private static var container:DisplayObjectContainer;
		private static var currentPopup:DisplayObjectContainer;
		
		private static var _handler:Function;
		
		private static var _tweenObject:Object = {};

		public static function init(popupObject:DisplayObjectContainer):void
		{
			if (!popupObject)
				return;

			TweenLite.killTweensOf(popupObject);

			//down
			if (popupObject.parent && popupObject.parent.contains(popupObject))
				popupObject.parent.removeChild(popupObject);

			popupObject.visible = false;
			popupObject.alpha = 0;
			popupObject.mouseEnabled = false;
		}

		public static function popup(container:DisplayObjectContainer, popupObject:DisplayObjectContainer, handler:Function = null):void
		{
			if (currentPopup == popupObject)
				return;
			
			_handler = handler;

			//down
			init(popupObject);

			// deactivate
			var _rect:Rectangle;
			if (container.stage.scrollRect)
				_rect = container.stage.scrollRect;
			else
				_rect = new Rectangle(0, 0, container.stage.stageWidth, container.stage.stageHeight); //container.stage.getRect(container.stage);

			bitmap = BitmapUtil.getBitmap(container.stage, false, _rect); //new SDBitmap(new BitmapData(_rect.width, _rect.height, true, 0x00000000));
			//bitmap.bitmapData.draw(container.stage);
			TweenLite.to(bitmap, .5, {blurFilter: {blurX: 8, blurY: 8}});
			container.stage.addChild(bitmap);

			//up
			if (container.stage.contains(popupObject))
				container.stage.removeChild(popupObject);

			container.stage.addChild(popupObject);

			TweenPlugin.activate([AutoAlphaPlugin, BlurFilterPlugin]);
			
			if(popupObject is ITransitionable)
				ITransitionable(popupObject).show();
			else
				TweenLite.to(popupObject, .5, {autoAlpha: 1});

			popupObject.mouseEnabled = true;

			var _listener:Function = function(e:Event):void
			{
				e.target.removeEventListener(Event.REMOVED_FROM_STAGE, _listener);
				_listener = null;
				destroy();
			}
			popupObject.addEventListener(Event.REMOVED_FROM_STAGE, _listener);

			// deactivate
			try
			{
				container.mouseChildren = false;
				container.mouseEnabled = false;
			}
			catch (e:*)
			{
				//stage!
			}

			currentPopup = popupObject;
			PopupUtil.container = container;
		}

		public static function popdown(handler:Function = null):void
		{
			if (!currentPopup)
				return;

			currentPopup.mouseEnabled = false;

			TweenPlugin.activate([AutoAlphaPlugin, BlurFilterPlugin]);
			TweenLite.to(bitmap, .25, {autoAlpha: 0, blurFilter: {blurX: 0, blurY: 0}});
			
			if(currentPopup is ITransitionable)
			{
				ITransitionable(currentPopup).hide();
			}else{
				TweenLite.to(currentPopup, .25, {autoAlpha: 0});
			}
			
			TweenLite.to(_tweenObject, .25, {onComplete: popdownComplete, onCompleteParams: [handler]});
		}

		public static function popdownComplete(handler:Function):void
		{
			if (handler is Function)
				handler();
			
			if (_handler is Function)
				_handler();
			
			destroy();
		}

		public static function destroy():void
		{
			// activate
			if (container)
			{
				try
				{
					container.mouseChildren = true;
					container.mouseEnabled = true;
				}
				catch (e:*)
				{
					//stage!
				}
			}
			
			TweenLite.killTweensOf(_tweenObject);

			if (bitmap && bitmap.parent && bitmap.parent.contains(bitmap))
			{
				TweenLite.killTweensOf(bitmap);
				TweenPlugin.activate([AutoAlphaPlugin, BlurFilterPlugin]);
				var _bitmap:Bitmap = bitmap;
				TweenLite.to(_bitmap, .5, {autoAlpha: 0, blurFilter: {blurX: 0, blurY: 0}, onComplete: function():void
						{
							_bitmap.parent.removeChild(_bitmap);
							//_bitmap.destroy();
							_bitmap = bitmap = null;
						}});
			}

			currentPopup = null;
		}
	}
}
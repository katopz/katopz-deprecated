package com.sleepydesign.display
{
	import com.sleepydesign.net.LoaderUtil;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	import org.osflash.signals.Signal;

	public class AssetUtil
	{
		private static var _getDefinitions:Dictionary = new Dictionary(true);

		// from external swf
		public static function loadSWF(path:String, groupID:String, version:String = null, eventHandler:Function = null):void
		{
			// cached
			if (_getDefinitions[groupID])
			{
				eventHandler();
			}
			else
			{
				var uri:String = path + groupID + ".swf" + (version ? "?v=" + version : "");
				LoaderUtil.loadBinary(uri, function(event:Event):void
				{
					eventHandler(event);

					if (event.type != Event.COMPLETE)
						return;

					registerDefinition(groupID, event.target.data).addOnce(eventHandler);
				});
			}
		}

		public static function getClass(groupID:String, assetID:String):Class
		{
			if (!(_getDefinitions[groupID] is Function))
				throw new Error('Must loadSWF or loadEmbedSWF before call getDefinition');

			try
			{
				return _getDefinitions[groupID](assetID) as Class;
			}
			catch (e:*)
			{
				throw new Error(e);
			}

			return null;
		}

		public static function getDisplayObject(groupID:String, assetID:String):DisplayObject
		{
			return new (AssetUtil.getClass(groupID, assetID)) as DisplayObject;
		}

		public static function getSprite(groupID:String, assetID:String):Sprite
		{
			return getDisplayObject(groupID, assetID) as Sprite;
		}

		public static function getMovieClip(groupID:String, assetID:String):MovieClip
		{
			return getDisplayObject(groupID, assetID) as MovieClip;
		}

		public static function registerDefinition(groupID:String, byteArray:ByteArray):Signal
		{
			var loader:Loader = new Loader();
			var handler:Function;
			var signal:Signal;

			signal = new Signal();

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handler = function(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handler);
				_getDefinitions[groupID] = LoaderInfo(e.currentTarget).applicationDomain.getDefinition;
				signal.dispatch();
			});

			loader.loadBytes(byteArray, new LoaderContext(false, ApplicationDomain.currentDomain));

			return signal;
		}

		// from embed swf
		public static function loadEmbedSWF(groupClass:Class, groupID:String):Signal
		{
			return loadClass(groupClass, groupID);
		}

		private static function loadClass(assets:Class, groupID:String, assetID:String = null, typeClass:Class = null):Signal
		{
			var loader:Loader = new Loader();
			var handler:Function;
			var signal:Signal;

			if (typeClass)
				signal = new Signal(typeClass);
			else
				signal = new Signal();

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handler = function(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handler);
				_getDefinitions[groupID] = LoaderInfo(e.currentTarget).applicationDomain.getDefinition;
				if (assetID && signal.valueClasses.length > 0)
				{
					if (describeType(signal.valueClasses[0]) == describeType(typeClass))
					{
						var clazz:Class = _getDefinitions[groupID](assetID) as Class;
						signal.dispatch(new clazz as typeClass);
					}
				}
				else
				{
					signal.dispatch();
				}
			});

			loader.loadBytes(new assets as ByteArray, new LoaderContext(false, ApplicationDomain.currentDomain));

			return signal;
		}

		private static function loadBytes(byteArray:ByteArray, id:String = null, typeClass:Class = null):Signal
		{
			var loader:Loader = new Loader();
			var handler:Function;
			var signal:Signal;

			if (id)
			{
				if (!typeClass)
					typeClass = Class;

				signal = new Signal(typeClass);
			}
			else
				signal = new Signal();

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handler = function(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handler);
				var getDefinitions:Function = LoaderInfo(e.currentTarget).applicationDomain.getDefinition;
				var clazz:Class;

				if (signal.valueClasses.length > 0)
				{
					if (describeType(signal.valueClasses[0]) == describeType(typeClass))
					{
						clazz = getDefinitions(id) as Class;
						signal.dispatch(clazz);
					}
				}
				else
				{
					signal.dispatch();
				}
			});

			loader.loadBytes(byteArray, new LoaderContext(false, ApplicationDomain.currentDomain));

			return signal;
		}
	}
}

package com.sleepydesign.display
{
	import com.sleepydesign.net.LoaderUtil;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	import org.osflash.signals.Signal;

	/**
	 * Must loadDefinition first.
	 * @author katopz
	 */
	public class AssetsUtil
	{
		private static var _getDefinitions:Dictionary = new Dictionary(true);

		public static function registerDefinition(classID:String, byteArray:ByteArray):Signal
		{
			var loader:Loader = new Loader();
			var handler:Function;
			var signal:Signal;

			signal = new Signal();

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handler = function(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handler);
				_getDefinitions[classID] = LoaderInfo(e.currentTarget).applicationDomain.getDefinition;
				signal.dispatch();
			});

			loader.loadBytes(byteArray, new LoaderContext(false, ApplicationDomain.currentDomain));

			return signal;
		}

		public static function loadDefinition(assets:Class, classID:String):Signal
		{
			return loadClass(assets, classID);
		}

		public static function loadDisplayObject(assets:Class, classID:String, assetID:String):Signal
		{
			return loadClass(assets, classID, assetID, DisplayObject);
		}

		private static function loadClass(assets:Class, classID:String, assetID:String = null, typeClass:Class = null):Signal
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
				_getDefinitions[classID] = LoaderInfo(e.currentTarget).applicationDomain.getDefinition;
				if (assetID && signal.valueClasses.length > 0)
				{
					if (describeType(signal.valueClasses[0]) == describeType(typeClass))
					{
						var clazz:Class = _getDefinitions[classID](assetID) as Class;
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

		public static function loadBytes(byteArray:ByteArray, id:String = null, typeClass:Class = null):Signal
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

		public static function getDefinition(classID:String, assetID:String):Class
		{
			if (!(_getDefinitions[classID] is Function))
				throw new Error('Must loadDefinition before call getDefinition');

			try
			{
				return _getDefinitions[classID](assetID) as Class;
			}
			catch (e:*)
			{
				throw new Error(e);
			}

			return null;
		}
	}
}
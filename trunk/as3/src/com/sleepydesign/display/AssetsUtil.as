package com.sleepydesign.display
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.describeType;

	import org.osflash.signals.Signal;

	/**
	 * Must loadDefinition first.
	 * @author katopz
	 */
	public class AssetsUtil
	{
		private static var _getDefinition:Function;

		/**
		 *
		 * [Embed(source="assets.swf", mimeType="application/octet-stream")]
		 * var Assets:Class;
		 * AssetsUtil.loadDefinition(Assets).addOnce(function ():void
		 * {
		 *		var crystalClip:Class = AssetsUtil.getAsset("AnyClip")as Class;
		 * 		addChild(new crystalClip as DisplayObject);
		 * });
		 *
		 * @param Assets
		 * @return
		 *
		 */
		public static function loadDefinition(Assets:Class):Signal
		{
			return loadClassAsset(Assets);
		}

		public static function loadDisplayObject(Assets:Class, id:String):Signal
		{
			return loadClassAsset(Assets, id, DisplayObject);
		}

		private static function loadClassAsset(Assets:Class, id:String = null, typeClass:Class = null):Signal
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
				_getDefinition = LoaderInfo(e.currentTarget).applicationDomain.getDefinition;
				if (signal.valueClasses.length > 0)
				{
					if (describeType(signal.valueClasses[0]) == describeType(typeClass))
					{
						var _Class:Class = getAssetClass(id);
						signal.dispatch(new _Class as typeClass);
					}
				}
				else
				{
					signal.dispatch();
				}
			});

			loader.loadBytes(new Assets as ByteArray, new LoaderContext(false, ApplicationDomain.currentDomain));

			return signal;
		}

		public static function loadBytesAsset(byteArray:ByteArray, id:String = null):Signal
		{
			var loader:Loader = new Loader();
			var handler:Function;
			var signal:Signal = new Signal(Class);

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handler = function(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handler);
				_getDefinition = LoaderInfo(e.currentTarget).applicationDomain.getDefinition;
				signal.dispatch(getAssetClass(id));
			});

			loader.loadBytes(byteArray, new LoaderContext(false, ApplicationDomain.currentDomain));

			return signal;
		}

		public static function getAssetClass(id:String):Class
		{
			if (!(_getDefinition is Function))
				throw new Error('Must loadDefinition before call getAssetClass');

			try
			{
				return _getDefinition(id) as Class;
			}
			catch (e:*)
			{
				throw new Error(e);
			}

			return null;
		}

	/*
	public static function getDisplayObject(id:String):DisplayObject
	{
		var _Class:Class = getAsset(id);
		return new _Class as DisplayObject;
	}
	*/
	}
}
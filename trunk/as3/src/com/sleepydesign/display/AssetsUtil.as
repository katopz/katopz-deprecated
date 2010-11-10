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
			return load(Assets, new Signal);
		}
		
		public static function loadDisplayObject(Assets:Class, id:String):Signal
		{
			return load(Assets, new Signal(DisplayObject), id);
		}
		
		private static function load(Assets:Class, signal:Signal, id:String = null):Signal
		{
			var loader:Loader = new Loader();
			var handler:Function;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handler = function onAssetLoaderComplete(e:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handler);
				_getDefinition = LoaderInfo(e.currentTarget).applicationDomain.getDefinition;
				if(signal.valueClasses.length>0)
				{
					var xml:XML = describeType(signal.valueClasses[0]);
					var s:String = xml["factory"].@type.toString();
					if(s == "flash.display::DisplayObject")
						signal.dispatch(getDisplayObject(id));
				}else{
					signal.dispatch();
				}
			});
			
			loader.loadBytes(new Assets as ByteArray, new LoaderContext(false, ApplicationDomain.currentDomain));
			
			return signal;
		}

		public static function getAsset(id:String):Class
		{
			if(!(_getDefinition is Function))
				throw new Error('Must loadDefinition before call getAsset.');
			
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
		
		public static function getDisplayObject(id:String):DisplayObject
		{
			var _Class:Class = getAsset(id);
			return new _Class as DisplayObject;
		}
	}
}
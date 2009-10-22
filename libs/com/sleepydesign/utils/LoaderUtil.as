package com.sleepydesign.utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;	
	
	/**
	 * @example
	 * 
	 * 	just load		: LoaderUtil.load("test.jpg", trace);
	 * 	load as bitmap	: LoaderUtil.loadAsset("test.jpg", trace);
	 * 	load as binary	: LoaderUtil.loadBinary("test.jpg", trace);
	 * 
	 * @author	katopz
	 */	
	public class LoaderUtil
	{
		public static function saveBinary(data:ByteArray, uri:String, eventHandler:Function = null):URLLoader
		{
			var imageloader:URLLoader = new URLLoader();
			imageloader.dataFormat = URLLoaderDataFormat.BINARY;
			imageloader.addEventListener(Event.COMPLETE, eventHandler);
			
			var request:URLRequest = new URLRequest(uri);
			request.contentType = "image/png";
			request.method = URLRequestMethod.POST;
			request.data = data;
			
			imageloader.load(request);
			
			return imageloader;
		}
		
		public static function loadBytes(byteArray:ByteArray, eventHandler:Function = null):Loader
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, eventHandler, false, 0, true);
			loader.loadBytes(byteArray);
			return loader;
		}
		
		public static function loadAsset(uri:String, eventHandler:Function = null):Loader
		{
			return load(uri, eventHandler, "asset") as Loader;
		}
		
		public static function loadBinary(uri:String, eventHandler:Function = null):URLLoader
		{
			return load(uri, eventHandler, URLLoaderDataFormat.BINARY) as URLLoader;
		}
		
		public static function load(uri:String, eventHandler:Function = null, type:String = "auto"):Object
		{
			// select type
			if(type=="auto")
			switch(getType(uri))
			{
				case "jpg":
				case "png":
				case "gif":
				case "swf":
					type="asset";
				break;
				case "text":
				case "json":
				case "xml":
					type=URLLoaderDataFormat.TEXT;
				break;
				default :
					type=URLLoaderDataFormat.BINARY;
				break;
			}
			
			trace(" ! Load as : " +type);
			
			// select loader
			var _loader:*;
			if(type=="asset")
			{
				//The Loader class is used to load SWF files or image (JPG, PNG, or GIF) files. 
				//Use the load() method to initiate loading. The loaded display object is added as a child of the Loader object. 
				var loader:Loader = new Loader();
				_loader = loader.contentLoaderInfo;
			}else{
				//The URLLoader class downloads data from a URL as text, binary data, or URL-encoded variables. 
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat = type;
				_loader = urlLoader;
			}
			
			// callback
			if(eventHandler!=null)
			{
				_loader.addEventListener(Event.COMPLETE, eventHandler, false, 0, true);
	            _loader.addEventListener(ProgressEvent.PROGRESS, eventHandler, false, 0, true);
	            
	            _loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler, false, 0, true);
	            _loader.addEventListener(IOErrorEvent.IO_ERROR, eventHandler, false, 0, true);
	            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler, false, 0, true);
	  		}
            
            // gc
			_loader.addEventListener(Event.COMPLETE, function():void
			{
			    _loader.removeEventListener(Event.COMPLETE, eventHandler);
			    _loader.removeEventListener(ProgressEvent.PROGRESS, eventHandler);
			    
			    _loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler);
	            _loader.removeEventListener(IOErrorEvent.IO_ERROR, eventHandler);
	            _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
			}, false, 0, true);
			
			// load
			try
			{
				if(type=="asset")
				{
					loader.load(new URLRequest(uri), new LoaderContext(false, ApplicationDomain.currentDomain));
					return loader;
				}else{
					urlLoader.load(new URLRequest(uri));
					return urlLoader;
				}
			}catch (e:Error)
			{
				trace(" ! Error in loading file (" + uri + "): \n" + e.message + "\n" + e.getStackTrace());
			}
			return null;
		}
		
		public static function getType(value:String):String
		{
			//file.something.type?q#a
			value = value.split("#")[0];
			//file.something.type?q
			value = value.split("?")[0];
			//file.something.type
			var results:Array = value.split(".");
			//type
			return results[results.length - 1];
		}
	}
}
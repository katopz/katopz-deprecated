package com.sleepydesign.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
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
		public static var SEND_METHOD:String = URLRequestMethod.POST;
		
		public static var showLoader:Function;
		public static var hideLoader:Function;
		
		public static var loaderClip:DisplayObject;
		
		public static function addLoaderTo(parent:DisplayObjectContainer, loaderClip:DisplayObject, show:Boolean=true):void
		{
			if(show)
			{
				if(!loaderClip.parent && parent)
					parent.addChild(loaderClip);
				
				loaderClip.visible = true;
				loaderClip.x = parent.stage.stageWidth/2;
				loaderClip.y = parent.stage.stageHeight/2;
			}else{
				loaderClip.visible = false;
			}
			
			LoaderUtil.loaderClip = loaderClip;
		}
				
		public static function saveJPG(data:ByteArray, uri:String, eventHandler:Function = null):URLLoader
		{
			return saveBinary(data, uri, eventHandler, "image/jpeg");
		}
		
		public static function savePNG(data:ByteArray, uri:String, eventHandler:Function = null):URLLoader
		{
			return saveBinary(data, uri, eventHandler, "image/png");
		}
		
		public static function saveBinary(data:ByteArray, uri:String, eventHandler:Function = null, contentType:String = "application/octet-stream"):URLLoader
		{
			var _loader:URLLoader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(Event.COMPLETE, eventHandler);
			
			var request:URLRequest = new URLRequest(uri);
			request.contentType = contentType;
			request.method = URLRequestMethod.POST;
			request.data = data;
			
			_loader.load(request);
			
			return _loader;
		}
				
		/**
		 * Load as ByteArray
		 * @param byteArray
		 * @param eventHandler
		 * @return Loader
		 */		
		public static function loadBytes(byteArray:ByteArray, eventHandler:Function = null):Loader
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, eventHandler);
			loader.loadBytes(byteArray);
			return loader;
		}
		
		/**
		 * Load as URLVariables
		 * @param uri
		 * @param eventHandler
		 * @return URLLoader
		 */		
		public static function loadVars(uri:String, eventHandler:Function):URLLoader
		{
			return load(uri, function(event:Event):void
			{
				if(event.type=="complete")
					event.target["data"] = new URLVariables(String(event.target["data"]));
				
				eventHandler(event);
			}, URLLoaderDataFormat.TEXT) as URLLoader;
		}
		
		/**
		 * Load as XML
		 * @param uri
		 * @param eventHandler
		 * @return URLLoader
		 */		
		public static function loadXML(uri:String, eventHandler:Function = null):URLLoader
		{
			return load(uri, function(event:Event):void
			{
				if(event.type=="complete")
					event.target["data"] = new XML(event.target["data"]);
				
				eventHandler(event);
			} , "xml") as URLLoader;
		}
		
		/**
		 * Load as Image type
		 * @param uri
		 * @param eventHandler
		 * @return Loader
		 */
		public static function loadAsset(uri:String, eventHandler:Function = null):Loader
		{
			return load(uri, eventHandler, "asset") as Loader;
		}
		
		/**
		 * Load as Binary type
		 * @param uri
		 * @param eventHandler
		 * @return URLLoader
		 */		
		public static function loadBinary(uri:String, eventHandler:Function = null):URLLoader
		{
			return load(uri, eventHandler, URLLoaderDataFormat.BINARY) as URLLoader;
		}
		
		public static function loadCompress(uri:String, eventHandler:Function = null):URLLoader
		{
			return load(uri, function(event:Event):void
			{
				if(event.type=="complete")
				{
					event.target["data"] = ByteArray(event.target["data"]);
					ByteArray(event.target["data"]).uncompress();
				}
				
				eventHandler(event);
			} , URLLoaderDataFormat.BINARY) as URLLoader;
		}
		
		public static var loaders:Array = [];
		
		/**
		 * Just load
		 * @param uri
		 * @param eventHandler
		 * @param type
		 * @return Loader, URLLoader
		 */		
		public static function load(uri:String, eventHandler:Function = null, type:String = "auto", urlRequest:URLRequest=null):Object
		{
			if(loaderClip && showLoader is Function)
				showLoader();
			
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
				case "asp":
				case "php":
				case "text":
				case "json":
				case "xml":
					type=URLLoaderDataFormat.TEXT;
				break;
				default :
					type=URLLoaderDataFormat.BINARY;
				break;
			}
			
			trace(" ! Load ["+type+"] : "+ uri);
			
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
			
			// prevent gc
			loaders.push(_loader);
			
			// callback
			if(eventHandler is Function)
			{
				_loader.addEventListener(Event.COMPLETE, eventHandler);
	            _loader.addEventListener(ProgressEvent.PROGRESS, eventHandler);
	            
	            _loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler);
	            _loader.addEventListener(IOErrorEvent.IO_ERROR, eventHandler);
	            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
            
	            // gc
				_loader.addEventListener(Event.COMPLETE, function():void
				{
				    _loader.removeEventListener(Event.COMPLETE, eventHandler);
				    _loader.removeEventListener(ProgressEvent.PROGRESS, eventHandler);
				    
				    _loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler);
		            _loader.removeEventListener(IOErrorEvent.IO_ERROR, eventHandler);
		            _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
		            
		            if(loaderClip && hideLoader is Function)
						hideLoader();
		            
		            // gc
		            removeItem(loaders, _loader);
				});
			}
			
			// load
			try
			{
				urlRequest = urlRequest?urlRequest:new URLRequest(uri);
				if(type=="asset")
				{
					loader.load(urlRequest, new LoaderContext(false, ApplicationDomain.currentDomain));
					return loader;
				}else{
					urlLoader.load(urlRequest);
					return urlLoader;
				}
			}catch (e:Error)
			{
				trace(" ! Error in loading file (" + uri + "): \n" + e.message + "\n" + e.getStackTrace());
			}
			return null;
		}
		
		public static function request(uri:String, data:*, eventHandler:Function = null, type:String = "auto"):Object
		{
			var _urlRequest:URLRequest = new URLRequest(uri);
			_urlRequest.method = SEND_METHOD;
			_urlRequest.data = data;
			
			ObjectUtil.print(_urlRequest.data);
			
			return load(uri, eventHandler, type, _urlRequest);
		}
		
		public static function requestVars(uri:String, data:*, eventHandler:Function):URLLoader
		{
			return request(uri, data,  function(event:Event):void
			{
				if(event.type=="complete")
					event.target["data"] = new URLVariables(String(event.target["data"]));
				
				eventHandler(event);
			}, URLLoaderDataFormat.TEXT) as URLLoader;
		}
		
		public static function requestXML(uri:String, data:*, eventHandler:Function):URLLoader
		{
			return request(uri, data,  function(event:Event):void
			{
				if(event.type=="complete")
					event.target["data"] = new XML(String(event.target["data"]));
				
				eventHandler(event);
			}, URLLoaderDataFormat.TEXT) as URLLoader;
		}
		
		/**
		 * Get type of file URI
		 * @param value
		 * @return type of file URI
		 */		
		private static function getType(value:String):String
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
		
		private static function removeItem(tarArray:Array, item:*):uint 
		{
			var i:int  = tarArray.indexOf(item);
			var f:uint = 0;
			
			while (i != -1) {
				tarArray.splice(i, 1);
				
				i = tarArray.indexOf(item, i);
				
				f++;
			}
			
			return f;
		}
	}
}
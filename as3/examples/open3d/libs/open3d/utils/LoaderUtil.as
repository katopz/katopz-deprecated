package open3d.utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;	
	
	public class LoaderUtil
	{
		public static function load(uri:String, onLoad:Function = null, dataFormat:String = "binary"):Object
		{
			if(uri.lastIndexOf(".jpg")==uri.length-4 || uri.lastIndexOf(".png")==uri.length-4)
			{
				dataFormat = "bitmap";
			}
			
			if(dataFormat=="binary")
			{
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat = dataFormat;
				
			    urlLoader.addEventListener(ProgressEvent.PROGRESS, onLoad, false, 0, true);
	            urlLoader.addEventListener(Event.COMPLETE, onLoad, false, 0, true);
	            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoad, false, 0, true);
	            urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onLoad, false, 0, true);
	            urlLoader.addEventListener(Event.OPEN, onLoad, false, 0, true);
	            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoad, false, 0, true);
				
				urlLoader.addEventListener(Event.COMPLETE, function():void
				{
				    urlLoader.removeEventListener(ProgressEvent.PROGRESS, onLoad);
		            urlLoader.removeEventListener(Event.COMPLETE, onLoad);
		            urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoad);
		            urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onLoad);
		            urlLoader.removeEventListener(Event.OPEN, onLoad);
		            urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoad);
		            try{urlLoader.close();}catch (e:Error){};
				}, false, 0, true);
				
				try
				{
					urlLoader.load(new URLRequest(uri));
				}
				catch (e:Error)
				{
					trace(" ! Error in loading file (" + uri + "): \n" + e.message + "\n" + e.getStackTrace());
				}
				return urlLoader;
			}else{
				var loader:Loader = new Loader();
				
			    loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoad, false, 0, true);
	            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad, false, 0, true);
	            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoad, false, 0, true);
	            loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onLoad, false, 0, true);
	            loader.contentLoaderInfo.addEventListener(Event.OPEN, onLoad, false, 0, true);
	            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoad, false, 0, true);
				
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void
				{
				    loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoad, false, 0, true);
		            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad, false, 0, true);
		            loader.contentLoaderInfo.addEventListener(Event.INIT, onLoad, false, 0, true);
		            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoad, false, 100, true);
		            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoad, false, 0, true);
		            loader.contentLoaderInfo.addEventListener(Event.OPEN, onLoad, false, 0, true);  
		            loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onLoad, false, 0, true);
		            try{loader.close();}catch (e:Error){};
				}, false, 0, true);
				
				try
				{
					loader.load(new URLRequest(uri));
				}
				catch (e:Error)
				{
					trace(" ! Error in loading file (" + uri + "): \n" + e.message + "\n" + e.getStackTrace());
				}
				return loader;
			}
		}
	}
}
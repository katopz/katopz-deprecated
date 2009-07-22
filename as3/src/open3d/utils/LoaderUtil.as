package open3d.utils
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;	
	
	public class LoaderUtil
	{
		public static function load(uri:String, onLoad:Function = null, dataFormat:String = "binary"):URLLoader
		{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = dataFormat;
			
		    loader.addEventListener(ProgressEvent.PROGRESS, onLoad, false, 0, true);
            loader.addEventListener(Event.COMPLETE, onLoad, false, 0, true);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onLoad, false, 0, true);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onLoad, false, 0, true);
            loader.addEventListener(Event.OPEN, onLoad, false, 0, true);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoad, false, 0, true);
			
			loader.addEventListener(Event.COMPLETE, function():void
			{
			    loader.removeEventListener(ProgressEvent.PROGRESS, onLoad);
	            loader.removeEventListener(Event.COMPLETE, onLoad);
	            loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoad);
	            loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onLoad);
	            loader.removeEventListener(Event.OPEN, onLoad);
	            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoad);
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
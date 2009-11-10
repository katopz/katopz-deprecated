/**
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.utils {
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.display.LoaderInfo;
	import flash.external.ExternalInterface;
	
	public class URLUtil {
		
		/*
		public static function cacheKiller(dataSrc) {
			var myUrl = "";
			if (unescape(_level0._url).indexOf("http://")==0) {
				var myDate = new Date();
				if (dataSrc.indexOf("?") == -1) {
					myUrl = dataSrc+"?";
				} else {
					myUrl = dataSrc+"&";
				}
				myUrl = myUrl+"cacheKiller="+myDate.getTime();
				trace("cacheKiller : "+myUrl);
			} else {
				myUrl = dataSrc;
			}
			//hack tracking		
			tracking(escape(myUrl));
			myUrl = unescape(myUrl);
			trace("noCache : "+_level0.noCache);
			trace("url : "+myUrl);
			return myUrl;
		}
		*/
		/*
		TODO internal class
		public static function Debug(dispatcher:IEventDispatcher):void{
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(Event.INIT, initHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
        }

        private function completeHandler(event:Event):void {
            trace("completeHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }

        private function initHandler(event:Event):void {
            trace("initHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
        }

        private function openHandler(event:Event):void {
            trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
        }

        private function unLoadHandler(event:Event):void {
            trace("unLoadHandler: " + event);
        }

		}
		*/
		/*
		public static function isSelf(iPath:String):Boolean{
			
			//TODO RegExp
			var loaderInfo:LoaderInfo = new LoaderInfo();
			
			return (unescape(loaderInfo.loaderURL).indexOf(iPath)>-1)
		}
		*/
		public static function killCache(dataSrc) {
			var myUrl = "";
			
			if (unescape(dataSrc).indexOf("http://")==0) {
				var myDate = new Date();
				if (dataSrc.indexOf("?") == -1) {
					myUrl = dataSrc+"?";
				} else {
					myUrl = dataSrc+"&";
				}
				myUrl = myUrl+"cacheKiller="+myDate.getTime();
			} else {
				myUrl = dataSrc;
			}
			
			myUrl = unescape(myUrl);
			
			trace("url : "+myUrl);
			
			return myUrl;
		}
		
		public static function getCurrentURL() {
			return String(ExternalInterface.call("window.location.href.toString"));
		}
		
		public static function isOnline(content) {
			return (content.loaderInfo.loaderURL.indexOf("http://")==0)
		}
		
		public static function goToURL(iURL:String, window:String = "_self") {
			if (String(window).length==0) {
				window = "_self";
			}
			//loaderInfo.loaderURL
			/*
			var loaderInfo:LoaderInfo = new LoaderInfo();
			if(loaderInfo.loaderURL.indexOf("file:")==0){
				trace("Offine Sandbox : "+iURL)
			}else{
				navigateToURL(new URLRequest(iURL), window);
			}
			*/
			navigateToURL(new URLRequest(iURL), window);
		}
		
	}
	
}

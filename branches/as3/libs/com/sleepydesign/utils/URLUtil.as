/**
* @author katopz@sleepydesign.com
* @version 0.2
*/

package com.sleepydesign.utils {
	
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class URLUtil 
	{
		public static function getFileName(value:String):String
		{
			var result:String;
			if (value.indexOf("?") == -1) 
			{
				result = value.split("#")[0];
			}else{
				result = value.split("?")[0];
			}
			result = result.substr(result.lastIndexOf("/")+1);
			if(result.indexOf("//")>-1)
				result = result.substr(result.lastIndexOf("//")+1);
			var results:Array = result.split(".");
			return results[0];
		} 
		
		public static function getType(value:String):String 
		{
			var result:String;
			if (value.indexOf("?") == -1) 
			{
				result = value.split("#")[0];
			}else{
				result = value.split("?")[0];
			}
			var results:Array = result.split(".");
			return results[results.length-1];
		}
		
		public static function killCache(value:String):String 
		{
			var result:String = "";
			
			if (unescape(value).indexOf("http://")==0 || SystemUtil.isBrowser()) 
			{
				var myDate:Date = new Date();
				if (value.indexOf("?") == -1) 
				{
					result = value+"?";
				} else {
					result = value+"&";
				}
				result = result+"nocat="+myDate.getTime();
			} else {
				result = value;
			}
			
			result = unescape(result);
			
			trace(" * killCache\t: "+result);
			
			return result;
		}
		
		public static function getCurrentURL():String 
		{
			if(ExternalInterface.available)
			{
				return String(ExternalInterface.call("window.location.href.toString"));
			}else{
				return "";
			}
		}
		
		public static function isURL(uri:String):Boolean
		{
			return (uri.indexOf("http://")==0 || uri.indexOf("javascript:")==0)
		} 
		
		public static function getURL(uri:String, window:String = "_blank"):void 
		{
			if(uri.indexOf("javascript:")!=0)
			{
				trace(" < html\t: " + uri);
				navigateToURL(new URLRequest(uri), window);
			}else {
	        	if(SystemUtil.isBrowser())
	        	{
	        		navigateToURL(new URLRequest(uri), "_self");
	        	}else{
	        		trace(" < javascript\t: " + uri);
	        	}
			}
		}
	}
}

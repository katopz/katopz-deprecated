package com.sleepydesign.net
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;

	public class URLUtil
	{
		public static function getURL(url:String, window:String = "_blank"):void
		{
			if (url.indexOf("javascript:") != 0)
			{
				trace(" < html\t: " + url);
				navigateToURL(new URLRequest(url), window);
			}
			else
			{
				if (Capabilities.playerType != "StandAlone" && Capabilities.playerType != "External")
				{
					navigateToURL(new URLRequest(url), "_self");
				}
				else
				{
					trace(" < javascript\t: " + url);
				}
			}
		}

		public static function isURL(url:String):Boolean
		{
			return (url.indexOf("http://") == 0 || url.indexOf("javascript:") == 0)
		}
		
		public static function killCache(value:String, isNeed:Boolean = false):String
		{
			var result:String = "";

			if (unescape(value).indexOf("http://") == 0 || isNeed)
			{
				var myDate:Date = new Date();
				if (value.indexOf("?") == -1)
				{
					result = value + "?";
				}
				else
				{
					result = value + "&";
				}
				result = result + "rev=" + myDate.getTime();
			}
			else
			{
				result = value;
			}

			result = unescape(result);

			//trace(" * killCache\t: " + result);

			return result;
		}
	}
}
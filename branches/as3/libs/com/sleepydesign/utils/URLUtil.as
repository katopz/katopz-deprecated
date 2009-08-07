package com.sleepydesign.utils
{

	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class URLUtil
	{
		public static function link(uri:String, caller:*=null):void
		{
			var src:Array = uri.split(":")
			var protocal:String = src[0];
			var functionString:String = uri.substring(1 + uri.indexOf(":"));
			var functionName:String = functionString.split("(")[0];
			var argumentString:String = functionString.substring(1 + functionString.indexOf("("), functionString.lastIndexOf(")"))
			var argumentArray:Array = argumentString.split(",");
			var argument:*;

			//TODO arguments
			var arg:String = argumentArray[0];
			if ((arg.indexOf("'") == 0) && (arg.lastIndexOf("'") == arg.length - 1))
			{
				//string
				argument = arg.substring(1, arg.length - 1);
			}
			else if ((arg.indexOf('"') == 0) && (arg.lastIndexOf('"') == arg.length - 1))
			{
				//string
				argument = arg.substring(1, arg.length - 1);
			}
			else
			{
				//number
				argument = int(arg);
			}

			switch (protocal)
			{
				case "as":
					if (argumentString.length > 0)
					{
						//custom::[functionName](argument);
						caller[functionName].apply(caller, [argument]);
					}
					else
					{
						//custom::[functionName]();
						caller[functionName].apply(caller);
					}
					break;

				case "js":
					var isExternal:Boolean = false;
					if (argumentString.length > 0)
					{
						isExternal = SystemUtil.callJS(functionName, argument);
					}
					else
					{
						isExternal = SystemUtil.callJS(functionName);
					}
					/*
					   if(!isExternal)
					   {
					   URLUtil.getURL(String(uri));
					   }
					 */
					break;
				case "http":
					URLUtil.getURL(String(uri));
					break;
			}
		}

		public static function getFileName(value:String):String
		{
			var result:String;
			if (value.indexOf("?") == -1)
			{
				result = value.split("#")[0];
			}
			else
			{
				result = value.split("?")[0];
			}
			result = result.substr(result.lastIndexOf("/") + 1);
			if (result.indexOf("//") > -1)
				result = result.substr(result.lastIndexOf("//") + 1);
			var results:Array = result.split(".");
			return results[0];
		}

		public static function getType(value:String):String
		{
			var result:String;
			if (value.indexOf("?") == -1)
			{
				result = value.split("#")[0];
			}
			else
			{
				result = value.split("?")[0];
			}
			var results:Array = result.split(".");
			return results[results.length - 1];
		}

		public static function killCache(value:String):String
		{
			var result:String = "";

			if (unescape(value).indexOf("http://") == 0)
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
				result = result + "nocat=" + myDate.getTime();
			}
			else
			{
				result = value;
			}

			result = unescape(result);

			trace(" * killCache\t: " + result);

			return result;
		}

		public static function getCurrentURL():String
		{
			if (ExternalInterface.available)
			{
				return String(ExternalInterface.call("window.location.href.toString"));
			}
			else
			{
				return "";
			}
		}

		public static function isURL(uri:String):Boolean
		{
			return (uri.indexOf("http://") == 0 || uri.indexOf("javascript:") == 0)
		}

		public static function getURL(uri:String, window:String = "_blank"):void
		{
			if (uri.indexOf("javascript:") != 0)
			{
				trace(" < html\t: " + uri);
				navigateToURL(new URLRequest(uri), window);
			}
			else
			{
				if (SystemUtil.isBrowser())
				{
					navigateToURL(new URLRequest(uri), "_self");
				}
				else
				{
					trace(" < javascript\t: " + uri);
				}
			}
		}
	}
}

package com.sleepydesign.utils
{
	public class StringUtil
	{
		public static function replace(source:String, findString:String, replaceString:String, pattern:String = "g"):String
		{
			return source.split(findString).join(replaceString); 
			//return source.replace(new RegExp(oldString, pattern), newString);
		}

		public static function getDefaultIfNull(newValue:String, defaultValue:String = ""):String
		{
			return !isNull(newValue) ? newValue : defaultValue;
		}
		
		public static function leadingZero(source:*, length:Number = 2):String
		{
			if (isNaN(Number(source)))
				return source;
			source = String(source)
			while (source.length < length)
				source = "0" + source;
			return source;
		}

		public static function newlineToBR(source:String):String
		{
			return source.replace( /\r\n/g, "<br/>");
		}

		public static function toHEX(num:Number):String
		{
			var str:String = "";
			const hex_chr:String = "0123456789abcdef";
			for (var j:int = 5; j >= 0; j--)
				str += hex_chr.charAt((num >> (j * 4)) & 0x0F);
			return "0x" + str.toUpperCase();
		}

		public static function isNull(value:*):Boolean
		{
			if (value is XML)
				value = XML(value).toXMLString();
			value = String(value);
			return (value == null || value == "undefined" || value == "" || value == " ");
		}
	}
}
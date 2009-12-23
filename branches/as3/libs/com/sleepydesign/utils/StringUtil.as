/**
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.utils {
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.display.LoaderInfo;
	
	public class StringUtil 
	{
		private static var hex_chr:String = "0123456789abcdef";
		/*
		public static function replace(source:String, where:String, value:String):String 
		{
			return source.split(where).join(value);
		}
		*/
		
		public static function replace(source:String, oldString:String, newString:String, pattern:String="g"):String 
		{
			return source.replace(new RegExp(oldString, pattern), newString);
		}
		
		public static function add0(source:*, length:Number=2):String 
		{
			if(isNaN(Number(source)))return source;
			source = String(source)
			while (source.length<length) {
				source = "0"+source;
			}
			return source
		}
		
		public static function newlineToBR(source:String):String 
		{
			var myPattern:RegExp = /\r\n/g;  
			return source.replace(myPattern,"<br/>");
		}
		
		public static function hex(num:Number):String
		{
			var str:String = "";
			for (var j:int = 5; j >= 0; j--)
			{
				str += hex_chr.charAt((num >> (j * 4)) & 0x0F);
			}
			return "0x"+str.toUpperCase();
			
		}
		/*
		public static function zeroPrefix(iStr:Object, length:Number=2):String 
		{
			iStr = String(iStr);
			var str:String = "";
			for (var i:int = iStr.length; i<length; i++) {
				str += "0";
			}
			return str+iStr;
		}
		*/
		
		public static function isNull(value:*):Boolean
		{
			if(value is XML)value = XML(value).toXMLString();
			return !validateString(String(value));
		}
		
		//validates string for the message field
		public static function validateString(value:String):Boolean
		{
			if(value == null || value == "undefined" || value == "" || value == " ") return false;
			return true;
		}

		public static function validateNumber(value:String):Boolean
		{
			return !isNaN(Number(value));
		}
		
		// REGEX for phone validation
		public static function validatePhone(value:String):Boolean {
	        var phoneExpression:RegExp = /^((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,3})|(\(?\d{2,3}\)?))(-| )?(\d{3,4})(-| )?(\d{4})(( x| ext)\d{1,5}){0,1}$/i;
        	return ! phoneExpression.test(value);
		}
		
		//validates email fields
		public static function validateEmail(value:String, multipleFields:Boolean = false):Boolean
		{
			var emailPattern:RegExp = /^(([^<>()[\]\\.,;:\s@]+(\.[^<>()[\]\\.,;:\s@]+)*)|(.+))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
			var addresses:Array = [];
			if(multipleFields) addresses = value.split(";");
			var len:uint = addresses.length;	
			if(len > 1)
			{
				for(var i:uint = 0; i < len; i++)
				{
					if(!emailPattern.test(value)) return false;
				}
			}
			else
			{
				if(!emailPattern.test(value)) return false;

			}
			return true;
		}
		/*
// REGEX for email validation
function validateEmail(email:String):Boolean {
        var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
        return ! emailExpression.test(email);
}
// REGEX for phone validation
function validatePhone(phone:String):Boolean {
        var emailExpression:RegExp = /^((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,3})|(\(?\d{2,3}\)?))(-| )?(\d{3,4})(-| )?(\d{4})(( x| ext)\d{1,5}){0,1}$/i;
        return ! emailExpression.test(phone);
}
		public static function addO(string,length:Number=2) {
			
			while (string.length<length) {
				string = "0"+string;
			}
			
			return string
		}
		
		public static function hex(iHex) {
			
			var tr = iHex >> 16;
			var tg = (iHex >> 8) ^ (tr << 8);
			var tb = iHex ^ ((tr << 16) | (tg << 8));
			
			var r = addO(tr.toString(16));
			var g = addO(tg.toString(16));
			var b = addO(tb.toString(16));
			
			return "0x"+(r+g+b).toUpperCase();
				
		}
*/
		
	}
	
}

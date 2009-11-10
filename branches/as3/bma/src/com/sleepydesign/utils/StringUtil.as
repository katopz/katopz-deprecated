/**
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.utils {
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.display.LoaderInfo;
	
	public class StringUtil {
		
		private static var hex_chr:String = "0123456789abcdef";
		
		public static function add0(iString, length:Number=0):String {
			iString = String(iString)
			while (iString.length<length) {
				iString = "0"+iString;
			}
			return iString
		}

		public static function hex(num:Number):String
		{
			var str = "";
			for (var j = 5; j >= 0; j--)
			{
				str += hex_chr.charAt((num >> (j * 4)) & 0x0F);
			}
			return "0x"+str.toUpperCase();
			
		}
		/*
		public static function cacheKiller(dataSrc) {
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

package com.cutecoma.utils
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.display.LoaderInfo;

	public class ValidationUtil
	{
		public static function isNull(value:*):Boolean
		{
			if (value is XML)
				value = XML(value).toXMLString();
			return !validateString(String(value));
		}

		public static function validateString(value:String):Boolean
		{
			if (value == null || value == "undefined" || value == "" || value == " ")
				return false;
			return true;
		}

		public static function validateNumber(value:String):Boolean
		{
			return !isNaN(Number(value));
		}

		// REGEX for phone validation
		public static function validatePhone(value:String):Boolean
		{
			var phoneExpression:RegExp = /^((\+\d{1,3}(-| )?\(?\d\)?(-| )?\d{1,3})|(\(?\d{2,3}\)?))(-| )?(\d{3,4})(-| )?(\d{4})(( x| ext)\d{1,5}){0,1}$/i;
			return !phoneExpression.test(value);
		}

		//validates email fields
		public static function validateEmail(value:String, multipleFields:Boolean = false):Boolean
		{
			var emailPattern:RegExp = /^(([^<>()[\]\\.,;:\s@]+(\.[^<>()[\]\\.,;:\s@]+)*)|(.+))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
			var addresses:Array = [];
			if (multipleFields)
				addresses = value.split(";");
			var len:uint = addresses.length;
			if (len > 1)
			{
				for (var i:uint = 0; i < len; i++)
				{
					if (!emailPattern.test(value))
						return false;
				}
			}
			else
			{
				if (!emailPattern.test(value))
					return false;

			}
			return true;
		}
	}
}
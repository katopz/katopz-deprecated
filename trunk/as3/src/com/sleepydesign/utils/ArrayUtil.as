package com.sleepydesign.utils
{

	public class ArrayUtil
	{
		public static function removeItem(tarArray:Array, item:*):uint
		{
			var i:int = tarArray.indexOf(item);
			var f:uint = 0;

			while (i != -1)
			{
				tarArray.splice(i, 1);

				i = tarArray.indexOf(item, i);

				f++;
			}

			return f;
		}
		
		public static function getItemByID(arr:Array, id:String):*
		{
			return getItemBy(arr, id, "id");
		}
		
		public static function getItemBy(arr:Array, key:*, arg:String = "id"):*
		{
			for each (var _item:* in arr)
			if (_item[arg] == key)
				return _item;
			
			return null;
		}
	}
}

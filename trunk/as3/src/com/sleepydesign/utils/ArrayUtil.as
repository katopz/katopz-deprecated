package com.sleepydesign.utils
{

	public class ArrayUtil
	{
		public static function removeItemByID(arr:Array, id:String):*
		{
			return removeItem(arr, getItemByID(arr, id));
		}

		public static function removeItem(arr:Array, item:*):uint
		{
			var i:int = arr.indexOf(item);
			var f:uint = 0;

			while (i != -1)
			{
				arr.splice(i, 1);

				i = arr.indexOf(item, i);

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

package com.sleepydesign.utils
{

	public class ArrayUtil
	{
		public static function getItemBy(arr:Array, key:*, arg:String = "id"):*
		{
			for each (var _item:* in arr)
			if (_item[arg] == key)
				return _item;
			
			return null;
		}
		
		public static function getItemByID(arr:Array, id:String):*
		{
			return getItemBy(arr, id, "id");
		}
		
		public static function removeItemAt(arr:Array, index:int):*
		{
			if (index == -1)
				return index;
			
			const item:* = arr[index];
			
			arr.splice(index, 1);
			
			return item;
		}
		
		public static function removeItem(arr:Array, item:*):*
		{
			return removeItemAt(arr, arr.indexOf(item));
		}
		
		public static function removeItemByID(arr:Array, id:String):*
		{
			return removeItemBy(arr, id);
		}
		
		public static function removeItemBy(arr:Array, key:*, arg:String = "id"):*
		{
			return removeItemAt(arr, arr.indexOf(getItemBy(arr, key, arg)));
		}
	}
}

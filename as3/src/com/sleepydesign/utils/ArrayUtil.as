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
	}
}

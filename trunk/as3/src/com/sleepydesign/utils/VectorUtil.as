package com.sleepydesign.utils
{

	public class VectorUtil
	{
		/**
		 * Converts vector to an array
		 * @param	vector:*	vector to be converted
		 * @return	Array		converted array
		 */
		public static function toArray(vector:*):Array
		{
			var n:int = vector.length;
			var a:Array = [];
			for (var i:int = 0; i < n; i++)
				a[i] = vector[i];
			return a;
		}

		/**
		 * Converts vector to an array and sorts it by a certain fieldName, options
		 * for more info @see Array.sortOn
		 * @param	vector:*			the source vector
		 * @param	fieldName:Object	a string that identifies a field to be used as the sort value
		 * @param	options:Object		one or more numbers or names of defined constants
		 */
		public static function sortOn(vector:*, fieldName:Object, options:Object = null):Array
		{
			return toArray(vector).sortOn(fieldName, options);
		}

		public static function removeItem(tarVector:*, item:*):uint
		{
			var i:int = tarVector.indexOf(item);
			var f:uint = 0;
			var _fixed:Boolean = tarVector.fixed;

			tarVector.fixed = false;

			while (i != -1)
			{
				tarVector.splice(i, 1);
				i = tarVector.indexOf(item, i);
				f++;
			}

			tarVector.fixed = _fixed;

			return f;
		}

		public static function getItemByID(arr:*, id:String):*
		{
			return getItemBy(arr, id, "id");
		}

		public static function getItemBy(arr:*, key:*, arg:String = "id"):*
		{
			for each (var _item:* in arr)
				if (_item[arg] && _item[arg] == key)
					return _item;

			return null;
		}
	}
}
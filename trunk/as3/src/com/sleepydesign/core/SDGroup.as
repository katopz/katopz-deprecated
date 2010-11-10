package com.sleepydesign.core
{
	import flash.utils.Dictionary;

	public class SDGroup implements IDestroyable
	{
		private var _isDestroyed:Boolean;

		public var items:Dictionary = new Dictionary(true);
		private var _length:int = 0;

		private var _itemType:*;

		public function SDGroup(itemType:* = null)
		{
			_itemType = itemType;
		}

		public function get length():int
		{
			return _length;
		}

		public function addItem(item:*, key:* = null):void
		{
			if (!item)
				return;

			if (!(item is _itemType))
				throw new Error("[Error] Type miss match. Required " + _itemType);

			if (key)
				items[key] = item;
			else
				items[_length] = item;

			_length++;
		}

		public function getItemByValue(value:* = null):*
		{
			for (var _item:* in items)
				if (items[_item] == value)
					return _item;

			return null;
		}

		public function getItem(key:*):*
		{
			if (!items)
				return null;

			return items[key];
		}

		public function getItemByID(id:String):*
		{
			return getItemBy(id, "id");
		}

		public function getItemBy(key:*, arg:String = "id"):*
		{
			for each (var _item:* in items)
				if (_item[arg] == key)
					return _item;

			return null;
		}

		public function removeItem(item:*, key:* = null):void
		{
			if (key)
			{
				removeItemBy(key);
			}
			else if (items[item])
			{
				var _items:Dictionary = new Dictionary();
				_length = 0;
				for (var _item:* in items)
					if (_item != item)
					{
						_items[_item] = items[_item];
						_length++;
					}

				items = _items;
			}
		}

		public function removeItemByValue(value:* = null):void
		{
			var _items:Dictionary = new Dictionary();
			_length = 0;
			for (var _item:* in items)
				if (items[_item] != value)
				{
					_items[_item] = items[_item];
					_length++;
				}

			items = _items;
		}

		public function removeItemByID(id:String):void
		{
			removeItemBy(id, "id");
		}

		public function removeItemBy(item:*, arg:String = "id"):void
		{
			if (!items)
				return;

			var _items:Dictionary = new Dictionary();
			_length = 0;
			for (var _item:* in items)
				if (items[_item][arg] != item)
				{
					_items[_item] = items[_item];
					_length++;
				}

			items = _items;
		}

		public function removeAll():void
		{
			for each (var _item:* in items)
				removeItemBy(_item);

			items = null;
			_length = 0;
		}

		public function get destroyed():Boolean
		{
			return this._isDestroyed;
		}

		public function destroy():void
		{
			this._isDestroyed = true;

			items = null;
			_length = 0;
		}
	}
}
package com.sleepydesign.collections
{
	import flash.net.URLVariables;
	import flash.utils.Dictionary;

	public class DataUtil
	{
		private static var _datas:Dictionary;

		public static function addData(id:String, data:*):*
		{
			if (!_datas)
				_datas = new Dictionary(true);

			_datas[id] = data;

			return data;
		}

		public static function removeData(id:String, data:*):void
		{
			if (!_datas)
				return;

			delete _datas[id];
			_datas[id] = null;
		}

		public static function getDataByID(id:String):*
		{
			if (_datas)
				return _datas[id];
			else
				return null;
		}

		public static function getDataByVars(_varsString:String):URLVariables
		{
			var _URLVariables:URLVariables = new URLVariables(_varsString);
			for (var _name:String in _URLVariables)
				_URLVariables[_name] = getDataByID(_URLVariables[_name]);

			return _URLVariables;
		}

		public static function removeAllData():void
		{
			if (!_datas)
				return;

			for each (var id:*in _datas)
			{
				delete _datas[id];
				_datas[id] = null;
			}
		}
	}
}
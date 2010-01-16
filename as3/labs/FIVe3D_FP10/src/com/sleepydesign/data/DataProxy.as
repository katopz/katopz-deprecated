package com.sleepydesign.data
{
	import flash.net.URLVariables;
	import flash.utils.Dictionary;

	public class DataProxy
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

		public static function getVarsFromString(_varsString:String):URLVariables
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
		
		public static function getDataByVars(varsString:String):URLVariables
		{
			var _URLVariables:URLVariables = new URLVariables(varsString);
			var _resultURLVariables:URLVariables = new URLVariables();
			
			for (var _name:String in _URLVariables)
				_resultURLVariables[_name] = getDataByID(_URLVariables[_name]);

			return _resultURLVariables;
		}
		
		/*
		public static function setDataToQuery(varsString:String):String
		{
			var _URLVariables:URLVariables = getDataByVars(varsString);
			for(var _var:String in _URLVariables)
				varsString = varsString.split(_var).join("'"+getDataByID(_var.split("$").join(""))+"'");
			return varsString;
		}
		*/
	}
}
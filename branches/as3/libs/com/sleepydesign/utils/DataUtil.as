package com.sleepydesign.utils
{
	import flash.utils.Dictionary;
	
	public class DataUtil
	{
        private static var _datas:Dictionary;
        
        public static function addData(name:String, data:*):*
        {
        	if(!_datas)
        		_datas = new Dictionary(true);
        	
        	_datas[name] = data;
        	
        	return data;
        }
        
        public static function removeData(name:String, data:*):void
        {
        	if(!_datas)return;
        	
        	delete _datas[name];
			_datas[name] = null;
        }
        
        public static function getDataByName(name:String):*
        {
			return _datas[name];
		}
		
		public static function removeAllData():void
		{
			if(!_datas)return;
			
			for each(var name:* in _datas)
			{
				delete _datas[name];
				_datas[name] = null;
			}
		}
	}
}
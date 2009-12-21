package com.sleepydesign.utils
{
	import flash.utils.Dictionary;
	
	public class DataUtil
	{
        private static var _datas:Dictionary;
        
        public static function addData(id:String, data:*):*
        {
        	if(!_datas)
        		_datas = new Dictionary(true);
        	
        	_datas[id] = data;
        	
        	return data;
        }
        
        public static function removeData(id:String, data:*):void
        {
        	if(!_datas)return;
        	
        	delete _datas[id];
			_datas[id] = null;
        }
        
        public static function getDataByID(id:String):*
        {
			if(_datas && _datas[id])
				return _datas[id];
			else
				return null;
		}
		
		public static function removeAllData():void
		{
			if(!_datas)return;
			
			for each(var id:* in _datas)
			{
				delete _datas[id];
				_datas[id] = null;
			}
		}
	}
}
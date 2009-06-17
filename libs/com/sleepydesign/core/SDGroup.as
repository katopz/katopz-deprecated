package com.sleepydesign.core
{
    import flash.utils.Dictionary;
    
    /**
	 * _____________________________________________________
	 * 
	 * SleepyDesign Group
	 * _____________________________________________________
	 * 
	 * - It's a group
	 * - Can switch between child
	 * - Show multiple or single instance view
	 * - Automatic call cross fade transition
	 * 
	 * @author katopz
	 */
	public class SDGroup
	{
		private var _childs : Dictionary;
		public function get childs():Dictionary
		{
			return _childs;
		}
		
		public function SDGroup(id:String=null)
		{
			_childs = new Dictionary(true);
		}
		
		public function insert(object:*, key:*=null):void
		{
			if(!object)return;
			if(!_childs)_childs = new Dictionary(true);
			if(key)
			{
				//trace(" + Insert	: [" +key + "]");
				_childs[key]=object;
			}else{
				//trace(" + Insert	: [" + object + "]");
				_childs[object]=object;
			}
		}
		
		public function find(object:*):*
		{
			if(!_childs)return null;
			return _childs[object];
		}
		
		public function findBy(str:String, arg:String="id"):*
		{
			if(!_childs)return null;
			for each(var object:* in _childs)
			{
				try
				{
					if (object[arg] == str)
					{
						return object;
					}
				}
				catch(e:*){}
			}
			return null;
		}
		
		public function print():void
		{
			if(!_childs)return;
			for (var object:* in _childs)
			{
				trace(object + "\t: " + XML(_childs[object]).toXMLString());
			}
		}
		
		public function destroy():void
		{
			for each(var object:* in _childs)
			{
				remove(object);
			}
			_childs = null;
		}
		
		public function remove(object:*=null, key:*=null):void
		{
			if(!_childs)return;
			if(key)
			{
				removeBy(key);
			}else if(_childs[object]){
				delete _childs[object];
				_childs[object] = null;
			}
		}
		
		public function removeBy(str:String, arg:String="id"):void
		{
			//trace(" * remove	: " + arg);
			if(!_childs)return;
			var __childs:Dictionary = new Dictionary();
			for (var object:* in _childs)
			{
				if (object[arg] != str)
				{
					__childs[arg] = _childs[arg];
				}else {
					delete _childs[arg];
					_childs[arg] = null;
				}
			}
			_childs = __childs;
		}
	}	
}
package com.sleepydesign.application.core
{
	import com.sleepydesign.application.data.SDSystemData;
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.events.SDEvent;
	
	import flash.net.FileReference;

	/**
	 * _____________________________________________________
	 *
	 * SleepyDesign System
	 * @author katopz
	 * _____________________________________________________
	 *
	 */
	public class SDSystem extends SDContainer
	{
		//public var file:FileReference;
		
		public static var instance : SDSystem;
        public static function getInstance() : SDSystem 
        {
            if ( !instance ) instance = new SDSystem();
            return instance as SDSystem;
        }
        
		public static var data:SDSystemData;
		/*
		public static function get data():SDSystemData
		{
			//if(!_data) _data = new SDSystemData(); 
			return _data;// as SDSystemData;
		}

		public static function set data(value:SDSystemData):void
		{
			//getInstance().update(data);
			_data = value;
		}
		*/
		public function SDSystem()
		{
			if(!instance)
				instance = this;
			
			super("SDSystem");
		}

		// ______________________________ Initialize ______________________________
/*
		override protected function init(raw:Object = null):void
		{
			if (!raw || !raw.container || !raw.stage)
				return;
			raw.stage.addChild(this);
		}*/
		
		// ______________________________ Update ____________________________
		
		public function update(data:SDSystemData):void
		{
			_data = data;
			SDSystem.data = data;
			dispatchEvent(new SDEvent(SDEvent.UPDATE, data));
		}
	}
}
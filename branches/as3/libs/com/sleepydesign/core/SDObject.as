package com.sleepydesign.core
{
    import com.sleepydesign.events.SDEvent;
    
    import flash.events.EventDispatcher;
    
	public class SDObject extends EventDispatcher
	{
		// for create pharse
		protected var _config : *;
		
		// for update pharse
		protected var _data : *;
		
		public function SDObject()
		{
			super();
		}
		
        // ______________________________ Initialize ______________________________
        
		public function init(raw:Object=null):void
		{
			// any required
		}
				
		// ______________________________ Parse ______________________________
		
		public function parse(raw:Object=null):void
		{
			// raw -> config
		}
		
		// ______________________________ Create ______________________________
		
		public function create(config:Object=null):void
		{
			// config -> elements
		}
		
		// ______________________________ Destroy ______________________________
		
		public function destroy():void
		{
			// elements -> garbage
		}
		
		// ______________________________ Update ____________________________
		
		public function update(data:Object=null):void
		{
			// data -> elements
		}
		
		// ______________________________ Draw ____________________________
		
		public function draw():void
		{
			// elements -> screen
		}
	}	
}
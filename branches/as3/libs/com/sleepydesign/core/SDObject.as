package com.sleepydesign.core
{
    import com.sleepydesign.events.RemovableEventDispatcher;
    
	public class SDObject extends RemovableEventDispatcher
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
        
		protected function init():void
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
		
		override public function destroy():void
		{
			// elements -> garbage
			super.destroy();
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
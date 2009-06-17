package com.sleepydesign.game.core
{
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.core.SDObject;
	
	import flash.events.Event;

	public class AbstractEngine extends SDObject
	{
		protected var container : SDContainer;
		
		public function AbstractEngine():void
		{
			super();
		}
				
        public function start() : void
		{
			if(!container)container = new SDContainer();
			container.addEventListener(Event.ENTER_FRAME, run);
		}
		
        public function stop() : void
		{
			container.removeEventListener(Event.ENTER_FRAME, run);
		}
		
        protected function run(event:Event=null) : void
        {
			//
        }
        
		public function addChild(child:Object):Object
        {
        	return child;
        }
        
		public function removeChild(child:Object):Object
        {
        	return child;
        }
	}
}

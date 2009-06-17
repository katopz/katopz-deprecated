package com.sleepydesign.core
{
	import com.sleepydesign.events.SDEvent;
	
    /**
	 * SleepyDesign User : sessions
	 */
	public class SDUser extends SDGroup
	{
		//TODO : do we need UserVO?
		private var _session:String;
		
        public function SDUser()
		{
			//
		}
		
		public function get session() :String
		{
			return _session;
		}
		
		public function set session(value:String):void
		{
			_session = value;
			trace(" ! Session update : " + _session );
			dispatchEvent(new SDEvent(SDEvent.UPDATE, {session:_session}));
		}
	}
}
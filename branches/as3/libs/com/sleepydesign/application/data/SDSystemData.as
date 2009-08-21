package com.sleepydesign.application.data
{
	public class SDSystemData
	{
        public var session:String;
        
        public function SDSystemData(session:String = "guest")
		{
			this.session = session;
		}
	}
}
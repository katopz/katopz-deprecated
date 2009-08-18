package com.sleepydesign.application.data
{
	import com.sleepydesign.application.core.SDApplication;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	public class SDApplicationData
	{
        public var loader:DisplayObject;
        public var instance:SDApplication;
        public var stage:Stage;
        
        public var configURI:String;
        
        public function SDApplicationData(loader:DisplayObject, configURI:String="config.xml")
		{
			this.loader = loader;
			this.configURI = configURI;
		}
	}
}


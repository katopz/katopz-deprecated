package com.sleepydesign.site
{
	import org.osflash.signals.Signal;
	
	public class NavigationTool
	{
		/* path */
		public static var signal:Signal = new Signal(String); 
		
		public static function setFocusByPath(path:String):void
		{
			signal.dispatch(path);
		}
	}
}
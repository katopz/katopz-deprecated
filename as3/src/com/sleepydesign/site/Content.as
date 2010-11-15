package com.sleepydesign.site
{
	import com.sleepydesign.display.SDClip;
	
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	public class Content extends SDClip
	{
		/**content comnmand*/
		public static var REQUEST_CONTENT:String = "REQUEST_CONTENT";
		public static var REQUEST_POPUP:String = "REQUEST_POPUP";
		
		public static var contentSignal:Signal = new Signal(String/**content comnmand*/, Object/**any data*/);
		
		public function Content(name:String = null)
		{
			if(name)
				this.name = name; 
		}
	}
}
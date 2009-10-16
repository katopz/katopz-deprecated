package com.sleepydesign.graphics.tools
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class HandleEvent extends Event
	{
		public static const MOVE:String = "move";
		public var point:Point;
		
		public function HandleEvent(type:String, point:Point=null, bubbles:Boolean = false, cancelable:Boolean = false)
	    {
	        super(type, bubbles, cancelable);
			this.point = point;
	    }
	}
}
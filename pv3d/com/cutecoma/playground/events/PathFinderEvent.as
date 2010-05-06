package com.cutecoma.playground.events
{
	import flash.events.Event;

	public class PathFinderEvent extends Event
	{
		public static const COMPLETE	: String = "complete";
		public static const ERROR		: String = "error";
		
		public var data					: * = null;
		
		public function PathFinderEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}
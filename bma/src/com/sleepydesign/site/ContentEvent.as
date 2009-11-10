package com.sleepydesign.site{
	
	import flash.events.Event;
	
	/**
	 * This custom Event class adds a message property to a basic Event.
	 */
	public class ContentEvent extends Event 
	{
		
		public static const INIT:String = "onContentInit";
		public static const COMPLETE:String = "onContentComplete";
		public static const ERROR:String = "onContentError";
		
		public static const GETCONFIG:String = "onContentGetConfig";
		public static const READY:String = "onContentReady";
		
		public static const UPDATE:String = "onContentUpdate";
		public static const SETFOCUS:String = "onContentSetFocus";
		public static const LOSTFOCUS:String = "onContentLostFocus";
		
		/**
		 * Playing time.
		 */
		public var content:Object;
		public var data:Object;
		
		public function ContentEvent(type:String, content:Object=null, data:Object=null)
		{
			super(type);
			this.content = content;
			this.data = data;
		}
		
		
		/**
		 * Creates and returns a copy of the current instance.
		 * @return	A copy of the current instance.
		 */
		public override function clone():Event
		{
			return new ContentEvent(type, content, data);
		}
		
		
		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String
		{
			return formatToString("ContentEvent", "type", "bubbles", "cancelable", "eventPhase", "content", "data");
		}
	}
}
package com.sleepydesign.events
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class SDKeyboardEvent extends Event
	{
		public static const KEY_PRESS:String = "sd-key-press";
		
		public var data:*;
		public var keyEvent:KeyboardEvent;
		
	    public function SDKeyboardEvent(type:String, data:*=null, keyEvent:KeyboardEvent=null, bubbles:Boolean = false, cancelable:Boolean = false)
	    {
	        super(type, bubbles, cancelable);
			this.data = data;
			this.keyEvent = keyEvent;
	    }
	    
	    override public function clone():Event
	    {
	        return new SDKeyboardEvent(type, data, keyEvent, bubbles, cancelable);
	    }
	    
		public override function toString():String
		{
			return formatToString("SDKeyboardEvent", "type", "bubbles", "cancelable", "eventPhase", "data", "keyEvent");
		}
	}
}

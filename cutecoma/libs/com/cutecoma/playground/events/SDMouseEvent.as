package com.cutecoma.playground.events
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SDMouseEvent extends Event
	{
		public static const CLICK:String = "sd-click";
		
		public static const MOUSE_DOWN:String = "sd-mouse-down";
		public static const MOUSE_UP:String = "sd-mouse-up";
		
		public static const MOUSE_DRAG:String = "sd-mouse-drag";
		public static const MOUSE_DROP:String = "sd-mouse-drop";
		
		public var mouseEvent:*;
		public var data:*;
		
	    public function SDMouseEvent(type:String, data:*=null, mouseEvent:MouseEvent=null, bubbles:Boolean = false, cancelable:Boolean = false)
	    {
	        super(type, bubbles, cancelable);
	        
			this.mouseEvent = mouseEvent;
			this.data = data;
	    }
	    
	    override public function clone():Event
	    {
	        return new SDMouseEvent(type, data, mouseEvent, bubbles, cancelable);
	    }
	    
		public override function toString():String
		{
			return formatToString("SDMouseEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
	}
}

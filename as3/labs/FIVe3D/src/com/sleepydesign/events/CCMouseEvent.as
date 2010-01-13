package com.cutecoma.events
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CCMouseEvent extends Event
	{
		/*
		public static const CLICK:String = "cc-click";

		public static const MOUSE_DOWN:String = "cc-mouse-down";
		public static const MOUSE_UP:String = "cc-mouse-up";
		*/
		
		public static const MOUSE_DRAG:String = "CCmouseDrag";

		public var mouseEvent:*;
		public var data:*;

		public function CCMouseEvent(type:String, data:* = null, mouseEvent:MouseEvent = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
			this.mouseEvent = mouseEvent;
		}

		override public function clone():Event
		{
			return new CCMouseEvent(type, data, mouseEvent, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("CCMouseEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
	}
}
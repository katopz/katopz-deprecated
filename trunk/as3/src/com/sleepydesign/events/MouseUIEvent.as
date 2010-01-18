package com.sleepydesign.events
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class MouseUIEvent extends Event
	{
		/*
		public static const CLICK:String = "sd-click";

		public static const MOUSE_DOWN:String = "sd-mouse-down";
		public static const MOUSE_UP:String = "sd-mouse-up";
		*/
		
		public static const MOUSE_DRAG:String = "cc-mouse-drag";

		public var mouseEvent:*;
		public var data:*;

		public function MouseUIEvent(type:String, data:* = null, mouseEvent:MouseEvent = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
			this.mouseEvent = mouseEvent;
		}

		override public function clone():Event
		{
			return new MouseUIEvent(type, data, mouseEvent, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("SDMouseEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
	}
}
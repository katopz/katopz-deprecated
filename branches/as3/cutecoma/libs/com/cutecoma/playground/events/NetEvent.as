package com.cutecoma.playground.events
{
	import flash.events.Event;

	public class NetEvent extends Event
	{
		//NetConnection
		public static const CONNECT:String = "net_connect";
		public static const DISCONNECT:String = "net_disconnect";

		//SharedObject
		public static const SYNC:String = "net_sync";
		public static const ASYNC:String = "net_async";

		public var data:*;

		public function NetEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}

		override public function clone():Event
		{
			return new NetEvent(type, data, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("NetEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
	}
}
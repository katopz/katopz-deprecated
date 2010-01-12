package com.cutecoma.events
{
	import flash.events.Event;
	import flash.geom.Transform;

	public class TransformEvent extends Event
	{
		public static const RESIZE:String = "cc-resize";
		public var transform:Transform;

		public function TransformEvent(type:String, transform:Transform = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.transform = transform;
		}

		override public function clone():Event
		{
			return new TransformEvent(type, transform, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("TransformEvent", "type", "bubbles", "cancelable", "eventPhase", "transform");
		}
	}
}
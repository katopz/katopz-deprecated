package com.cutecoma.playground.events
{
	import flash.events.Event;

	public class GroundEvent extends Event
	{
		public static const MOUSE_DOWN	: String = "ground-mouse-down";
		
		public var bitmapX:Number;
		public var bitmapZ:Number;
		
		public function GroundEvent(type:String, bitmapX:Number, bitmapZ:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.bitmapX = bitmapX;
			this.bitmapZ = bitmapZ;
		}
	}
}
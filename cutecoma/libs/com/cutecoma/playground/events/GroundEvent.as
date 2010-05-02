package com.cutecoma.playground.events
{
	import flash.events.Event;

	public class GroundEvent extends Event
	{
		public static const MOUSE_DOWN	: String = "ground-mouse-down";
		public static const MOUSE_MOVE	: String = "ground-mouse-move";
		
		public var color:Number;
		
		public var bitmapX:Number;
		public var bitmapZ:Number;
		
		public function GroundEvent(type:String, bitmapX:Number, bitmapZ:Number, color:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.bitmapX = bitmapX;
			this.bitmapZ = bitmapZ;
			this.color = color;
		}
	}
}
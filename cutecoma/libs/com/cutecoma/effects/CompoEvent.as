package com.cutecoma.effects
{

	import flash.events.Event;

	public class CompoEvent extends Event
	{
		public static const SELECT:String = "select";
		public static const CHANGE:String = "change";
		public var value:*;

		public function CompoEvent(type:String, value:*)
		{
			super(type);
			this.value = value;
		}

		public override function clone():Event
		{
			return new CompoEvent(type, value);
		}

	}
}
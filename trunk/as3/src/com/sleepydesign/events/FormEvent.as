package com.sleepydesign.events
{
	import flash.events.Event;

	public class FormEvent extends Event
	{
		// _____________________ While Edit _____________________

		// data is complete
		public static const COMPLETE:String = "sd-form-complete";

		// data is incomplete
		public static const INCOMPLETE:String = "sd-form-incomplete";

		// data out is invalid
		public static const INVALID:String = "sd-form-invalid";

		// data out is valid
		public static const VALID:String = "sd-form-valid";

		// submit
		public static const SUBMIT:String = "sd-form-submit";
		public static const EXTERNAL_SUBMIT:String = "sd-external-form-submit";
		public static const DATA_CHANGE:String = "sd-data-change-submit";

		// _____________________ Form Data _____________________

		public var data:*;

		public function FormEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}

		override public function clone():Event
		{
			return new FormEvent(type, data, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("FormEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
	}
}
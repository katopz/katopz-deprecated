package com.cutecoma.playground.events
{
	import flash.events.Event;

	public class AreaEditorEvent extends Event
	{
		public static const AREA_ID_CHANGE:String = "area-id-change";

		public var areaID:String;

		public function AreaEditorEvent(type:String, areaID:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.areaID = areaID;
		}
	}
}
package {
	
	import flash.events.Event;
	
	/**
	 * This custom Event class adds a message property to a basic Event.
	 */
	public class UpdateEvent extends Event 
	{
		
		public static const UPDATE:String = "onUpdate";
		
		/**
		 * Playing time.
		 */
		public var panel:Object;
		public var content:Object;
		public var data:Object;
		
		public function UpdateEvent(type:String, panel:Object=null,content:Object=null, data:Object=null)
		{
			super(type);
			this.panel = panel;
			this.content = content;
			this.data = data;
		}
		
		
		/**
		 * Creates and returns a copy of the current instance.
		 * @return	A copy of the current instance.
		 */
		public override function clone():Event
		{
			return new UpdateEvent(type, panel, content, data);
		}
		
		
		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String
		{
			return formatToString("UpdateEvent", "type", "bubbles", "cancelable", "eventPhase", "panel", "content", "data");
		}
	}
}
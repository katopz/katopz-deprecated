package {
	
	import flash.events.Event;
	
	/**
	 * This custom Event class adds a message property to a basic Event.
	 */
	public class DockEvent extends Event 
	{
		
		public static const SELECTED:String = "onDockSelect";
		
		/**
		 * Playing time.
		 */
		public var content:Object;
		public var data:Object;
		
		public function DockEvent(type:String, content:Object=null, data:Object=null)
		{
			super(type);
			this.content = content;
			this.data = data;
		}
		
		
		/**
		 * Creates and returns a copy of the current instance.
		 * @return	A copy of the current instance.
		 */
		public override function clone():Event
		{
			return new DockEvent(type, content, data);
		}
		
		
		/**
		 * Returns a String containing all the properties of the current
		 * instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String
		{
			return formatToString("ContentEvent", "type", "bubbles", "cancelable", "eventPhase", "content", "data");
		}
	}
}
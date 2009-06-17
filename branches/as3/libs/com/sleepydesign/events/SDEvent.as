package com.sleepydesign.events
{
	import flash.events.Event;
	
	/**
	 *  The SDEvent class represents the event object passed to
	 *  the event listener for many SleepyDesign events.
	 */
	public class SDEvent extends Event
	{
	    //--------------------------------------------------------------------------
	    //
	    //  Class constants
	    //
	    //--------------------------------------------------------------------------
	    
		// _____________________ Loader _____________________
		
		// start load something
		public static const LOAD:String = "SDload";
		// loading
		public static const PROGRESS:String = "SDprogress";
		// data init
		public static const INIT:String = "SDinit";
		// data complete, also mean obj -> class
		public static const COMPLETE:String = "SDcomplete";
		
		// _____________________ Server _____________________
		
		// common error 404, 500
		public static const ERROR:String = "SDerror";
		// refuse 403
		public static const DENIED:String = "SDdenied";
		
		// _____________________ Form _____________________
		
		// data is incomplete
		public static const INCOMPLETE:String = "SDincomplete";
		
		// data in/out is invalid
		public static const INVALID:String = "SDinvalid";
		
		// data in/out is valid
		public static const VALID:String = "SDvalid";
		
		// _____________________ Data _____________________

		// data in
		public static const DATA:String = "SDdata";
		
		// data in and update
		public static const UPDATE:String = "SDupdate";
		
		// _____________________ Group _____________________
		
		// i got focus
		public static const SET_FOCUS:String = "SDset_focus";
		
		// i lost focus
		public static const LOST_FOCUS:String = "SDlost_focus";
		
		// my child just swap
		public static const CHANGE_FOCUS:String = "SDchange_focus";
		
		// _____________________ System _____________________
		
		// wake up
		public static const ACTIVATE:String = "SDactivate";
		// suspend
		public static const DEACTIVATE:String = "SDdeactivate";
		// enter sleep mode
		public static const IDLE:String = "SDidle";
		// destroy
		public static const DESTROY:String = "SDdestroy";
		
		// _____________________ View _____________________
		
		// view create
		public static const CREATE:String = "SDcreate";
		// view draw
		public static const DRAW:String = "SDdraw";
		// reveal
		public static const SHOW:String = "SDshow";
		// view is ready
		public static const READY:String = "SDready";
		// hinding
		public static const HIDE:String = "SDhide";
		// sizing
		public static const RESIZE:String = "SDresize";
		
	    //--------------------------------------------------------------------------
	    //
	    //  Any data
	    //
	    //--------------------------------------------------------------------------
	    
		public var data:*;
		
	    //--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  Constructor.
	     *
	     *  @param type The event type; indicates the action that caused the event.
	     *
	     *  @param bubbles Specifies whether the event can bubble up
	     *  the display list hierarchy.
	     *
	     *  @param cancelable Specifies whether the behavior
	     *  associated with the event can be prevented.
	     */
	    public function SDEvent(type:String, data:*=null, bubbles:Boolean = false, cancelable:Boolean = false)
	    {
	        super(type, bubbles, cancelable);
			this.data = data;
	    }
		
	    //--------------------------------------------------------------------------
	    //
	    //  Overridden methods: Event
	    //
	    //--------------------------------------------------------------------------
		
	    /**
	     *  @private
	     */
	    override public function clone():Event
	    {
	        return new SDEvent(type, data, bubbles, cancelable);
	    }
	    
		/**
		 * Returns a String containing all the properties of the current instance.
		 * @return A string representation of the current instance.
		 */
		public override function toString():String
		{
			return formatToString("SDEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
	}
}

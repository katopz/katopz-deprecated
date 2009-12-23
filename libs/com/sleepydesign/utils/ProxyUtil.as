package com.sleepydesign.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class ProxyUtil
	{
		private static var _dispatcher:EventDispatcher = new EventDispatcher();

		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * Removes a listener from the EventDispatcher object. If there is no matching listener registered with the EventDispatcher object, a call to this method has no effect.
		 * @param type The type of event.
		 * @param listener The listener object to remove.
		 * @param useCapture Specifies whether the listener was registered for the capture phase or the target and bubbling phases.
		 * If the listener was registered for both the capture phase and the target and bubbling phases, two calls to removeEventListener() are required to remove both,
		 * one call with useCapture() set to true, and another call with useCapture() set to false.
		 */
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}

		/**
		 * Dispatches an event to all the registered listeners.
		 * @param event Event object.
		 * @return A value of <code>true</code> if a listener of the specified type is registered; <code>false</code> otherwise.
		 * @throws Error The event dispatch recursion limit has been reached.
		 */
		public static function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}

		/**
		 * Checks whether the EventDispatcher object has any listeners registered for a specific type of event. This allows you to determine where an EventDispatcher object has
		 * altered handling of an event type in the event flow hierarchy.
		 * @param event The type of event.
		 * @return A value of <code>true</code> if a listener of the specified type is registered; <code>false</code> otherwise.
		 */
		public static function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}
	}
}
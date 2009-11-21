package
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Oishi
	{
		private static var _eventDispatcher:EventDispatcher;
		private static var _code:String;

		public static function openReader():void
		{
			dispatchEvent(new Event(Event.OPEN));
		}

		public static function closeReader():void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public static function setCode(value:String):void
		{
			_code = value;
			dispatchEvent(new DataEvent(DataEvent.DATA, false, false, value));
		}
		
		public static function getCode():String
		{
			return _code;
		}
		
		//--------------------------------------------------------------------------------------------------
		
		public static function dispatchEvent(event:Event):void
		{
			if (_eventDispatcher == null)
				return;
			_eventDispatcher.dispatchEvent(event);
		}

		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (_eventDispatcher == null)
				_eventDispatcher = new EventDispatcher();
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (_eventDispatcher == null)
				return;
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
	}
}
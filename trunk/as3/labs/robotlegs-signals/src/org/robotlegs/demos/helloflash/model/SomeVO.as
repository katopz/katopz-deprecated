package org.robotlegs.demos.helloflash.model
{
	import flash.events.EventDispatcher;
	
	public class SomeVO extends EventDispatcher
	{
		private var _someValue:int;

		public function get someValue():int
		{
			return _someValue;
		}

		public function set someValue(value:int):void
		{
			_someValue = value;
		}
		
		public function SomeVO(someValue:int)
		{
			_someValue = someValue;
		}
	}
}
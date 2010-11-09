package org.robotlegs.demos.helloflash.model
{
	import org.robotlegs.mvcs.Actor;
	
	public class SomeModel extends Actor
	{
		private var _someValue:Vector.<SomeVO>;
		
		public function SomeModel()
		{
			_someValue = new Vector.<SomeVO>();
			_someValue[0] = new SomeVO(1);
		}
		
		public function addSomeVO(someVO:SomeVO):void
		{
			_someValue.push(someVO);
		}
		
		public function getLastVO():SomeVO
		{
			return _someValue[_someValue.length-1];
		}
	}
}
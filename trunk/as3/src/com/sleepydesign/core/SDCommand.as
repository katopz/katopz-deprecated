package com.sleepydesign.core
{
	import org.osflash.signals.Signal;

	public class SDCommand implements ICommand
	{
		protected var _completeSignal:Signal = new Signal();

		public function get completeSignal():Signal
		{
			return _completeSignal;
		}

		public function doCommand():void
		{
			command();
			_completeSignal.dispatch();
		}
		
		public function command():void
		{
			// override me
		}
	}
}
package com.sleepydesign.core
{
	import org.osflash.signals.Signal;

	public class SDCommand implements ICommand, IDestroyable
	{
		protected var _isDestroyed:Boolean;
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
		
		public function get destroyed():Boolean
		{
			return _isDestroyed;
		}
		
		public function destroy():void
		{
			_isDestroyed = true;
			
			_completeSignal.removeAll();
			_completeSignal = null;
		}
	}
}
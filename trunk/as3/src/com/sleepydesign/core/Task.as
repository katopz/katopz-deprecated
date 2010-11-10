package com.sleepydesign.core
{
	import org.osflash.signals.Signal;

	public class Task implements ITask, IDestroyable
	{
		protected var _isDestroyed:Boolean;
		protected var _completeSignal:Signal = new Signal();

		protected var task:Function;
		protected var callBack:Function;

		public function Task(task:Function = null, callBack:Function = null)
		{
			if (task is Function)
				this.task = task;

			if (callBack is Function)
				this.callBack = callBack;
		}

		public function get completeSignal():Signal
		{
			return _completeSignal;
		}

		public function doTask():void
		{
			run();

			if (callBack is Function)
				callBack();

			complete();
		}

		public function run():void
		{
			// override me
			if (task is Function)
				task();
		}

		public function complete():void
		{
			_completeSignal.dispatch();
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

			task = null;
			callBack = null;
		}
	}
}
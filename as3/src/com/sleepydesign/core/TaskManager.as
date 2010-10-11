package com.sleepydesign.core
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.osflash.signals.Signal;

	public class TaskManager implements IDestroyable
	{
		private var _isDestroyed:Boolean;
		protected var _tasks:Vector.<ITask> = new Vector.<ITask>();
		protected var _totalTasks:int;

		private var _timer:Timer;
		private var _fps:int = 30;

		public var completeSignal:Signal = new Signal();

		private var _isParallel:Boolean = false;

		public function TaskManager(isParallel:Boolean = false)
		{
			_isParallel = isParallel;
		}

		public function addTask(task:ITask):ITask
		{
			// add to queue
			_tasks.fixed = false;
			_tasks.push(task);
			_tasks.fixed = true;

			return task;
		}

		public function removeTask(task:ITask):ITask
		{
			var i:int = _tasks.indexOf(task);
			var f:uint = 0;

			// remove
			_tasks.fixed = false;
			while (i != -1)
			{
				_tasks.splice(i, 1);
				i = _tasks.indexOf(task, i);
				f++;
			}
			
			_tasks.fixed = true;
			_totalTasks = _tasks.length;
				
			return task;
		}

		public function start():void
		{
			if (!_tasks)
				return;
			else if (_tasks.length <= 0)
			{
				onTaskComplete();
				return;
			}

			var _tasks_length:int = _totalTasks = _tasks.length;
			if (!_isParallel)
			{
				// link list serial eg. [task1 - complete] -> [task2 - complete] -> ... -> [task3 - complete]
				while (--_tasks_length > 0)
					_tasks[_tasks_length - 1].completeSignal.addOnce(_tasks[_tasks_length].doTask);

				// stop
				_tasks[_tasks.length - 1].completeSignal.addOnce(onTaskComplete);

				// start
				_tasks[0].doTask();
			}
			else
			{
				// link list as Parallel
				if (_timer)
				{
					_timer.stop();
					_timer = null;
				}

				// do task each frame
				_timer = new Timer((1000 / _fps) / _totalTasks, _totalTasks);
				_timer.addEventListener(TimerEvent.TIMER, onTimer);

				// link
				_tasks_length = _tasks.length;
				while (_tasks_length--)
					_tasks[_tasks_length].completeSignal.addOnce(onSubTaskComplete);

				// start
				_timer.start();
			}
		}

		private function onTimer(event:TimerEvent):void
		{
			var _timer:Timer = event.target as Timer;
			var _task:ITask = _tasks[_timer.currentCount - 1];
			_task.doTask();
		}

		private function onSubTaskComplete():void
		{
			if (--_totalTasks == 0)
			{
				stop();
				onTaskComplete();
			}
		}

		private function onTaskComplete():void
		{
			completeSignal.dispatch();
		}

		public function stop():void
		{
			if (!_tasks)
				return;

			// destroy link list
			var _tasks_length:int = _tasks.length;
			while (--_tasks_length > 0)
				IDestroyable(_tasks[_tasks_length]).destroy();

			// destroy parallel
			if (_timer)
			{
				_timer.stop();
				_timer = null;
			}
			
			_tasks = new Vector.<ITask>();
			_totalTasks = 0;
		}

		public function get destroyed():Boolean
		{
			return _isDestroyed;
		}

		public function destroy():void
		{
			_isDestroyed = true;
			stop();
			
			_tasks = null;

			completeSignal.removeAll();
			completeSignal = null;
		}
	}
}
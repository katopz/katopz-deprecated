package com.sleepydesign.core
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import org.osflash.signals.Signal;

	public class CommandManager implements IDestroyable
	{
		private var _isDestroyed:Boolean;
		protected var _commands:Vector.<ICommand> = new Vector.<ICommand>();
		protected var _totalCommands:int;

		private var _timer:Timer;
		private var _fps:int = 30;

		public var completeSignal:Signal = new Signal();

		public function addCommand(command:ICommand):ICommand
		{
			_commands.fixed = false;
			_commands.push(command);
			_commands.fixed = true;

			return command;
		}

		public function removeCommand(command:ICommand):ICommand
		{
			var i:int = _commands.indexOf(command);
			var f:uint = 0;

			_commands.fixed = false;
			while (i != -1)
			{
				_commands.splice(i, 1);
				i = _commands.indexOf(command, i);
				f++;
			}
			_commands.fixed = true;

			return command;
		}

		public function start():void
		{
			if (!_commands)
				return;
			else if (_commands.length <= 0)
				return;

			// link list serial command like command1 --- complete ---> command2 --- complete ---> ...
			var _commands_length:int = _commands.length;
			while (--_commands_length)
				_commands[_commands_length - 1].completeSignal.addOnce(_commands[_commands_length].doCommand);

			// stop
			_commands[_commands.length - 1].completeSignal.addOnce(onCommandComplete);

			// start
			_commands[0].doCommand();
		}

		public function startAll():void
		{
			if (!_commands)
				return;
			else if (_commands.length <= 0)
				return;

			// link list as Parallel
			if (_timer)
			{
				_timer.stop();
				_timer = null;
			}

			_totalCommands = _commands.length;
			_timer = new Timer(1000 / _fps, _totalCommands);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.start();
		}

		protected function onTimer(event:TimerEvent):void
		{
			var _timer:Timer = event.target as Timer;
			var _command:ICommand = _commands[_timer.currentCount - 1];
			_command.completeSignal.addOnce(onSubCommandComplete);
			_command.doCommand();
		}
		
		protected function onTimerComplete(event:TimerEvent):void
		{
			stop();
		}

		protected function onSubCommandComplete():void
		{
			if (--_totalCommands == 0)
			{
				stop();
				onCommandComplete();
			}
		}

		protected function onCommandComplete():void
		{
			completeSignal.dispatch();
		}

		public function stop():void
		{
			if (!_commands)
				return;

			// destroy link list
			var _commands_length:int = _commands.length;
			if (_commands_length > 0)
			{
				while (--_commands_length)
					_commands[_commands_length - 1].completeSignal.remove(_commands[_commands_length].doCommand);

				// don't stop anymore
				_commands[_commands.length - 1].completeSignal.remove(stop);
			}

			// destroy parallel
			if (_timer)
			{
				_timer.stop();
				_timer = null;
			}

			_commands = null;
		}

		public function get destroyed():Boolean
		{
			return this._isDestroyed;
		}

		public function destroy():void
		{
			this._isDestroyed = true;
			stop();
		}
	}
}
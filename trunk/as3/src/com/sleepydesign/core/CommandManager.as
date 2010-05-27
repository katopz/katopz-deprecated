package com.sleepydesign.core
{
	import org.osflash.signals.Signal;

	public class CommandManager implements IDestroyable
	{
		private var _isDestroyed:Boolean;
		protected var _commands:Vector.<ICommand> = new Vector.<ICommand>();
		protected var _totalCommands:int;

		public var completeSignal:Signal = new Signal(CommandManager);

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
			var _commands_length:int = _totalCommands = _commands.length;
			for each(var _command:ICommand in _commands)
			{
				_command.completeSignal.addOnce(onSubCommandComplete);
				_command.doCommand();
			}
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
			completeSignal.dispatch(this);
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
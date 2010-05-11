package com.sleepydesign.core
{
	public class CommandManager implements IDestroyable
	{
		private var _isDestroyed:Boolean;
		protected var _commands:Vector.<ICommand> = new Vector.<ICommand>();

		public function addCommand(command:ICommand):CommandManager
		{
			_commands.fixed = false;
			_commands.push(command);
			_commands.fixed = true;

			return this;
		}

		public function start():void
		{
			trace(" ! Start");
			// link list
			var _commands_length:int = _commands.length;
			while (--_commands_length)
				_commands[_commands_length - 1].completeSignal.addOnce(_commands[_commands_length].doCommand);

			// stop
			_commands[_commands.length - 1].completeSignal.addOnce(stop);

			// start
			_commands[0].doCommand();
		}

		public function stop():void
		{
			trace(" ! Stop");
			_commands = null;
		}
		
		public function get destroyed():Boolean
		{
			return this._isDestroyed;
		}
		
		public function destroy():void
		{
			this._isDestroyed = true;
			
			// destroy link list
			var _commands_length:int = _commands.length;
			while (--_commands_length)
				_commands[_commands_length - 1].completeSignal.remove(_commands[_commands_length].doCommand);
			
			// don't stop anymore
			_commands[_commands.length - 1].completeSignal.remove(stop);
			
			stop();
		}
	}
}
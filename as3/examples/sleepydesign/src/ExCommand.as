package
{
	import com.sleepydesign.core.CommandManager;
	import com.sleepydesign.core.SDCommand;
	
	import flash.display.Sprite;

	public class ExCommand extends Sprite
	{
		public function ExCommand()
		{
			var _commandManager:CommandManager = new CommandManager();
			
			// test add command
			_commandManager.addCommand(new MyCommand1);
			_commandManager.addCommand(new MyCommand2);
			
			// test remove command
			var _removeCommand:SDCommand = _commandManager.addCommand(new MyCommand1) as SDCommand;
			_commandManager.removeCommand(_removeCommand);
			
			// start!
			_commandManager.start();
		}
	}
}
import com.sleepydesign.core.SDCommand;

internal class MyCommand1 extends SDCommand
{
	override public function command():void
	{
		for (var i:int = 0; i < 3; i++)
			trace(this, [" * Command1 : " + i]);
	}
}

internal class MyCommand2 extends SDCommand
{
	override public function command():void
	{
		for (var i:int = 0; i < 5; i++)
			trace(this, [" * Command2 : " + i]);
	}
}
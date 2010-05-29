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
			_commandManager.addCommand(new MyCommand2);
			_commandManager.addCommand(new MyCommand2);
			_commandManager.addCommand(new MyCommand1);
			_commandManager.addCommand(new MyCommand3);
			
			// test remove command
			var _removeCommand:SDCommand = _commandManager.addCommand(new MyCommand1) as SDCommand;
			_commandManager.removeCommand(_removeCommand);
			
			// start!
			_commandManager.startAll();
		}
	}
}
import com.greensock.TweenLite;
import com.sleepydesign.core.CommandManager;
import com.sleepydesign.core.ICommand;
import com.sleepydesign.core.SDCommand;
import com.sleepydesign.system.DebugUtil;

internal class MyCommand1 extends SDCommand
{
	override public function command():void
	{
		trace(" > MyCommand1");
		for (var i:int = 0; i < 10; i++)
			DebugUtil.trace([" * MyCommand1 : " + i]);
		trace(" < MyCommand1");
	}
}

internal class MyCommand2 extends SDCommand
{
	override public function doCommand():void
	{
		trace(" > MyCommand2");
		var _commandManager:CommandManager = new CommandManager();
		_commandManager.addCommand(new MyCommand4);
		_commandManager.addCommand(new MyCommand5);
		_commandManager.completeSignal.addOnce(onCommandComplete);
		_commandManager.startAll();
	}
	
	private function onCommandComplete(commandManager:CommandManager):void
	{
		trace(" < MyCommand2");
		_completeSignal.dispatch();
	}
}

internal class MyCommand3 extends SDCommand
{
	override public function command():void
	{
		for (var i:int = 0; i < 5; i++)
			DebugUtil.trace([" * MyCommand3 : " + i]);
	}
}

internal class MyCommand4 extends SDCommand
{
	override public function doCommand():void
	{
		trace(" * MyCommand4");
		TweenLite.to(this, 1, {onComplete:super.doCommand});
	}
	
	override public function command():void
	{
		trace(" * MyCommand4.onComplete");
	}
}

internal class MyCommand5 extends SDCommand
{
	override public function doCommand():void
	{
		trace(" * MyCommand5");
		TweenLite.to(this, 2, {onComplete:_completeSignal.dispatch});
	}
}
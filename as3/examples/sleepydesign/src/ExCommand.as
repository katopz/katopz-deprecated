package
{
	import com.sleepydesign.core.CommandManager;

	import flash.display.Sprite;

	public class ExCommand extends Sprite
	{
		public function ExCommand()
		{
			new CommandManager().addCommand(new MyCommand1).addCommand(new MyCommand2).start();
		}
	}
}
import com.sleepydesign.core.AbstractCommand;

internal class MyCommand1 extends AbstractCommand
{
	override public function command():void
	{
		for (var i:int = 0; i < 3; i++)
			trace(this, [" * Command1 : " + i]);
	}
}

internal class MyCommand2 extends AbstractCommand
{
	override public function command():void
	{
		for (var i:int = 0; i < 5; i++)
			trace(this, [" * Command2 : " + i]);
	}
}
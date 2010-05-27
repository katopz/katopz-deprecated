package application.controller
{
	import application.model.DataProxy;
	
	import org.puremvc.as3.patterns.command.MacroCommand;

	public class StartupCommand extends MacroCommand
	{
		override protected function initializeMacroCommand():void
		{
			// prepare data
			addSubCommand(ModelPrepCommand);
			
			// render time
			addSubCommand(ViewPrepCommand);
		}
	}
}
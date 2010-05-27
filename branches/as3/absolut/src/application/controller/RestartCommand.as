package application.controller
{
	import application.model.CrystalDataProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class RestartCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var data:CrystalDataProxy = facade.retrieveProxy(CrystalDataProxy.NAME) as CrystalDataProxy;
			data.resetGame();
		}
	}
}
package application.controller
{
	import application.model.DataProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class RestartCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var data:DataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
			data.resetGame();
		}
	}
}
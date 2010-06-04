package application.controller
{
	import application.model.CrystalDataProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class UserMoveCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			var _proxy:CrystalDataProxy = facade.retrieveProxy(CrystalDataProxy.NAME) as CrystalDataProxy;
			var data:Object = notification.getBody();
			_proxy.userMove(data.sourceID, data.targetID);
		}
	}
}
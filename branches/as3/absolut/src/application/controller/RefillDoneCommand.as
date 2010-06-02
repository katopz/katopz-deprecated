package application.controller
{
	import application.model.CrystalDataProxy;

	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class RefillDoneCommand extends SimpleCommand implements ICommand
	{
		private var data:CrystalDataProxy;

		override public function execute(notification:INotification):void
		{
			data = facade.retrieveProxy(CrystalDataProxy.NAME) as CrystalDataProxy;
			//data.refillDone();//notification.getBody()[0], notification.getBody()[1]);
		}
	}
}
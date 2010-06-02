package application.view
{
	import application.ApplicationFacade;
	import application.model.CrystalDataProxy;
	import application.view.components.Menu;

	import flash.events.Event;
	import flash.media.Sound;

	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class MenuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MenuMediator";

		private var data:CrystalDataProxy;
		private var alertSound:Sound;

		public function MenuMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);

			data = facade.retrieveProxy(CrystalDataProxy.NAME) as CrystalDataProxy;

			menu.addEventListener(Menu.START, onStart);
			menu.addEventListener(Menu.RULES, onRules);
			menu.addEventListener(Menu.HINT, onHint);
		}

		override public function listNotificationInterests():Array
		{
			return [];
		}

		override public function handleNotification(notification:INotification):void
		{

		}

		protected function get menu():Menu
		{
			return viewComponent as Menu;
		}

		private function onStart(event:Event):void
		{
			if (!data.inGame)
			{
				sendNotification(ApplicationFacade.START_GAME);
				data.inGame = true;
			}
			else
			{
				sendNotification(ApplicationFacade.RESTART_REQUEST);
			}
		}

		private function onRules(event:Event):void
		{
			sendNotification(ApplicationFacade.SHOW_RULES);
		}

		private function onHint(event:Event):void
		{
			sendNotification(ApplicationFacade.SHOW_HINT, data.getCrystals());
		}
	}
}
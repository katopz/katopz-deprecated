package application.view
{
	import application.ApplicationFacade;
	import application.model.CrystalDataProxy;
	import application.view.components.Board;
	import application.view.components.Crystal;
	
	import com.sleepydesign.system.DebugUtil;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class BoardMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "BoardMediator";

		private var data:CrystalDataProxy;

		public function BoardMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);

			data = facade.retrieveProxy(CrystalDataProxy.NAME) as CrystalDataProxy;

			//board.soundState = data.soundState;
			board.moveSignal.add(onUserMove);
			board.effectSignal.add(onEffectDone);
			board.gameoverSignal.add(onGameOver);
		}

		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.START_GAME,
				ApplicationFacade.RESTART_GAME,
				ApplicationFacade.GAME_OVER,
				ApplicationFacade.REFILL_DONE,
				ApplicationFacade.USER_MOVE_DONE,
				ApplicationFacade.SHOW_HINT];
		}

		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationFacade.START_GAME:
					//already shuffle data while init//board.shuffle();
					board.initView(data.getCrystals());
					board.enabled = true;
					break;

				case ApplicationFacade.RESTART_GAME:
					//already shuffle data by command//board.shuffle();
					board.enabled = true;
					break;

				case ApplicationFacade.GAME_OVER:
					board.enabled = false;
					break;

				case ApplicationFacade.REFILL_DONE:
					board.refill(data.getCrystals(), notification.getBody() as Boolean);
					break;
				case ApplicationFacade.SHOW_HINT:
					board.showHint(notification.getBody() as Vector.<Crystal>);
					break;
				
				case ApplicationFacade.USER_MOVE_DONE:
					board.showSwapEffect(notification.getBody() as Boolean);
					break;
			}
		}

		protected function get board():Board
		{
			return viewComponent as Board;
		}

		private function onUserMove(sourceID:int, targetID:int):void
		{
			sendNotification(ApplicationFacade.USER_MOVE, {sourceID:sourceID, targetID:targetID} );
		}

		private function onEffectDone():void
		{
			sendNotification(ApplicationFacade.EFFECT_DONE);
		}

		private function onGameOver():void
		{
			sendNotification(ApplicationFacade.GAME_OVER);
		}
	}
}
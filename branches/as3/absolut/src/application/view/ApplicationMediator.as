package application.view
{
	import application.ApplicationFacade;
	import application.model.CrystalDataProxy;
	import application.view.components.Board;
	import application.view.components.Menu;

	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.core.CommandManager;
	import com.sleepydesign.display.PopupUtil;

	import flash.display.StageScaleMode;

	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";

		// Model
		private var data:CrystalDataProxy;

		// Assets
		private var menu:Menu;
		private var board:Board;

		public function ApplicationMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);

			// Stage setup.
			main.stage.scaleMode = StageScaleMode.NO_SCALE;

			// Retrieve proxies.
			data = facade.retrieveProxy(CrystalDataProxy.NAME) as CrystalDataProxy;

			drawAssets();
		}

		override public function listNotificationInterests():Array
		{
			return [ApplicationFacade.GAME_OVER, 
				ApplicationFacade.RESTART_REQUEST];
		}

		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationFacade.GAME_OVER:
					trace(" ! Game over...do something? dialog?");
					// menu
					PopupUtil.popup(main, new SDDialog(<question>Game Over!
							<answer src="as:onGameOverOK()">OK</answer>
						</question>, this));
					break;

				case ApplicationFacade.RESTART_REQUEST:
					PopupUtil.popup(main, new SDDialog(<question>Restart?
							<answer src="as:onRestart(true)">OK</answer>
							<answer src="as:onRestart(false)">Cancel</answer>
						</question>, this));
					break;
			}
		}

		public function onGameOverOK():void
		{
			PopupUtil.popdown();
			sendNotification(ApplicationFacade.RESTART_GAME);
		}

		public function onRestart(isNeedRestart:Boolean):void
		{
			var _popupCommandManager:CommandManager = new CommandManager();
			_popupCommandManager.addCommand(new PopupCommand);
			if (isNeedRestart)
				_popupCommandManager.addCommand(new RestartCommand(this));
			_popupCommandManager.start();
		}

		protected function get main():Main
		{
			return viewComponent as Main;
		}

		private function drawAssets():void
		{
			board = new Board();
			facade.registerMediator(new BoardMediator(board));
			main.addChild(board);

			menu = new Menu();
			facade.registerMediator(new MenuMediator(menu));
			main.addChild(menu);
		}
	}
}

import application.ApplicationFacade;
import application.model.CrystalDataProxy;

import com.sleepydesign.core.SDCommand;
import com.sleepydesign.display.PopupUtil;

import org.puremvc.as3.patterns.mediator.Mediator;

internal class PopupCommand extends SDCommand
{
	override public function doCommand():void
	{
		PopupUtil.popdown(super.doCommand);
	}
}

internal class RestartCommand extends SDCommand
{
	private var _caller:Mediator;

	public function RestartCommand(caller:Mediator)
	{
		_caller = caller;
	}

	override public function doCommand():void
	{
		_caller.sendNotification(ApplicationFacade.RESTART_GAME);
		_caller = null;
	}
}

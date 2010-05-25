package application.view
{
	import application.ApplicationFacade;
	import application.model.DataProxy;
	import application.view.components.Board;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		// Model.
		private var data:DataProxy;
		
		// Assets.
		private var board:Board;
		private var loop:Sound;
		private var channel:SoundChannel;
		private var transform:SoundTransform;
		
		public function ApplicationMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			// Stage setup.
			main.stage.align = StageAlign.TOP_LEFT;
			main.stage.scaleMode = StageScaleMode.NO_SCALE;
			//main.stage.addEventListener(Event.RESIZE, alignContent);
			
			// Retrieve proxies.
			data = facade.retrieveProxy( DataProxy.NAME ) as DataProxy;
			
			drawAssets();
		}
		
		override public function listNotificationInterests():Array
		{
			return new Array( ApplicationFacade.GAME_OVER,
							  ApplicationFacade.RESTART_REQUEST,
							  ApplicationFacade.DRAWN_GAME,
							  ApplicationFacade.SHOW_RULES,
							  ApplicationFacade.SHOW_HISTORY,
							  ApplicationFacade.SHOW_OPTIONS );
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch( notification.getName() )
			{
				case ApplicationFacade.GAME_OVER:
					var winner:Number = notification.getBody().tile;
					/*
					if ( winner == 1 )
					{
						userWinCount.text = "USR:" + data.userWinCount;
					}
					else
					{
						AIWinCount.text = "CPU:" + data.AIWinCount;
					}
					*/
					break;
				
				case ApplicationFacade.RESTART_REQUEST:
					/*
					showModal();
					showAlert("This will restart your current game.\nAre you sure?", AlertBox.YES);
					
					alignContent();
					*/
					break;
				
				case ApplicationFacade.DRAWN_GAME:
					/*
					showModal();
					showAlert("Only draw is available.\nTry again.", AlertBox.OK);
					
					alignContent();
					*/
					break;
				
				case ApplicationFacade.SHOW_RULES:
					/*
					showModal();
					showInfo("rules", info.rules);
					
					alignContent();
					*/
					break;
				
				case ApplicationFacade.SHOW_HISTORY:
					/*
					showModal();
					showInfo("history", info.history);
					
					alignContent();
					*/
					break;
				
				case ApplicationFacade.SHOW_OPTIONS:
					/*
					showModal();
					showOptions();
					
					alignContent();
					*/
					break;
			}
		}
		
		protected function get main():Main
		{
			return viewComponent as Main;
		}
		
		// Modal handling functions.
		private function showModal():void
		{
			//
		}
		
		private function hideModal():void
		{
			//
		}
		
		private function removeModal():void
		{
			//
		}
		
		// Alert functions.
		private function showAlert(message:String, mode:String):void
		{
			//
		}
		
		private function onYes(event:Event):void
		{
			//
		}
		
		private function removeAlert(event:Event = null):void
		{
			//
		}
		
		// Info functions.
		private function showInfo(title:String, message:String):void
		{
			//
		}
		
		private function onClose(event:Event):void
		{
			//
		}
		
		// Options box.
		private function showOptions():void
		{
			//
		}
		
		private function hideOptions(event:Event):void
		{
			//
		}
		
		private function drawAssets():void
		{
			board = new Board();
			facade.registerMediator( new BoardMediator(board) );
			main.addChild(board);
		}
		
		private function onSoundOn(event:Event):void
		{
			//
		}
		
		private function onSoundOff(event:Event):void
		{
			//
		}
		
		private function setSound(value:Boolean):void
		{
			//
		}
	}
}
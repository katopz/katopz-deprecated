package com.cutecoma.playground.core
{
	import com.cutecoma.game.core.Game;
	import com.cutecoma.game.events.PlayerEvent;
	import com.cutecoma.playground.components.SDChatBox;
	import com.cutecoma.playground.components.SDConnector;
	
	import flash.display.Sprite;

	public class Chat
	{
		private var _game:Game;
		private var _rtmpURI:String;

		private var connector:SDConnector;
		
		public var canvas:Sprite;

		public function Chat(game:Game, rtmpURI:String)
		{
			_game = game;
			_rtmpURI = rtmpURI;
		}

		public function gotoArea(areaID:String):void
		{
			// update server
			connector.exitRoom();

			// wait for exit complete?
			connector.addEventListener(SDEvent.COMPLETE, onEnterRoom);
			connector.addEventListener(SDEvent.UPDATE, onEnterRoom);
			connector.enterRoom(areaID);
		}

		private function onEnterRoom(event:SDEvent):void
		{
			connector.removeEventListener(SDEvent.COMPLETE, onEnterRoom);
			connector.removeEventListener(SDEvent.UPDATE, onEnterRoom);

			// tell everybody i'm enter
			_game.player.enter();
		}

		public function bindPlayer():void
		{
			// bind player -> connector
			_game.player.addEventListener(PlayerEvent.UPDATE, connector.onClientUpdate);
		}

		public function createConnector(id:String):void
		{
			//connector = new SDConnector(this, "rtmp://localhost/SOSample", "lobby");
			connector = new SDConnector(_rtmpURI, id);
			connector.x = 100;
			connector.y = 20;
			
			canvas.addChild(connector);
			//connector.visible = false;

			// bind connector -> game
			connector.addEventListener(SDEvent.UPDATE, function(event:SDEvent):void
				{
					trace(" ^ onUpdate : " + event);
					try
					{
						_game.update(event.data);
					}
					catch (e:*)
					{
						trace(e);
					}
				});
		}
		
		private var _chatBox:SDChatBox;
		
		public function createChatBox():void
		{
			_chatBox = new SDChatBox();
			_chatBox.x = 100;
			_chatBox.y = 40;
			canvas.addChild(_chatBox);
			
			// bind chat -> player
			//canvas.addEventListener(SDEvent.UPDATE, onTalk);
		}
	}
}
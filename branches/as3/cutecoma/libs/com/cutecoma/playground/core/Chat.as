package com.cutecoma.playground.core
{
	import away3dlite.containers.Particles;
	import away3dlite.containers.View3D;
	import away3dlite.core.base.Particle;
	import away3dlite.materials.ParticleMaterial;
	
	import com.cutecoma.game.core.Game;
	import com.cutecoma.game.events.PlayerEvent;
	import com.cutecoma.game.player.Player;
	import com.cutecoma.playground.components.SDChatBox;
	import com.cutecoma.playground.components.SDChatBubble;
	import com.cutecoma.playground.components.SDConnector;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	public class Chat
	{
		private var _game:Game;
		private var _rtmpURI:String;

		private var connector:SDConnector;
		
		public var canvas:Sprite;
		
		private var _bubbles:Dictionary;
		private var _bubbleParticles:Particles;
		
		private var _bitmap:Bitmap;
		/**
		 * TODO : Why i need game as params here huh?
		 */
		public function Chat(game:Game, rtmpURI:String)
		{
			_game = game;
			_rtmpURI = rtmpURI;
			
			_bubbles = new Dictionary(true);
			_bubbleParticles = new Particles();
			_game.engine3D.scene3D.addChild(_bubbleParticles);
			
			// draw tobitmap
			var view3D:View3D = _game.engine3D.view3D;
			_bitmap = _bubbleParticles.bitmap = new Bitmap(new BitmapData(_game.engine3D.screenRect.width, _game.engine3D.screenRect.height, true, 0x00000000));
			_game.engine3D.contentLayer.addChild(_bitmap);
		}

		public function gotoArea(areaID:String):void
		{
			// update server
			connector.exitRoom();

			// wait for exit complete?
			//connector.addEventListener(SDEvent.COMPLETE, onEnterRoom);
			//connector.addEventListener(SDEvent.UPDATE, onEnterRoom);
			connector.completeSignal.addOnce(onEnterRoom);
			
			connector.enterRoom(areaID);
		}

		private function onEnterRoom(event:SDEvent):void
		{
			//connector.removeEventListener(SDEvent.COMPLETE, onEnterRoom);
			//connector.removeEventListener(SDEvent.UPDATE, onEnterRoom);

			// tell everybody i'm enter
			_game.currentPlayer.enter();
		}

		public function bindPlayer():void
		{
			// bind player -> connector
			_game.currentPlayer.addEventListener(PlayerEvent.UPDATE, connector.onClientUpdate);
			
			// bind player position from game model
			_game.currentPlayer.positionSignal.add(onPlayerPositionChange);
			_game.currentPlayer.talkSignal.add(onPlayerTalkChange);
			
			// add ballon, TODO move to JIT add onTalk
			//canvas.addChild(_bubbles[_game.currentPlayer.id] = new SDDialog("hello"));
		}
		
		private function onPlayerPositionChange(id:String, position:Vector3D):void
		{
			setBubblePosition(id, position);
		}
		
		private function onPlayerTalkChange(id:String, position:Vector3D, msg:String):void
		{
			var _bubble:SDChatBubble = _bubbles[id];
			var _bubbleParticle:Particle;
			
			if(!_bubble)
			{
				_bubble = new SDChatBubble(msg);
				
				// TODO : ParticleMovieMaterial
				var _bitmapData:BitmapData = new BitmapData(_bubble.width, _bubble.height, true, 0x00000000);
				_bitmapData.draw(_bubble);
				
				var _particleMaterial:ParticleMaterial = new ParticleMaterial(_bitmapData);
				_bubbleParticle = new Particle(position.x, position.y, position.z, _particleMaterial);
				_bubbleParticle.id = id;
				
				_bubbleParticles.addParticle(_bubbleParticle);
				
				_bubbles[id] = _bubble;
			}else{
				_bubble.htmlText = msg;
				_bubbleParticle = _bubbleParticles.getParticleByID(id);
			}
			
			setBubblePosition(id, position);
		}
		
		private function setBubblePosition(id:String, position:Vector3D):void
		{
			var _bubble:SDChatBubble = _bubbles[id];
			var _bubbleParticle:Particle;
			if(_bubble)
			{
				_bubbleParticle = _bubbleParticles.getParticleByID(id);
				
				_bubbleParticle.x = position.x;
				_bubbleParticle.y = position.y;
				_bubbleParticle.z = position.z;
				
				var player:Player = _game.getPlayerByID(id);
				_bubbleParticle.y += player.model.minBounding.y -_bubble.height;
			}
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
			//connector.addEventListener(SDEvent.UPDATE, function(event:SDEvent):void
			connector.updateSignal.add(onConnectorUpdate);
		}
		
		private function onConnectorUpdate(data:Object):void
		{
			trace(" ^ onUpdateFromServer");
			try{
				_game.update(data);
			}catch (e:*){
				trace(e);
			}
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
			_chatBox.updateSignal.add(onTalk);
		}
		
		// TODO : define msgData
		private function onTalk(data:Object):void
		{
			trace(" ^ onTalk : " + event);
			_game.currentPlayer.update({id: _game.currentPlayer.id, msg: data.msg});
		}
	}
}
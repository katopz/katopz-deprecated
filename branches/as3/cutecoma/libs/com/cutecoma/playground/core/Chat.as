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
	import com.sleepydesign.system.DebugUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	public class Chat
	{
		private var _game:Game;
		private var _rtmpURI:String;

		private var _connector:SDConnector;
		
		public var layer:Sprite;
		
		// TODO replace with linklist
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
			
			// draw bubble to bitmap
			var view3D:View3D = _game.engine3D.view3D;
			_bitmap = _bubbleParticles.bitmap = new Bitmap(new BitmapData(_game.engine3D.screenRect.width, _game.engine3D.screenRect.height, true, 0x00000000));
			_game.engine3D.contentLayer.addChild(_bitmap);
			
			_game.playerRemovedSignal.add(onPlayerRemoved);
		}

		public function gotoArea(areaID:String):void
		{
			// update server
			_connector.exitRoom();

			// wait for exit complete?
			//connector.addEventListener(SDEvent.COMPLETE, onEnterRoom);
			//connector.addEventListener(SDEvent.UPDATE, onEnterRoom);
			_connector.initSignal.addOnce(onEnterRoom);
			
			_connector.enterRoom(areaID);
		}

		private function onEnterRoom():void
		{
			//connector.removeEventListener(SDEvent.COMPLETE, onEnterRoom);
			//connector.removeEventListener(SDEvent.UPDATE, onEnterRoom);

			// tell everybody i'm enter
			_game.currentPlayer.enter();
		}

		public function bindCurrentPlayer():void
		{
			// bind player -> connector
			_game.currentPlayer.addEventListener(PlayerEvent.UPDATE, _connector.onClientUpdate);
			
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
				
				var _bitmapData:BitmapData = new BitmapData(_bubble.width, _bubble.height, true, 0x00000000);
				_bitmapData.draw(_bubble);
				
				var _particleMaterial:ParticleMaterial = new ParticleMaterial(_bitmapData);
				_bubbleParticle = new Particle(_particleMaterial, position.x, position.y, position.z);
				
				// bind bubble by id
				_bubbleParticle.id = _bubble.id = id;
				
				_bubbleParticles.addParticle(_bubbleParticle);
				
				_bubbles[id] = _bubble;
				
				// listen for update
				_bubble.drawSignal.add(onBubbleDraw);
			}else{
				_bubble.htmlText = msg;
				_bubbleParticle = _bubbleParticles.getParticleByID(id);
			}
			
			setBubblePosition(id, position);
		}
		
		private function onBubbleDraw(_bubble:SDChatBubble):void
		{
			DebugUtil.trace(" ^ onBubbleDraw");
			
			var _bubbleParticle:Particle = _bubbleParticles.getParticleByID(_bubble.id);
			var _particleMaterial:ParticleMaterial = _bubbleParticle.material;
			
			var _bitmapData:BitmapData = _particleMaterial.bitmapData;
			_bitmapData.dispose();
			
			_bitmapData = new BitmapData(_bubble.width, _bubble.height, true, 0x00000000);
			_particleMaterial.rect = new Rectangle(0, 0, _bitmapData.width, _bitmapData.height);
			_bitmapData.draw(_bubble);
			
			_particleMaterial.bitmapData = _bitmapData;
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
			_connector = new SDConnector(_rtmpURI, id);
			_connector.x = 100;
			_connector.y = 20;
			
			layer.addChild(_connector);
			//connector.visible = false;

			// bind connector -> game
			//connector.addEventListener(SDEvent.UPDATE, function(event:SDEvent):void
			_connector.updateSignal.add(onConnectorUpdate);
		}
		
		private function onConnectorUpdate(data:Object):void
		{
			DebugUtil.trace(" ^ onUpdateFromServer");
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
			layer.addChild(_chatBox);
			
			// bind chat -> player
			//canvas.addEventListener(SDEvent.UPDATE, onTalk);
			_chatBox.updateSignal.add(onCurrentPlayerChat);
		}
		
		// TODO : define msgData
		private function onCurrentPlayerChat(data:Object):void
		{
			DebugUtil.trace(" ^ onTalk");
			_game.currentPlayer.update({id: _game.currentPlayer.id, msg: data.msg});
		}
		
		// Destroy ---------------------------------------------------
		
		private function onPlayerRemoved(player:Player):void
		{
			player.removeEventListener(PlayerEvent.UPDATE, _connector.onClientUpdate);
			player.positionSignal.remove(onPlayerPositionChange);
			player.talkSignal.remove(onPlayerTalkChange);
			
			// bubble
			var _bubble:SDChatBubble = _bubbles[player.id];
			if(_bubble)
			{
				_bubble.drawSignal.remove(onBubbleDraw);
				
				_bubble.destroy();
				_bubble = null;
				_bubbles[player.id] = null;
			}
		}
		
		// --------------------------------------------------- Destroy
	}
}
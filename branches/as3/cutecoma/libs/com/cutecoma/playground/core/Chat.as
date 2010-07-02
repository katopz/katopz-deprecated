package com.cutecoma.playground.core
{
	import away3dlite.containers.Particles;
	import away3dlite.core.base.Particle;
	import away3dlite.materials.ParticleMaterial;
	
	import com.cutecoma.game.core.Game;
	import com.cutecoma.game.events.PlayerEvent;
	import com.cutecoma.playground.components.SDChatBox;
	import com.cutecoma.playground.components.SDConnector;
	import com.sleepydesign.components.SDDialog;
	
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
		
		private var _balloons:Dictionary;
		private var _balloonParticles:Particles;

		public function Chat(game:Game, rtmpURI:String)
		{
			_game = game;
			_rtmpURI = rtmpURI;
			
			_balloons = new Dictionary(true);
			_balloonParticles = new Particles();
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
			_game.currentPlayer.enter();
		}

		public function bindPlayer():void
		{
			// bind player -> connector
			_game.currentPlayer.addEventListener(PlayerEvent.UPDATE, connector.onClientUpdate);
			
			// bind player position from game model
			_game.currentPlayer.positionSignal.add(onPlayerPositionChange);
			
			// add ballon, TODO move to JIT add onTalk
			//canvas.addChild(_balloons[_game.currentPlayer.id] = new SDDialog("hello"));
		}
		
		private function onPlayerPositionChange(id:String, position:Vector3D):void
		{
			var _balloon:SDDialog = _balloons[id];
			var _balloonParticle:Particle;
			
			if(!_balloon)
			{
				_balloon = new SDDialog("test");
				
				// TODO : ParticleMovieMaterial
				var _bitmapData:BitmapData = new BitmapData(_balloon.width, _balloon.height);
				_bitmapData.draw(_balloon);
				
				var _particleMaterial:ParticleMaterial = new ParticleMaterial(_bitmapData);
				_balloonParticle = new Particle(position.x, position.y, position.z, _particleMaterial);
				_balloonParticle.id = id;
				
				_balloonParticles.addParticle(_balloonParticle);
				
				_game.engine3D.scene3D.addChild(_balloonParticles);
				
				_balloons[id] = _balloon;
			}else{
				_balloonParticle = _balloonParticles.getParticleByID(id);
			}
			
			_balloonParticle.x = position.x;
			_balloonParticle.y = position.y;
			_balloonParticle.z = position.z;
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
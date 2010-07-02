package com.cutecoma.game.core
{
	import away3dlite.core.base.Face;
	
	import com.cutecoma.game.data.PlayerData;
	import com.cutecoma.game.player.Player;
	import com.cutecoma.playground.core.World;
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.core.SDGroup;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.system.DebugUtil;
	import com.sleepydesign.utils.ObjectUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class Game extends SDSprite
	{
		protected var _engine3D:IEngine3D;
		
		//public static var inputController	: InputController;
		
		private var _world:World;
		
		public var player					: Player;
		public var players					: SDGroup;
		
		//public var warpSignal:Signal = new Signal(String/*areaID*/);
		
		//TODO : IWorld
		public function Game(engine3D:IEngine3D, world:World)
		{
			_engine3D = engine3D;
			_world = world;
			
			//_world.completeSignal.addOnce(onWorldComplete);
			
			onWorldComplete();
			
			players = new SDGroup;
		}
		
		private function onWorldComplete():void
		{
			DebugUtil.trace(" ! onWorldComplete");
			
			// bind mouse event
			_world.area.ground.mouseSignal.add(onGroundClick);
		}
		
		protected function onGroundClick(event:MouseEvent, position:Vector3D, face:Face, point:Point):void
		{
			DebugUtil.trace(" ! Click : " + position, face, point);
			_world.area.map.completeSignal.addOnce(onPathComplete);
			_world.area.map.findPath("", Position.parse(player.position), Position.parse(position));
		}
		
		protected function onPathComplete(paths:Array):void
		{
			DebugUtil.trace(" ! onPathComplete : " + paths);
			player.walk(paths);
		}

		public function start() : void
		{
			if(_engine3D)
			{
				_engine3D.start();
			}else{
				trace(" ! Error : no engine found!");
			}
		}
		
		protected function run(event:Event=null) : void
		{
			//draw();
		}
		
		public function addPlayer(_player:Player):void
		{
			// remove if any
			//removePlayer(player);
			
			// plug to gameplayers.addItem
			players.addItem(_player, _player.id);
			
			// wait for char model complete and plug to 3d Engine
			_player.playerCompleteSignal.addOnce(addCharacterModelToEngine);
			
			// bind player state to MODEL
			_player.positionSignal.add(onPlayerPositionChange);
		}
		
		private function onPlayerPositionChange(id:String, position:Vector3D, callback:Function):void
		{
			DebugUtil.trace("TODO : bind to baloon : "+id, position);
			callback();
		}
		
		public function addCharacterModelToEngine(player:Player):void
		{
			_engine3D.scene3D.addChild(player.model);
			player.model.stop();
			
			// bind player walk event
			player.walkCompleteSignal.add(onPlayerWalkComplete);
		}
		
		private function onPlayerWalkComplete(position:Vector3D):void
		{
			// drop command point?
			var commandData:* = _world.area.map.getCommand(position);
			
			//DebugUtil.trace(" ! commandData : " + commandData);
			DebugUtil.extract(commandData);
			switch(commandData.command)
			{
				case "warp" : 
					//warpSignal.dispatch(commandData.args);
					_world.gotoAreaID(commandData.args);
					break;
			}
			
			/*
			if(commandData.args)
			{
				// it's my command
				commandData.args.push(this);
				
				// apply
				applyCommand(commandData.command, commandData.args);
			}
			*/
		}
		
		public function removePlayer(_player:Player=null):void
		{
			// exist?
			if(_player)
			{
				//var _player:Player = getElementById(player.id);
				trace(" - removePlayer	: "+_player.id);
			
				// unplug from 3d Engine
				//TODEV//engine.removeChild(_player.instance);
				
				// unplug from game
				players.removeItem(_player, _player.id);
				
				_player.destroy();
				_player = null;
			}
			else
			{
				// remove all player
				for each(var __player:Player in players.items)
					removePlayer(__player);
			}
		}
		
		public function removeOtherPlayer():void
		{
			for each(var _player:Player in players.items)
			{
				if(_player!=player)
					removePlayer(_player);
			}
		}
		
		public function getPlayerByID(id:String):Player
		{
			return Player(players.getItemByID(id));
		}
		
		// ______________________________ Update ____________________________
		
		public static function applyCommand(command:String, args:Array):void
		{
			DebugUtil.trace("TODO : command warp");
			//getInstance().engine.update({command:command});
			//TODEV//SDApplication.getInstance().applyCommand({command:command, args:args});
		}
		
		public function update(data:Object=null):void
		{
			// void null
			if(!data)return;
			trace("\n * Game.update", data.act);
			ObjectUtil.print(data);
			
			/*
			// parse player data
			var playerData:PlayerData = new PlayerData();
			playerData.parse(data);
			
			var player:Player = getElementById(playerData.id);
			if(!player)
			{
				player = new Player(playerData);
				addPlayer(player);
			}
			*/
			var playerData:PlayerData = new PlayerData();
			playerData.parse(data);
			
			var _player:Player = getPlayerByID(playerData.id);
			
			if(_player != player)
			{
				// not me maybe new guy
				if(!_player)
				{
					// new guy! not in list
					_player = new Player(playerData);
					addPlayer(_player);
					
					//plug to current map
					//_player.map = player.map;
				}
				
				switch(playerData.act)
				{
					// someone enter
					case "enter":
						// do something?
						trace("enter");
					break;
					// he's gone!
					case "exit":
						removePlayer(_player);
					break;
					default :
						_player.update(playerData);
					break;
				}
			}else{
				// it's me
				// do someting? maybe god speech from server?
			}
		}
		
		override public function destroy():void
		{
			removePlayer();
			
			if(IDestroyable(_engine3D))
				IDestroyable(_engine3D).destroy();
			_engine3D = null;
		}
	}
}
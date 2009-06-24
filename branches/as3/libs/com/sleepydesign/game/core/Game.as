package com.sleepydesign.game.core
{
	import com.sleepydesign.core.SDApplication;
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.game.data.PlayerData;
	import com.sleepydesign.game.player.Player;
	import com.sleepydesign.ui.InputController;
	
	import flash.events.Event;
	import flash.filters.BlurFilter;
	
	public class Game extends SDContainer
	{
		public var engine					: AbstractEngine;
		public static var inputController	: InputController;
		
		public var player					: Player;
		
        public static function getController() : InputController 
        {
            if(inputController==null)inputController = new InputController(true);
            return inputController as InputController;
        }
        
		public static var instance : Game;
        public static function getInstance() : Game
        {
            if ( instance == null ) instance = new Game();//null, factorX, factorZ);
            return instance as Game;
        }
        
		public function Game(id:String="game", raw:Object=null)
		{
			instance = this;
			super();
		}
				
		public function start() : void
		{
			if(engine)
			{
				engine.start();
			}else{
				trace(" ! Error : no engine found!");
			}
		}
		
		protected function run(event:Event=null) : void
		{
			draw();
		}
		
		override public function destroy():void
		{
			if(inputController)
			{
				inputController.destroy();
				inputController = null;
			}
			
			removePlayer();
			
			if(engine)
			{
				engine.destroy();
				engine = null;
			}
		}
		
		public function addPlayer(player:Player):void
		{
			// remove if any
			//removePlayer(player);
			
			// plug to game
			addElement(player, player.id);
			
			// plug to 3d Engine
			engine.addChild(player.instance);
		}
		
		public function removePlayer(_player:Player=null):void
		{
			// exist?
			if(_player)
			{
				//var _player:Player = getElementById(player.id);
				trace(" - removePlayer	: "+_player);
			
				// unplug from 3d Engine
				engine.removeChild(_player.instance);
				
				// unplug from game
				removeElement(_player);
				_player.destroy();
				_player = null;
			}
			else
			{
				// remove all player
				for each(var __player:Player in elements.childs)
					removePlayer(__player);
			}
		}
		
		public function removeOtherPlayer():void
		{
			for each(var _player:Player in elements.childs)
			{
				if(_player!=player)
					removePlayer(_player);
			}
		}
		
		public function getPlayerByID(id:String):Player
		{
			return Player(getElementById(id));
		}
		
		// ______________________________ Update ____________________________
		
		public static function applyCommand(command:String, args:Array):void
		{
			//getInstance().engine.update({command:command});
			SDApplication.getInstance().update({command:command, args:args});
		}
		
		override public function update(data:Object=null):void
		{
			// void null
			if(!data)return;
			
			trace("\n * Game.update");
			
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
				}
				
				// he's gone!
				if(playerData.act=="exit")
				{
					removePlayer(_player);
				}else{
					_player.update(playerData);
				}
			}else{
				// it's me
				// do someting? maybe god speech from server?
			}
		}
	}
}
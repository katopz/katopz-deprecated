package
{
	import com.cutecoma.game.core.Game;
	import com.cutecoma.game.data.PlayerData;
	import com.cutecoma.game.events.PlayerEvent;
	import com.cutecoma.playground.core.Chat;
	import com.cutecoma.playground.core.Engine3D;
	import com.cutecoma.playground.core.World;
	import com.cutecoma.playground.data.*;
	import com.cutecoma.playground.events.AreaEditorEvent;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.events.EventManager;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.templates.ApplicationTemplate;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import com.cutecoma.playground.panels.AreaPanel;

	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="480")]
	
	/**
	 *										 .
	 *					 		[OtherUser]  .  [User]
	 *									  \	 .	/
	 *							 	  [Authenticate]---[Persistent Data]
	 *	 							      /  .  \ 
	 *						 	      [Net]  .  [UI]---[Controller]
	 *						 	          \  .  / |
	 *						 	          [Chat]  |
	 *						 	             |    |
	 *		 [SharedObject]---[MultiPlayer]  |  [Player]---[Character]---[ModelPool]
	 *					 		          \  |  /
	 *					 		  		  [Game]---[Map]---[PathFinder]
	 *					 	 	             |		  |
	 *					 		 		[Engine3D]    |
	 * 										 |		  |
	 *							 [Char]---[World]---[Area]---[Ground]
	 *							  /          |         \
	 *					  [CharEditor] [WorldEditor] [AreaEditor]
	 * 
	 */
	
	/*
	TODO :
	
	+ editor
	- test switch between area
	- flood fill
	- clean up
	- MVC
	
	+ chat
	- login via opensocial and get user char data
	- add bezier speed line to bubble
	- speed, destroy, model pool
	- scale to 1px = 1cm
	- redo particle movie material auto update
	- add frames data info to MDJ?
	- clean up
	- MVC
	
	+ lite
	- rebuild char 2x scale and fix choking stand
	- test particle position/scale issue?
	- heightmap support, test with jiglib
	- 2.5D Clip, animation controller
	- infinite loop perlin noise fog, fire
	- lenflare
	- explode effect
	*/
	public class PLWorld extends ApplicationTemplate
	{
		private const VERSION:String = "PlayGround beta 3";
		
		private var _world:World;
		private var _engine3D:Engine3D;

		private var _areaPanel:AreaPanel;

		private var _dialog:SDDialog;

		private var _selectAreaID:String = "00";

		private var _game:Game;
		private var _chat:Chat;

		private var _currentRoomID:String = "";

		public function PLWorld()
		{
			registerDataClassAlias();
			
			alpha = 0.1;
		}
		
		private function registerDataClassAlias():void
		{
			registerClassAlias("com.cutecoma.playground.data.AreaData", AreaData);
			registerClassAlias("com.cutecoma.playground.data.MapData", MapData);
			registerClassAlias("com.cutecoma.playground.data.SceneData", SceneData);
			registerClassAlias("com.cutecoma.playground.data.ViewData", ViewData);
			registerClassAlias("com.cutecoma.playground.data.CameraData", CameraData);
		}

		override protected function onInitXML():void
		{
			initEngine3D();
		}
		
		private function initEngine3D():void
		{
			_engine3D = new Engine3D();
			//_engine3D.systemLayer = _systemLayer;
			//_engine3D.contentLayer = _contentLayer;
			_engine3D.completeSignal.addOnce(onEngineInit);
			
			_engine3D.screenRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			_contentLayer.addChild(_engine3D);
		}
		
		private function onEngineInit():void
		{
			_world = new World(_engine3D, String(_xml.world.area.@path));
			_game = new Game(_engine3D, _world);
			
			_chat = new Chat(_game, String(_xml.server.@url));
			_chat.layer = _systemLayer;
			
			initMenu();
		}

		private function initMenu():void
		{
			addChild(_dialog = new SDDialog(<question><![CDATA[Welcome! What you want to do?]]>
					<answer src="as:onUserSelect('select-character')"><![CDATA[Select Character.]]></answer>
					<answer src="as:onUserSelect('enter-area')"><![CDATA[Enter Area]]></answer>
					<answer src="as:onUserSelect('edit-area')"><![CDATA[Edit Area]]>
					</answer></question>, this, "center"));
		}

		public function onUserSelect(action:String):void
		{
			if(_dialog)
				_dialog.destroy();
			_dialog = null;

			switch (action)
			{
				case "select-character":
					showCharacterPanel();
					break;
				case "enter-area":
					showAreaPanel();
					break;
				case "edit-area":
			
					break;
			}
		}

		private function showCharacterPanel():void
		{
			
		}
		
		private function showAreaPanel():void
		{
			if (!_areaPanel)
				addChild(_areaPanel = new AreaPanel());
			
			_areaPanel.changeSignal.addOnce(onAreaIDChange);
			_areaPanel.visible = true;
		}

		private function onAreaIDChange(areaID:String):void
		{
			if(_areaPanel)
				_areaPanel.destroy();
			_areaPanel = null;
			
			_selectAreaID = areaID;

			if(_dialog)
				_dialog.destroy();
			_dialog = null;
			
			_world.completeSignal.addOnce(onWolrdComplete);
			_world.areaCompleteSignal.add(onGotoArea);
			_world.gotoAreaID(_selectAreaID);
		}

		public function onWolrdComplete(areaData:AreaData):void
		{
			// init player and connector 
			initWorld(areaData);
			
			initChat(areaData);
			
			// start
			_game.start();
			
			/*
			// area can be change later!
			_world.areaCompleteSignal.add(onGotoArea);
			
			// all set! let's go!
			onGotoArea(areaData);
			*/
		}
		
		public function onGotoArea(areaData:AreaData):void
		{
			// dirty
			if (_currentRoomID != areaData.id)
			{
				// tell everybody i'm exit
				_game.currentPlayer.exit();

				// update server
				_chat.gotoArea(areaData.id);
				
				// destroy
				_game.removeOtherPlayer();

				//update area
				_world.area.update(areaData);
				////engine3D.update(areaData.scene);
				_game.currentPlayer.warp(_world.area.map.getWarpPoint(_currentRoomID));

				// TODO : actually we need to wait for connection success?
				_currentRoomID = areaData.id;
			}
		}
		
		public function initWorld(areaData:AreaData):void
		{
			// world
			//_world.createArea(areaData, areaPath);
			
			// fake player data, TODO : load from real player data via open social
			var _playerData:PlayerData = new PlayerData("player_" + (new Date().valueOf()), _world.area.map.getSpawnPoint(), "user.mdj", PlayerEvent.STAND, 3);
			
			// init current player
			_game.initCurrentPlayer(_playerData);
		}
		
		public function initChat(areaData:AreaData):void
		{
			// net	
			_currentRoomID = areaData.id;
			
			_chat.createConnector(areaData.id);
			_chat.createChatBox();
			_chat.bindCurrentPlayer();
		}
	}
}
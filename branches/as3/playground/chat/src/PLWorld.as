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

	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="480")]
	
	/**
	 *										 .
	 *					 		[OtherUser]  .  [User]
	 *									 \	 .	 /
	 *							 	  [Authenticate]---[Persistent Data]//MODEL//
	 *	 							     /   .   \ 
	 *						 	      [Net]  .  [UI]---[Controller]
	 *						 	           \ . /  |
	 *						 	          [Chat]  |
	 *						 	           / . \  |
	 *		  [SharedObject]---[MultiPlayer] . [Player]---[Character]---[ModelPool]
	 *					 		           \ . /
	 *					 		  [Chat]---[Game]---[Map]---[PathFinder]
	 *					 	 	             |		  |
	 *					 		 //VIEW//[Engine3D]   |
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
	- speed, destroy, model pool
	- scale to 1px = 1cm
	- redo particle movie materail auto update
	- add frames data info to MDJ?
	- login via opensocial
	- clean up
	- MVC
	
	+ lite
	- fix equal w/h particle
	- heightmap support, test with jiglib
	- 2.5D Clip, animation controller
	- infinite loop perlin noise fog, fire
	- lenflare
	- explode effect
	*/
	public class PLWorld extends ApplicationTemplate
	{
		private const VERSION:String = "PlayGround beta 3";
		private const SERVER_URI:String = "rtmp://www.digs.jp/SOSample";
		//private const SERVER_URI:String = "rtmp://pixelliving.com/chat";
		//private const SERVER_URI:String = "rtmp://localhost/SOSample";
		
		private var _world:World;
		private var _engine3D:Engine3D;

		private var areaPanel:AreaPanel;

		private var dialog:SDDialog;

		private var _selectAreaID:String = "00";

		private var _game:Game;
		private var _chat:Chat;

		private var currentRoomID:String = "";

		public function PLWorld()
		{
			registerClassAlias("com.cutecoma.playground.data.AreaData", AreaData);
			registerClassAlias("com.cutecoma.playground.data.MapData", MapData);
			registerClassAlias("com.cutecoma.playground.data.SceneData", SceneData);
			registerClassAlias("com.cutecoma.playground.data.ViewData", ViewData);
			registerClassAlias("com.cutecoma.playground.data.CameraData", CameraData);
			
			alpha = .1;
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
			
			_chat = new Chat(_game, SERVER_URI);
			_chat.canvas = _systemLayer;
			
			initMenu();
		}

		private function initMenu():void
		{
			addChild(dialog = new SDDialog(<question><![CDATA[Welcome! What you want to do?]]>
					<!--<answer src="as:onUserSelect('edit-character')"><![CDATA[Select Character.]]></answer>-->
					<answer src="as:onUserSelect('enter-area')"><![CDATA[Enter Area]]></answer>
					<answer src="as:onUserSelect('edit-area')"><![CDATA[Edit Area]]>
					</answer></question>, this, "center"));
		}

		public function onUserSelect(action:String):void
		{
			dialog.destroy();

			switch (action)
			{
				case "enter-area":
					showAreaPanel(onAreaIDChange);
					break;
				case "edit-character":

					break;
			}
		}

		private function showAreaPanel(callback:Function):void
		{
			if (!areaPanel)
			{
				LoaderUtil.loadAsset("AreaPanel.swf", function onAreaPanelLoad(event:Event):void
					{
						if (event.type != "complete")
							return;

						areaPanel = event.target.content as AreaPanel;
						systemLayer.addChild(areaPanel);
						EventManager.addEventListener(AreaEditorEvent.AREA_ID_CHANGE, callback);
					});
			}
			else
			{
				areaPanel.visible = true;
				EventManager.addEventListener(AreaEditorEvent.AREA_ID_CHANGE, callback);
			}
		}

		private function onAreaIDChange(event:AreaEditorEvent):void
		{
			_selectAreaID = event.areaID;

			EventManager.removeEventListener(AreaEditorEvent.AREA_ID_CHANGE, onAreaIDChange);
			dialog.destroy();
			
			_world.completeSignal.addOnce(onWolrdComplete);
			_world.areaCompleteSignal.add(onGotoArea);
			_world.gotoAreaID(event.areaID);
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
			if (currentRoomID != areaData.id)
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
				_game.currentPlayer.warp(_world.area.map.getWarpPoint(currentRoomID));

				// TODO : actually we need to wait for connection success?
				currentRoomID = areaData.id;
			}
		}

		public function initWorld(areaData:AreaData):void
		{
			// world
			//_world.createArea(areaData, areaPath);
			
			// fake player data, TODO : load from real player data via open social
			var _playerData:PlayerData = new PlayerData("player_" + (new Date().valueOf()), _world.area.map.getSpawnPoint(), "user.mdj", PlayerEvent.STAND, 3);
			
			_game.initPlayer(_playerData);
		}
		
		public function initChat(areaData:AreaData):void
		{
			// net	
			currentRoomID = areaData.id;
			
			_chat.createConnector(areaData.id);
			_chat.createChatBox();
			_chat.bindPlayer();
		}
	}
}
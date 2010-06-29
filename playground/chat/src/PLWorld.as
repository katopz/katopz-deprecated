package
{
	import com.cutecoma.game.core.Game;
	import com.cutecoma.game.data.PlayerData;
	import com.cutecoma.game.events.PlayerEvent;
	import com.cutecoma.game.player.Player;
	import com.cutecoma.playground.components.SDChatBox;
	import com.cutecoma.playground.components.SDConnector;
	import com.cutecoma.playground.core.Engine3D;
	import com.cutecoma.playground.core.World;
	import com.cutecoma.playground.data.*;
	import com.cutecoma.playground.events.AreaEditorEvent;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.events.EventManager;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.templates.ApplicationTemplate;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.IExternalizable;

	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="480")]
	
	/**
	 *										 .
	 *					 		[OtherUser]  .  [User]
	 *									 \	 .	 /
	 *							 	  [Authenticate]---[Persistent Data]//MODEL//
	 *	 							     /   .   \ 
	 *						 	     [Net]   .   [UI]---[Controller]
	 *						 	       |     .    |
	 *		  [SharedObject]---[MultiPlayer] . [Player]---[Character]---[ModelPool]
	 *					 		          \  .  /
	 *					 		//CONTROL//[Game]---[Map]---[PathFinder]
	 *					 	 	             |		  |
	 *					 		 //VIEW//[Engine3D]   |
	 * 										 |		  |
	 *							 [Char]---[World]---[Area]---[Ground]
	 *							  /          |         \
	 *					  [CharEditor]-[WorldEditor]-[AreaEditor]
	 * 
	 */
	
	/*
	TODO :
	
	+ editor
	//- switch between area //reload other area -> destroy -> create
	//- view FPS controller
	- flood fill
	//- import/export external bitmap as map
	//- load and save as other id
	//- add wire frame box for estimate scene height
	- clean up
	- MVC
	
	+ chat
	//- load MDJ 
	- test path finder 
	- test action
	- speed, destroy, model pool
	- test switch between area
	- login via opensocial
	- model bounding box
	- clean up
	- MVC
	
	+ lite
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

		private var _isEditArea:Boolean = false;

		private var dialog:SDDialog;

		private var _selectAreaID:String = "00";

		private var connector:SDConnector;

		private var _game:Game;

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

		override protected function onInit():void
		{
			_engine3D = new Engine3D();
			_engine3D.systemLayer = _systemLayer;
			_engine3D.contentLayer = _contentLayer;
			_engine3D.completeSignal.addOnce(onEngineInit);

			addChild(_engine3D);
		}

		private function onEngineInit():void
		{
			_world = new World(_engine3D);
			_game = new Game(_engine3D, _world);
		}

		override protected function onInitXML():void
		{
			_world.areaPath = String(_xml.world.area.@path);

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
				case "edit-area":
					_isEditArea = true;
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
			gotoAreaID(event.areaID);
		}

		private function gotoAreaID(id:String):void
		{
			LoaderUtil.load(_world.areaPath + id + ".ara", onAreaLoad);
		}

		public function gotoArea(areaData:AreaData):void
		{
			if (!_world.area)
			{
				//areaData.background = _world.areaPath + areaData.background;
				createArea(areaData, _world.areaPath);
				currentRoomID = areaData.id;
				return;
			}

			// dirty
			if (currentRoomID != areaData.id)
			{
				// tell everybody i'm exit
				_game.player.exit();

				// update server
				connector.exitRoom();

				// wait for exit complete?
				connector.addEventListener(SDEvent.COMPLETE, onEnterRoom);
				connector.addEventListener(SDEvent.UPDATE, onEnterRoom);
				connector.enterRoom(areaData.id);

				// destroy
				_game.removeOtherPlayer();

				//update area
				_world.area.update(areaData);
				////engine3D.update(areaData.scene);
				_game.player.warp(_world.area.map.getWarpPoint(currentRoomID));

				// TODO : actually we need to wait for connection success?
				currentRoomID = areaData.id;
			}
		}

		private function onEnterRoom(event:SDEvent):void
		{
			connector.removeEventListener(SDEvent.COMPLETE, onEnterRoom);
			connector.removeEventListener(SDEvent.UPDATE, onEnterRoom);
			// tell everybody i'm enter
			_game.player.enter();
		}

		public function createArea(areaData:AreaData, areaPath:String):void
		{
			// world
			_world.createArea(areaData, areaPath);
			
			// fake player data, TODO : load from real player data via open social
			var _playerData:PlayerData = new PlayerData("player_" + (new Date().valueOf()), _world.area.map.getSpawnPoint(), "user.mdj", PlayerEvent.STAND, 3);
			
			// player
			_game.player = new Player(_playerData); //new PlayerData("player_" + (new Date().valueOf()), area.map.getSpawnPoint(), "man1", "stand", 3));

			// read map
			_game.player.map = _world.area.map;

			_game.addPlayer(_game.player);
			_game.player.talk(VERSION);

			// net	
			createConnector(areaData.id);
			createChatBox();

			// bind player -> connector
			_game.player.addEventListener(PlayerEvent.UPDATE, connector.onClientUpdate);

			// start
			_game.start();
		}
		
		// _______________________________________________________ Connector
		
		private function createConnector(id:String):void
		{
			//connector = new SDConnector(this, "rtmp://localhost/SOSample", "lobby");
			connector = new SDConnector(SERVER_URI, id);
			connector.x = 100;
			connector.y = 20;
			systemLayer.addChild(connector);
			//connector.visible = false;
			
			// bind connector -> game
			connector.addEventListener(SDEvent.UPDATE, function (event:SDEvent):void
			{
				trace(" ^ onUpdate : " + event);
				try{
					_game.update(event.data);
				}catch (e:*){
					trace(e);
				}
			});
		}
		
		// _______________________________________________________ Chat
		
		private var chatBox:SDChatBox;
		
		private function createChatBox():void
		{
			chatBox = new SDChatBox();
			chatBox.x = 100;
			chatBox.y = 40;
			systemLayer.addChild(chatBox);
			
			// bind chat -> player
			chatBox.addEventListener(SDEvent.UPDATE, onTalk);
		}
		
		private function onTalk(event:SDEvent):void
		{
			trace(" ^ onTalk : " + event);
			_game.player.update({id: _game.player.id, msg: event.data.msg});
		}

		private function onAreaLoad(event:Event):void
		{
			var areaData:AreaData
			if (event.type == "complete")
			{
				// exist area
				areaData = new AreaData();
				IExternalizable(areaData).readExternal(event.target.data);

				// todo dispatch
				gotoArea(areaData);
			}
			else if (event.type == IOErrorEvent.IO_ERROR && _isEditArea)
			{
				// new area
				areaData = new AreaData(_selectAreaID, _world.areaPath + _selectAreaID + "_bg.swf", 40, 40);

				// todo dispatch
				gotoArea(areaData);
			}
		}
	}
}
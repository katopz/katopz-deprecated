package
{
	import com.cutecoma.game.core.*;
	import com.cutecoma.game.data.*;
	import com.cutecoma.game.events.PlayerEvent;
	import com.cutecoma.game.player.Player;
	import com.cutecoma.playground.components.SDChatBox;
	import com.cutecoma.playground.components.SDConnector;
	import com.cutecoma.playground.core.*;
	import com.cutecoma.playground.data.*;
	import com.cutecoma.playground.editors.WorldEditor;
	import com.cutecoma.playground.events.AreaEditorEvent;
	import com.greensock.plugins.*;
	import com.sleepydesign.application.core.SDApplication;
	import com.sleepydesign.components.*;
	import com.sleepydesign.events.*;
	import com.sleepydesign.managers.EventManager;
	import com.sleepydesign.utils.*;

	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.registerClassAlias;
	import flash.utils.*;

	import net.hires.debug.Stats;

	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="480")]

	/*

	   [User]
	   Select Charactor -> Select Area -> Play

	   [Editor]
	   Edit Charactor -> Edit Area -> View

	 */
	public class main extends SDApplication
	{
		private const VERSION:String = "PlayGround 2.4";
		//private const SERVER_URI:String = "rtmp://www.digs.jp/SOSample";
		private const SERVER_URI:String = "rtmp://pixelliving.com/chat";
		//private const SERVER_URI:String = "rtmp://localhost/SOSample";
		
		registerClassAlias("com.cutecoma.playground.data.AreaData", AreaData);
		registerClassAlias("com.cutecoma.playground.data.MapData", MapData);
		registerClassAlias("com.cutecoma.playground.data.SceneData", SceneData);
		registerClassAlias("com.cutecoma.playground.data.CameraData", CameraData);
		
		private var engine3D:Engine3D;
		private var game:Game;
		private var connector:SDConnector;

		private var _isEditArea:Boolean = false;
		private var worldEditor:WorldEditor;

		private var area:Area;

		private var currentRoomID:String = "";

		private var configs:Dictionary = new Dictionary();

		private var dialog:SDDialog;

		private var areaPanel:AreaPanel;

		private var _selectAreaID:String = "00";

		public function main()
		{
			//SleepyDesign.stage = stage;
			super("PlayGround");
			addEventListener(Event.ADDED_TO_STAGE, onStage);

			SystemUtil.addContext(this, "Show stats", toggleStat);
		}

		protected function toggleStat(event:Event):void
		{
			if (!stats)
				system.addChild(stats = new Stats());
			else
			{
				system.removeChild(stats);
				stats = null;
			}
		}

		protected function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			LoaderUtil.loadXML("config.xml", onGetConfig);
		}

		private function onGetConfig(event:Event):void
		{
			if (event.type != "complete")
				return;

			var _xml:XML = event.target.data;
			PixelLiving.areaPath = String(_xml.world.area.@path);

			setupMenu();
		}

		private function setupMenu():void
		{
			dialog = new SDDialog(
				<question><![CDATA[Welcome! What you want to do?]]>
					<!--<answer src="as:onUserSelect('edit-character')"><![CDATA[Select Character.]]></answer>-->
					<answer src="as:onUserSelect('enter-area')"><![CDATA[Enter Area]]></answer>
					<answer src="as:onUserSelect('edit-area')"><![CDATA[Edit Area]]>
				</answer></question>, this);

			this.addChild(dialog);
		}

		public function getConfigByAreaID(id:String):AreaData
		{
			return configs[id];
		}

		public function onUserSelect(action:String):void
		{
			dialog.destroy();

			switch (action)
			{
				case "edit-area":
					_isEditArea = true;
				case "enter-area":
					LoaderUtil.loadAsset("AreaPanel.swf", onAreaPanelLoad);
					break;
				case "edit-character":

					break;
			}
		}

		private function onAreaPanelLoad(event:Event):void
		{
			if (event.type != "complete")
				return;
			areaPanel = event.target.content as AreaPanel;
			areaPanel.isEdit = _isEditArea;
			SDApplication.system.addChild(areaPanel);
			EventManager.addEventListener(AreaEditorEvent.AREA_ID_CHANGE, onAreaIDChange);
		}

		private function onAreaIDChange(event:AreaEditorEvent):void
		{
			_selectAreaID = event.areaID;

			EventManager.removeEventListener(AreaEditorEvent.AREA_ID_CHANGE, onAreaIDChange);
			dialog.destroy();
			gotoAreaID(event.areaID);
		}

		// ______________________________ Create ______________________________

		public function createArea(areaData:AreaData):void
		{
			// ___________________________________________________________ 2D Layer

			// game
			game = new Game();

			area = new Area(areaData);
			content.addChild(area);

			// ___________________________________________________________ 3D Layer

			// 3D engine
			engine3D = new Engine3D(content, areaData.scene);

			// bind
			game.engine = engine3D;

			// Ground
			area.ground = new Ground(engine3D, area.map, true);
			area.ground.addEventListener(SDMouseEvent.MOUSE_DOWN, onGroundClick);

			// ___________________________________________________________ Char

			var chars:Characters = new Characters();

			chars.addCharacter(new CharacterData("man1", "assets/man1/model.swf", 1, 100, 24, ["stand", "walk", "sit"]));
			chars.addCharacter(new CharacterData("woman1", "assets/woman1/model.dae", 1, 100, 24, ["stand", "walk", "sit"]));
			chars.addCharacter(new CharacterData("man2", "assets/man2/model.dae", 1, 100, 24, ["stand", "walk", "sit"]));
			chars.addCharacter(new CharacterData("woman2", "assets/woman2/model.dae", 1, 100, 24, ["stand", "walk", "sit"]));

			//TODO : wait for user select char and add player 

			// ___________________________________________________________ Player

			game.player = new Player(new PlayerData("player_" + (new Date().valueOf()), area.map.getSpawnPoint(),
				"man1", "stand", 3));

			// read map
			game.player.map = area.map;

			game.addPlayer(game.player);
			game.player.talk(VERSION);

			// ___________________________________________________________ System Layer

			if (_isEditArea)
			{
				worldEditor = new WorldEditor(engine3D, area);
				system.addChild(worldEditor);
				worldEditor.activate();
			}else{
				createConnector(area.id);
				createChatBox();
				// bind player -> connector
				game.player.addEventListener(PlayerEvent.UPDATE, connector.onClientUpdate);
			}

			// start
			game.start();
		}

		// _______________________________________________________ Action

		private function onGroundClick(event:SDMouseEvent):void
		{
			if (!_isEditArea)
				game.player.walkTo(Position.parse(event.data.position));
		}

		// _______________________________________________________ Connector

		private function createConnector(id:String):void
		{
			//connector = new SDConnector(this, "rtmp://localhost/SOSample", "lobby");
			connector = new SDConnector(SERVER_URI, id);
			connector.x = 100;
			connector.y = 20;
			system.addChild(connector);
			//connector.visible = false;

			// bind connector -> game
			connector.addEventListener(SDEvent.UPDATE, onUpdate);
		}

		// _______________________________________________________ Chat

		private var chatBox:SDChatBox;
		
		private function createChatBox():void
		{
			chatBox = new SDChatBox();
			chatBox.x = 100;
			chatBox.y = 40;
			system.addChild(chatBox);

			// bind chat -> player
			chatBox.addEventListener(SDEvent.UPDATE, onTalk);
		}

		private function onTalk(event:SDEvent):void
		{
			trace(" ^ onTalk : " + event);
			game.player.update({id: game.player.id, msg: event.data.msg});
		}

		// _______________________________________________________ Manager

		private function onUpdate(event:SDEvent):void
		{
			trace(" ^ onUpdate : " + event);
			try
			{
				game.update(event.data);
			}
			catch (e:*)
			{
				trace(e);
			}
		}

		// _______________________________________________________ System

		private function onAreaLoad(event:Event):void
		{
			var areaData:AreaData
			if (event.type == "complete")
			{
				// exist area
				areaData = new AreaData();
				IExternalizable(areaData).readExternal(event.target.data);

				//cache
				configs[areaData.id] = areaData;

				SDApplication.getInstance()["gotoArea"](areaData);
			}
			else if (event.type == IOErrorEvent.IO_ERROR && _isEditArea)
			{
				// new area
				areaData = new AreaData(_selectAreaID, PixelLiving.areaPath + _selectAreaID + "_bg.swf", 40, 40);
				SDApplication.getInstance()["gotoArea"](areaData);
			}
		}

		// ______________________________ Update ____________________________

		override public function applyCommand(data:Object = null):void
		{
			var _player:Player = Player(data.args[1]);

			// it's my command?
			if (_player == game.player)
			{
				// and command is?
				if (data.command == "warp")
				{
					trace(" ! Warp to : " + data.args[0]);
					gotoAreaID(data.args[0]);
				}
			}
		}

		//private var _selectAreaID:String = "00";

		private function gotoAreaID(id:String):void
		{
			_data = getConfigByAreaID(id);

			// cache not exist
			if (!_data)
				LoaderUtil.load(PixelLiving.areaPath + id + ".ara", onAreaLoad);
			else
				gotoArea(_data);
		}

		public function gotoArea(areaData:AreaData):void
		{
			if (!area)
			{
				createArea(areaData);
				currentRoomID = areaData.id;
				return;
			}

			// dirty
			if (currentRoomID != areaData.id)
			{
				// tell everybody i'm exit
				game.player.exit();

				// update server
				connector.exitRoom();

				// wait for exit complete?
				connector.addEventListener(SDEvent.COMPLETE, onEnterRoom);
				connector.addEventListener(SDEvent.UPDATE, onEnterRoom);
				connector.enterRoom(areaData.id);

				// destroy
				game.removeOtherPlayer();

				//update area
				area.update(areaData);
				engine3D.update(areaData.scene);
				game.player.warp(area.map.getWarpPoint(currentRoomID));

				// TODO : actually we need to wait for connection success?
				currentRoomID = areaData.id;
			}
		}

		private function onEnterRoom(event:SDEvent):void
		{
			connector.removeEventListener(SDEvent.COMPLETE, onEnterRoom);
			connector.removeEventListener(SDEvent.UPDATE, onEnterRoom);
			// tell everybody i'm enter
			game.player.enter();
		}

		// ______________________________ Destroy ____________________________

		override public function destroy():void
		{
			game.destroy();
			area.destroy();
		}
	}
}
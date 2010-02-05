package
{
	import com.cutecoma.game.core.*;
	import com.cutecoma.game.data.*;
	import com.cutecoma.game.events.PlayerEvent;
	import com.cutecoma.game.player.Player;
	import com.cutecoma.playground.editors.WorldEditor;
	import com.cutecoma.playground.core.*;
	import com.cutecoma.playground.data.*;
	import com.cutecoma.playground.debugger.PlayerDebugger;
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

	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="480")]
	
	/*
	
	[User]
	Select Charactor -> Select Area -> Play
	
	[Editor]
	Edit Charactor -> Edit Area -> View
	
	*/
	public class main extends SDApplication
	{
		registerClassAlias("com.cutecoma.playground.data.AreaData", AreaData);
		registerClassAlias("com.cutecoma.playground.data.MapData", MapData);
		registerClassAlias("com.cutecoma.playground.data.SceneData", SceneData);
		registerClassAlias("com.cutecoma.playground.data.CameraData", CameraData);
		
		private var engine3D:Engine3D;
		private var game:Game;
		private var connector:SDConnector;

		private var _isEdit:Boolean = false;
		private var worldEditor:WorldEditor;

		private const VERSION:String = "PlayGround 2.2";

		private var area:Area;
		private const SERVER_URI:String = "rtmp://www.digs.jp/SOSample";
		//private const SERVER_URI:String = "rtmp://pixelliving.com/chat";

		private var currentRoomID:String = "";
		
		private var configs:Dictionary = new Dictionary();

		private var areaDialog:SDDialog;
		
		private var _areaPath:String;
		
		private var areaPanel:AreaPanel;
		
		public function main()
		{
			TweenPlugin.activate([AutoAlphaPlugin, GlowFilterPlugin]);
			super("PlayGround", new SDMacPreloader());

			ProfilerUtil.addStat(SDApplication.system);
		}
		
		// ______________________________ Initialize ______________________________
		
		override protected function init():void
		{
			LoaderUtil.loadXML("config.xml", onXML);
		}

		private function onXML(event:Event):void
		{
			if (event.type != "complete")
				return;

			var _xml:XML = event.target.data;
			_areaPath = String(_xml.world.area.@path);

			// TODO load from external and put to group
			//configs = new Dictionary();

			//configs[87] = config87;
			//configs[88] = config88;
			//}

			//protected function onStage(event:Event=null):void
			//{
			// ___________________________________________________________ Area

			//TODO : ask from external call, add user name 
			areaDialog = new SDDialog(
				<question><![CDATA[Welcome! Please select...]]>
					<answer src="as:onUserSelect('play')"><![CDATA[I want to play.]]></answer>
					<answer src="as:onUserSelect('edit')"><![CDATA[I want to edit.]]></answer>
				</question>, false, this);

			this.addChild(areaDialog);
		}

		public function getConfigByAreaID(id:String):AreaData
		{
			return configs[id];
		}

		public function onUserSelect(action:String):void
		{
			areaDialog.visible = false;
			if(action=="edit")
				_isEdit = true;
			LoaderUtil.loadAsset("AreaPanel.swf", onAreaPanelLoad);
		}
		
		private function onAreaPanelLoad(event:Event):void
		{
			if(event.type!="complete")return;
			areaPanel = event.target.content as AreaPanel;
			areaPanel.isEdit = _isEdit;
			SDApplication.system.addChild(areaPanel);
			EventManager.addEventListener(AreaEditorEvent.AREA_ID_CHANGE, onAreaIDChange);
		}
		
		private function onAreaIDChange(event:AreaEditorEvent):void
		{
			EventManager.removeEventListener(AreaEditorEvent.AREA_ID_CHANGE, onAreaIDChange);
			areaDialog.visible = false;
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
			area.map.x = stage.stageWidth - area.map.width;

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
				["man1", "man2", "woman1", "woman2"][0 * int(4 * Math.random())], "stand", 3));

			// read map
			game.player.map = area.map;

			game.addPlayer(game.player);
			game.player.talk(VERSION);

			// ___________________________________________________________ System Layer

			if(_isEdit)
			{
				SystemUtil.addContext(this, "Option", toggleOption);
				worldEditor = new WorldEditor(engine3D, area);
				system.addChild(worldEditor);
				worldEditor.activate();
			}
			
			
			createConnector(area.id);
			createChatBox();

			// bind player -> connector
			game.player.addEventListener(PlayerEvent.UPDATE, connector.onClientUpdate);

			// start
			game.start();
		}

		// _______________________________________________________ Action

		private function onGroundClick(event:SDMouseEvent):void
		{
			if(!worldEditor.isActivate)
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

		private function createChatBox():void
		{
			var chatBox:SDChatBox = new SDChatBox();
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
			trace(" ^ Data : " + event.data);
			try
			{
				game.update(event.data);
			}
			catch (e:*)
			{
				trace(e)
			};
		}

		// _______________________________________________________ System

		private var tree:SDTree;

		private function toggleOption(event:Event=null):void
		{
			// Engine Explorer
			if (!tree)
			{
				tree = new SDTree
				(
					<Option>
						<Open/>
						<Save/>
						<Edit>
							<Background/>
							<Map/>
						</Edit>
						<MiniMap/>
						<Grid/>
						<Axis/>
						<Debugger/>
						<Ground/>
					</Option>
				, true);

				tree.x = 10;
				tree.y = 100;
				tree.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2)]
				system.addChild(tree);
				tree.addEventListener(SDMouseEvent.CLICK, onExplorer);
				tree.visible = false;
			}
			tree.visible = !tree.visible;
		}

		private function onExplorer(event:SDEvent):void
		{
			trace(" ^ onExplorer : " + SDTreeNode(event.data.node).label);
			var _label:String = SDTreeNode(event.data.node).label;
			switch (_label)
			{
				case "MiniMap":
						area.map.visible = !area.map.visible;
					break;
				case "Debugger":
					PlayerDebugger.toggle(engine3D, game.player);
					break;
				case "Edit":
						if(worldEditor.isActivate)
							worldEditor.activate();
						else
							worldEditor.deactivate();
					break;
					/*
				case "Map":
					FileUtil.openImage(onMapLoad, ["*.png"]);
					//areaEditor.toggleTerrain(area.map);
					break;
					*/
				case "Background":
					worldEditor.areaEditor.setupBackground();
					break;
				case "Grid":
					engine3D.grid = !engine3D.grid;
					break;
				case "Ground":
					area.ground.debug = !area.ground.debug;
					break;
				case "Axis":
					engine3D.axis = !engine3D.axis;
					break;
				case "man1":
				case "man2":
				case "woman1":
				case "woman2":
					var fakeData:PlayerData = new PlayerData("player_" + (new Date().valueOf()), area.map.getSpawnPoint(), _label, "walk", 1.5);
					fakeData.des = new Position(200 * Math.random() - 200 * Math.random(), 0, 200 * Math.random() - 200 * Math.random());
					fakeData.msg = "Walk to : " + fakeData.des;
					game.update(fakeData)
					break;
				case "Save":
					// TODO : new area id input box here
					var _saveAreaData:AreaData = new AreaData().parse(area.data);
					_saveAreaData.scene = new SceneData(new CameraData().parse(engine3D.camera));

					FileUtil.save(_saveAreaData, "00.ara");
					break;
				case "Open":
					FileUtil.open(["*.ara"], onAreaLoad);
					break;
			}
		}

		private function onAreaLoad(event:Event):void
		{
			if (event.type != "complete")
				return;

			var areaData:AreaData = new AreaData();
			IExternalizable(areaData).readExternal(event.target.data);

			_data = areaData;

			//cache
			configs[areaData.id] = areaData;

			gotoArea(areaData);
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

		private function gotoAreaID(id:String):void
		{
			_data = getConfigByAreaID(id);

			// cache not exist
			if (!_data)
			{
				LoaderUtil.load(_areaPath + id + ".ara", onAreaLoad);
			}
			else
			{
				gotoArea(_data);
			}
		}

		private function gotoArea(areaData:AreaData):void
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
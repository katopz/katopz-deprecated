package
{
	import com.cutecoma.game.core.Characters;
	import com.cutecoma.game.core.Game;
	import com.cutecoma.game.core.Position;
	import com.cutecoma.game.data.CharacterData;
	import com.cutecoma.game.data.PlayerData;
	import com.cutecoma.game.events.PlayerEvent;
	import com.cutecoma.game.player.Player;
	import com.cutecoma.playground.builder.AreaBuilder;
	import com.cutecoma.playground.core.Area;
	import com.cutecoma.playground.core.Engine3D;
	import com.cutecoma.playground.core.Ground;
	import com.cutecoma.playground.data.AreaData;
	import com.cutecoma.playground.data.CameraData;
	import com.cutecoma.playground.data.SceneData;
	import com.cutecoma.playground.debugger.PlayerDebugger;
	import com.cutecoma.playground.events.GroundEvent;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.sleepydesign.application.core.SDApplication;
	import com.sleepydesign.components.SDChatBox;
	import com.sleepydesign.components.SDConnector;
	import com.sleepydesign.components.SDDialog;
	import com.sleepydesign.components.SDMacPreloader;
	import com.sleepydesign.components.SDTree;
	import com.sleepydesign.components.SDTreeNode;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.events.SDMouseEvent;
	import com.sleepydesign.utils.FileUtil;
	import com.sleepydesign.utils.LoaderUtil;
	import com.sleepydesign.utils.ProfilerUtil;
	import com.sleepydesign.utils.SystemUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;
	import flash.utils.IExternalizable;

	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="480")]
	public class main extends SDApplication
	{
		private var engine3D:Engine3D;
		private var game:Game;
		private var connector:SDConnector;

		private var areaBuilder:AreaBuilder;

		private const VERSION:String = "PlayGround 2.2";

		private var area:Area;
		//private const SERVER_URI:String = "http://www.amaraka.tv/livebroadcast/Red5/webapps/SOSample/";
		//private const SERVER_URI:String = "http://www.thomassmart.com/Sandbox/red5/SOSample/";
		//private const SERVER_URI:String = "http://www.scratch.co.nz/red5/red5_dist/webapps/SOSample/";
		private const SERVER_URI:String = "rtmp://www.digs.jp/SOSample";
		//rtmp://203.150.230.224/oflaDemo
		//private const SERVER_URI:String = "rtmp://pixelliving.com/chat";

		private var currentRoomID:String = "";

		public function main()
		{
			TweenPlugin.activate([AutoAlphaPlugin, GlowFilterPlugin]);
			super("PlayGround", new SDMacPreloader());

			ProfilerUtil.addStat(SDApplication.system);
		}

		// ______________________________ Initialize ______________________________

		/*
		private var config88:AreaData = new AreaData
		(
			"88", "assets/day1.jpg", "88.dat", 40, 40,
			new SceneData(new CameraData(338.61, 116.50, -801.01, -2.21, -26.09, -0.11, 39.42, 8.70, 77.00)),
			new MapData(
				[
					0, 0, 0, 87, 87, 87, 0,
					0, 0, 0, 87, 87, 87, 0,
					0, 0, 0, 87, 87, 87, 0,
					0, 0, 0, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0,
					2, 1, 1, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0,
					0, 0, 0, 1, 1, 1, 0
				],
				7,3,4
			));

		private var config87:AreaData = new AreaData
		(
			"87", "assets/day2.jpg", "87.dat", 40, 40,
			new SceneData(new CameraData(190.43, 188.76, -1073.33, -0.05, -7.55, -0.55, 43.02, 8.70, 70.00)),
			new MapData(
				[
					0, 0, 86, 86, 86, 0, 0,
					0, 0, 86, 86, 86, 0, 0,
					1, 1, 1, 1, 1, 0, 0,
					1, 1, 1, 1, 1, 0, 0,
					1, 1, 1, 1, 1, 0, 0,
					1, 1, 1, 1, 1, 0, 0,
					0, 1, 1, 1, 1, 0, 0,
					0, 1, 1, 1, 1, 0, 0,
					0, 0, 1, 1, 1, 0, 0,
					0, 0, 88, 88, 88, 0, 0,
					0, 0, 0, 0, 0, 0, 0,
					0, 0, 0, 0, 0, 0, 0,
				],
				7,4,4
			));

		
		*/
		
		private var configs:Dictionary = new Dictionary();
		
		private var areaDialog:SDDialog;

		override protected function init():void
		{
			// TODO load from external and put to group
			//configs = new Dictionary();

			//configs[87] = config87;
			//configs[88] = config88;
			//}

			//protected function onStage(event:Event=null):void
			//{
			// ___________________________________________________________ Area

			//TODO : ask from external call, add user name 
			/*
			areaDialog = new SDDialog(
				<question><![CDATA[Welcome! Please select Area ID]]>
					<answer src="as:onUserSelectArea(87)"><![CDATA[Area 87]]></answer>
					<answer src="as:onUserSelectArea(88)"><![CDATA[Area 88]]></answer>
				</question>, false, this);

			this.addChild(areaDialog);
			*/
			
			addChild(LoaderUtil.loadAsset("AreaPanel.swf"));
		}

		public function getConfigByAreaID(id:String):AreaData
		{
			return configs[id];
		}

		public function onUserSelectArea(id:String):void
		{
			// hide dialog
			areaDialog.hide();

			// load config?
			gotoAreaID(id);
			//LoaderUtil.load(id+".ara", onAreaLoad);
			//create(configs[id]);
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
			//area.map.visible = false;

			// ___________________________________________________________ 3D Layer

			// 3D engine
			engine3D = new Engine3D(content, areaData.scene);
			//engine3D.axis = true;
			//engine3D.grid = true;
			//engine3D.compass = true;

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

			//char.addEventListener(SDEvent.COMPLETE, onCharactorComplete);

			//TODO : wait for user select char and add player 

			// ___________________________________________________________ Player

			game.player = new Player(new PlayerData("player_" + (new Date().valueOf()), area.map.getSpawnPoint(),
				["man1", "man2", "woman1", "woman2"][0 * int(4 * Math.random())], "stand", 3));

			// read map
			game.player.map = area.map;

			game.addPlayer(game.player);
			game.player.talk(VERSION);

			// ___________________________________________________________ System Layer

			SystemUtil.addContext(this, "Option", toggleOption);
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
			if (!areaBuilder)
			{
				game.player.walkTo(Position.parse(event.data.position));
			}else{
				/*
				trace(Position.parse(event.data.position));
				var _bitmapData:BitmapData = area.map.data.bitmapData;
				
				trace(_bitmapData.width, _bitmapData.height);
				trace(Map.factorX, Map.factorZ);
				
				for(var i:int=0;i<_bitmapData.width;i++)
					for(var j:int=0;j<_bitmapData.height;j++)
					{
						_bitmapData.setPixel32(i, j, 0xFFFFFFFF * Math.random());
					}
				area.ground.update();
				*/
			}
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

		private function destroyConnector():void
		{
			connector.destroy();
		}

		// _______________________________________________________ Chat

		private function createChatBox():void
		{
			var chatBox:SDChatBox = new SDChatBox();
			chatBox.x = 100;
			chatBox.y = 40;
			system.addChild(chatBox);
			//chatBox.visible = false;

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

		private function toggleOption(event:*):void
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
					if (!areaBuilder)
					{
						areaBuilder = new AreaBuilder(engine3D, area);
						content.addChild(areaBuilder);

						area.map.visible = engine3D.grid = area.ground.debug = engine3D.axis = true;
						
						area.ground.addEventListener(GroundEvent.MOUSE_DOWN, onTileClick);
					}
					else
					{
						area.ground.removeEventListener(GroundEvent.MOUSE_DOWN, onTileClick);
						
						area.map.visible = engine3D.grid = area.ground.debug = engine3D.axis = false;
						
						content.removeChild(areaBuilder);
						areaBuilder = null;
					}
					break;
				case "Map":
					FileUtil.openImage(onMapLoad, ["*.png"]);
					//areaBuilder.toggleTerrain(area.map);
					break;
				/*
				case "Walkable":
					areaBuilder.codeText.text = "1";
				break;
				case "Restrict":
					areaBuilder.codeText.text = "0";
				break;
				*/
				case "Background":
					areaBuilder.setupBackground();
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

		public function onTileClick(event:GroundEvent):void
		{
			trace("TilePlane:"+event, event.bitmapX, event.bitmapZ);
			
			var _bitmapData:BitmapData = area.map.data.bitmapData;
			_bitmapData.setPixel32(event.bitmapX, event.bitmapZ , 0xFF000000);
			area.ground.update();
		}
		
		private function onMapLoad(event:Event):void
		{
			if (event.type != "complete")
				return;
			
			var _bitmap:Bitmap = event.target.content as Bitmap;
			addChild(_bitmap);
			
			var _nodes:Array = [];
			for (var i:uint = 0; i < _bitmap.width; i++)
			{
				for (var j:uint = 0; j < _bitmap.height; j++)
				{
					_nodes.push(_bitmap.bitmapData.getPixel(i,j));
				}
			}
			area.map.data.nodes = _nodes;
		}
		
		private function onAreaLoad(event:Event):void
		{
			if (event.type != "complete")
				return;

			var areaData:AreaData = new AreaData();
			IExternalizable(areaData).readExternal(event.target.data);

			_data = areaData;

			trace(areaData.id);

			//cache
			configs[areaData.id] = areaData;

			gotoArea(areaData);

		/*
		   destroy();
		   create(areaData);

		   // start game?
		   game.start();
		 */
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
					gotoAreaID(data.args[0])
				}
			}
		}

		private function gotoAreaID(id:String):void
		{
			_data = getConfigByAreaID(id);

			// cache not exist
			if (!_data)
			{
				LoaderUtil.load(id + ".ara", onAreaLoad);
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

				// TODO : actually we need to wait for connection success?
				currentRoomID = areaData.id;

				// destroy
				game.removeOtherPlayer();

				//update area
				area.update(areaData);
				engine3D.update(areaData.scene);
				game.player.warp(area.map.getWarpPoint());
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
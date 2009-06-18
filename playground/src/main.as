﻿package
{
	import __AS3__.vec.Vector;
	
	import com.sleepydesign.components.SDChatBox;
	import com.sleepydesign.components.SDConnector;
	import com.sleepydesign.components.SDMacPreloader;
	import com.sleepydesign.components.SDTree;
	import com.sleepydesign.components.SDTreeNode;
	import com.sleepydesign.core.SDApplication;
	import com.sleepydesign.debug.SDTasks;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.events.SDMouseEvent;
	import com.sleepydesign.game.core.Characters;
	import com.sleepydesign.game.core.Game;
	import com.sleepydesign.game.core.Position;
	import com.sleepydesign.game.data.PlayerData;
	import com.sleepydesign.game.events.PlayerEvent;
	import com.sleepydesign.game.player.Player;
	import com.sleepydesign.playground.builder.AreaBuilder;
	import com.sleepydesign.playground.core.Area;
	import com.sleepydesign.playground.core.Engine3D;
	import com.sleepydesign.playground.core.Ground;
	import com.sleepydesign.playground.data.AreaData;
	import com.sleepydesign.playground.data.CameraData;
	import com.sleepydesign.playground.data.SceneData;
	import com.sleepydesign.playground.debugger.PlayerDebugger;
	
	import flash.utils.IExternalizable;
	import flash.filters.GlowFilter;
	
	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="480")]
	public class main extends SDApplication
	{
		private var fake		: Vector.<int>;
		
		private var engine3D	: Engine3D;
		private var game		: Game;
		private var connector	: SDConnector;
		
		private var areaBuilder	: AreaBuilder;
		
		private const VERSION	:String = "PlayGround 2.1";
		
		private var area		:Area;
		private const SERVER_URI:String = "rtmp://www.digs.jp/SOSample";
		//private const SERVER_URI:String = "rtmp://localhost/SOSample";
		
		public function main()
		{
			super("PlayGround", {loader: new SDMacPreloader(), loaderAlign:"c"});
			
			//alpha=.1
			SDTasks.init(this, VERSION);
			
			fake  = new Vector.<int>();
		}
		
        // ______________________________ Initialize ______________________________
        
        private var config1:AreaData = new AreaData("l0r0", "assets/day1.jpg", "l0r0.dat", 40, 40,
		new SceneData(new CameraData(338.61,116.50,-801.01,-2.21,-26.09,-0.11,39.42,8.70,77.00)));
		
        private var config2:AreaData = new AreaData("l0r1", "assets/day2.jpg", "l0r1.dat", 40, 40,
		new SceneData(new CameraData(190.43,188.76,-1073.33,-0.05,-7.55,-0.55,43.02,8.70,70.00)));
		
		/*
        private var config2:Object = 
        {
			id	:"l0r1", 
			background:"assets/day2.jpg",
			map:
			{
				src		: "l0r1.dat",
				width 	: 40,
				height	: 40
			},
			scene:
			{
				camera:{x:190.43,y:188.76,z:-1073.33,rotationX:-0.05,rotationY:-7.55,rotationZ:-0.55,fov:43.02,focus:8.70,zoom:70.00}
			}
		}
		*/
		private var configs:Array = [config1, config2];
		
		override public function init(raw:Object=null):void
		{
			// load config?
			create(configs[1]);
			
			// ___________________________________________________________ System Layer
			
			createSystem();
			createConnector();
			createChatBox();
			
			// bind player -> connector
			game.player.addEventListener(PlayerEvent.UPDATE, connector.onClientUpdate);
			
			// start
			game.start();
		}
		
		// ______________________________ Create ______________________________
		
		override public function create(config:Object=null):void
		{
			super.create(config);
			
			// ___________________________________________________________ 2D Layer
			
			// game
			game = new Game();
			
			area = new Area(config);
			addChild(area);
			
			area.map.x = stage.stageWidth - area.map.width;
			//area.map.visible = false;
			
			// ___________________________________________________________ 3D Layer
			
			// 3D engine
			engine3D = new Engine3D(this, config.scene);
			//engine3D.axis = true;
			//engine3D.grid = true;
			//engine3D.compass = true;
			
			// bind
			game.engine = engine3D;
			
			// ___________________________________________________________ Area
			
			//TODO : wait for user select area 
			
			// Ground
			area.ground = new Ground(engine3D, area.map, true, !true);
			area.ground.addEventListener(SDMouseEvent.MOUSE_DOWN, onGroundClick);
			
			// ___________________________________________________________ Char
			
			var chars:Characters = new Characters("charactor.xml");
			//char.addEventListener(SDEvent.COMPLETE, onCharactorComplete);
			
			//TODO : wait for user select char and add player 
			
			// ___________________________________________________________ Player
			
			game.player = new Player(new PlayerData
			(
				"player_"+(new Date().valueOf()),
				area.map.getSpawnPoint(),
				"man",
				"stand",
				3
			));
			
			game.addPlayer(game.player);
			game.player.talk(VERSION);
		}
		
		// _______________________________________________________ Action
		
		private function onGroundClick(event:SDMouseEvent):void
		{
			game.player.walkTo(Position.parse(event.data.position));
		}
		
		// _______________________________________________________ Connector
		
		private function createConnector():void
		{
			//connector = new SDConnector(this, "rtmp://localhost/SOSample", "lobby");
			connector = new SDConnector(SERVER_URI, area.id);
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
			chatBox.y = 40;
			system.addChild(chatBox);
			//chatBox.visible = false;
			
			// bind chat -> player
			chatBox.addEventListener(SDEvent.UPDATE, onTalk);
		}	
			
		private function onTalk(event:SDEvent):void
		{
			trace(" ^ onTalk : "+event);
			game.player.update({id:game.player.id, msg:event.data.msg});
		}
		
		// _______________________________________________________ Manager
		
		private function onUpdate(event:SDEvent):void
		{
			trace(" ^ onUpdate : "+event);
			game.update(event.data.data);
		}
		
		// _______________________________________________________ System
		
		private function createSystem():void
		{
			// Engine Explorer
			var tree:SDTree = new SDTree(
			<Option>
				<Editor>
					<Grid/>
					<Axis/>
				</Editor>
				<Map/>
				<Debugger/>
				<Ground/>
				<Test/>
				<Save/>
				<Open/>
			</Option>)
			
			tree.x=10;
			tree.y=70;
			tree.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2)]
			system.addChild(tree);
			tree.addEventListener(SDMouseEvent.CLICK, onExplorer);
		}
		
		private function onExplorer( event:SDEvent):void
		{
			trace(" ^ onExplorer : "+SDTreeNode(event.data.node).label);
			
			switch(SDTreeNode(event.data.node).label)
			{
				case "Map":
					area.map.visible = !area.map.visible;
				break;
				case "Debugger":
					PlayerDebugger.toggle(engine3D, game.player);
				break;
				case "Editor":
					if(!areaBuilder)
					{
						areaBuilder = new AreaBuilder(engine3D);
						addChild(areaBuilder);
					}else{
						removeChild(areaBuilder);
						areaBuilder = null;
					}
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
				case "Test":
					var fakeData:PlayerData = new PlayerData("player_"+(new Date().valueOf()), area.map.getSpawnPoint(), "assets/man_test.dae", "stand", 1.5);
					fakeData.des = new Position(200*Math.random()-200*Math.random(), 0, 200*Math.random()-200*Math.random());
					fakeData.msg = "Walk to : "+ fakeData.des;
					game.update(fakeData)
				break;
				case "Save":
					system.save(config1, "l0r0.ara");
				break;
				case "Open":
					system.addEventListener(SDEvent.COMPLETE, onOpenComplete);
					system.open();
				break;
			}
		}
		
	    private function onOpenComplete(event:SDEvent):void
	    {   
	        trace(" openHandler : name = " + event.data);
	        system.removeEventListener(SDEvent.COMPLETE, onOpenComplete);
	        
	        var areaData:AreaData = new AreaData();
	        IExternalizable(areaData).readExternal(event.data);
	        
			destroy();
			create(areaData);
			
			// start game?
			game.start();
	    }
		
		// ______________________________ Update ____________________________
		
		override public function update(data:Object=null):void
		{
			if(data.command=="warp")
			{
				//TODO : get config by area id
				this.data = configs[data.args[0]];
				
				if(!this.data)return;
				
				// dirty
				if(this.data.id!=id)
				{
					//update server
					id = this.data.id;
					connector.enterRoom(id);
					
					// TODO : actually we need to wait for connection success?
					
					// destroy
					game.removeOtherPlayer();
					
					//update area
					area.update(this.data);
					engine3D.update(this.data.scene);
					game.player.warp(area.map.getWarpPoint());
				}
			}
		}
		
		// ______________________________ Destroy ____________________________
		
		override public function destroy():void
		{
			game.destroy();
			area.destroy();
		}
	}
}
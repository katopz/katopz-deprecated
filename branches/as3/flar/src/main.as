﻿package
{
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
	import com.sleepydesign.game.data.CharacterData;
	import com.sleepydesign.game.data.PlayerData;
	import com.sleepydesign.game.player.Player;
	import com.sleepydesign.playground.builder.AreaBuilder;
	import com.sleepydesign.playground.core.Engine3D;
	import com.sleepydesign.playground.data.CameraData;
	import com.sleepydesign.playground.data.SceneData;
	import com.sleepydesign.playground.debugger.PlayerDebugger;
	
	import flash.filters.GlowFilter;
	
	[SWF(backgroundColor="0xDDDDDD", frameRate="30", width="800", height="480")]
	public class main extends SDApplication
	{
		private var engine3D	: Engine3D;
		private var player 		: Player
		private var areaBuilder	: AreaBuilder;
		
		public function main()
		{
			super("FLAR", {loader: new SDMacPreloader(), loaderAlign:"c"});
			SDTasks.init(this, "FLAR");
		}
		
        // ______________________________ Initialize ______________________________
        
		override public function init(raw:Object=null):void
		{
			create();
			createSystem();
			engine3D.start();
		}
		
		// ______________________________ Create ______________________________
		
		override public function create(config:Object=null):void
		{
			super.create(config);
			
			// 3D engine
			engine3D = new Engine3D(this, new SceneData(new CameraData(-1,200,500,-160,-1,180,43.02,8.70,70.00)));
			engine3D.axis = true;
			engine3D.grid = true;
			
			var chars:Characters = new Characters();
			chars.addData(new CharacterData
			(
				"man", "assets/spongebob.dae", 1, 70, 24,
				["stand", "jump"]
			));
			
			// ___________________________________________________________ Player
			
			player = new Player(new PlayerData
			(
				"player_"+(new Date().valueOf()),
				new Position(),
				"man",
				"stand",
				3
			));
			
			engine3D.addChild(player.instance);
			player.talk("Hi");
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
				<Debugger/>
				<Player>
					<Stand/>
					<Jump/>
					<Happy/>
					<Walking/>
				</Player>
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
				case "Editor":
					if(!areaBuilder)
					{
						areaBuilder = new AreaBuilder(engine3D);
						addChild(areaBuilder);
					}else{
						removeChild(areaBuilder);
						areaBuilder = null;
					}
				case "Debugger":
					PlayerDebugger.toggle(engine3D, player);
				break;
				case "Grid":
					engine3D.grid = !engine3D.grid;
				break;
				case "Stand":
					player.act("stand");
				break;
				case "Jump":
					player.act("jump");
				break;
				case "Happy":
					player.act("happy");
				break;
				case "Walking":
					player.act("walking");
				break;
			}
		}
	}
}
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
	
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	
	[SWF(backgroundColor="0xDDDDDD", frameRate="30", width="800", height="480")]
	public class main2 extends SDApplication
	{
		private var engine3D	: Engine3D;
		private var player 		: Player
		private var areaBuilder	: AreaBuilder;
		
		public function main2()
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
				["stand", "walk", "sit"]
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
			player.addEventListener(FileLoadEvent.ANIMATIONS_COMPLETE, myOnAnimationsCompleteHandler);
			
		}
		
		private function myOnAnimationsCompleteHandler(event:FileLoadEvent):void
		{
			trace("myOnAnimationsCompleteHandler");
			//engine3D.addChild(player.instance);
			player.talk("myOnAnimationsCompleteHandler");
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
					<Sit/>
				</Player>
				<Material/>
			</Option>)
			
			tree.x=10;
			tree.y=70;
			tree.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2)]
			system.addChild(tree);
			tree.addEventListener(SDMouseEvent.CLICK, onExplorer);
			
			mat = new BitmapFileMaterial("assets/spongebob_invert.png");
		}
		private var mat:BitmapFileMaterial;
		private function onExplorer( event:SDEvent):void
		{
			trace(" ^ onExplorer : "+SDTreeNode(event.data.node).label);
			
			switch(SDTreeNode(event.data.node).label)
			{
				case "Material":
					//lazy
					var dae:DAE = player.instance.getChildByName("10") as DAE;
					var dae_mat:BitmapFileMaterial = BitmapFileMaterial(dae.getMaterialByName("SpongeBobSG"));
					dae_mat.bitmap = mat.bitmap;
					//better
					for each(var _dae:DisplayObject3D in player.instance.children)
					{
						if(_dae is DAE)
						{
							trace(dae,_dae);
						}
					}
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
				case "Debugger":
					PlayerDebugger.toggle(engine3D, player);
				break;
				case "Grid":
					engine3D.grid = !engine3D.grid;
				break;
				case "Stand":
					player.act("stand");
				break;
				case "Sit":
					player.act("sit");
				break;
			}
		}
	}
}
package
{
	import com.sleepydesign.components.SDTree;
	import com.sleepydesign.components.SDTreeNode;
	import com.sleepydesign.events.SDEvent;
	import com.sleepydesign.events.SDMouseEvent;
	import com.sleepydesign.game.core.Characters;
	import com.sleepydesign.game.core.Position;
	import com.sleepydesign.game.data.CharacterData;
	import com.sleepydesign.game.data.PlayerData;
	import com.sleepydesign.game.player.Player;
	import com.sleepydesign.playground.builder.AreaBuilder;
	
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.parsers.MD2;
	import org.papervision3d.objects.primitives.Plane;

	[SWF(width=640, height = 480, backgroundColor = 0x0)]
	public class SimpleModel extends PV3DARApp
	{
		//private static const PATTERN_FILE:String = "assets/patt.hiro";
		private static const PATTERN_FILE:String = "assets/spongebob.pat";
		private static const CAMERA_FILE:String = "assets/camera_para.dat";

		private var player1:MD2;
		private var bob:Player;
		
		private var areaBuilder	: AreaBuilder;

		public function SimpleModel()
		{
			addEventListener(Event.INIT, _onInit);
			init(CAMERA_FILE, PATTERN_FILE);
		}

		private function _onInit(e:Event):void
		{
			removeEventListener(Event.INIT, _onInit);
			
			// ___________________________________________________________ Player
			
			var chars:Characters = new Characters();
			chars.addData(new CharacterData
			(
				"man", "assets/spongebob.dae", 3, 100, 24,
				["stand", "jump"]
			));
			
			bob = new Player(new PlayerData
			(
				"player_"+(new Date().valueOf()),
				new Position(),
				"man",
				"stand",
				3
			));
			bob.addEventListener(FileLoadEvent.ANIMATIONS_COMPLETE, myOnAnimationsCompleteHandler);
			
			bob.instance.rotationX = 90;
			bob.instance.rotationZ = -90;
			
			_baseNode.addChild(bob.instance);
			//_baseNode.addChildrenToLayer(bob.instance, layer);
			
			//_viewport.getChildLayer(plane, true).layerIndex = ;
			
			//var layer:ViewportLayer = plane.createViewportLayer(_viewport);
			//layer.sortMode = ViewportLayerSortMode.INDEX_SORT;
			
			// ___________________________________________________________ Bg
			
			var plane:Plane = new Plane(new ColorMaterial(0xCCFF00FF),500,500,2,2);
			plane.scaleX = -1;
			//plane.material.doubleSided = true;
			
			_baseNode.addChild(plane);
			
			_viewport.getChildLayer(plane, true).layerIndex = 1;
			
			createSystem();
		}
		
		private function myOnAnimationsCompleteHandler(event:FileLoadEvent):void
		{
			trace("myOnAnimationsCompleteHandler");
			_viewport.getChildLayer(bob.instance, true).layerIndex = 2;
		}
		
		// _______________________________________________________ System
		
		private function createSystem():void
		{
			// Engine Explorer
			var tree:SDTree = new SDTree(
			<Option>
				<Stand/>
				<Jump/>
				<Happy/>
				<Walking/>
				<Material/>
			</Option>)
			
			tree.x=200;
			tree.y=200;
			tree.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2)]
			addChild(tree);
			tree.addEventListener(SDMouseEvent.CLICK, onExplorer);
			
			mat = new BitmapFileMaterial("assets/spongebob_invert.png");
		}
		private var mat:BitmapFileMaterial;
		private function onExplorer( event:SDEvent):void
		{
			trace(" ^ onExplorer : "+SDTreeNode(event.data.node).label);
			
			switch(SDTreeNode(event.data.node).label)
			{
				/*
				case "Editor":
					if(!areaBuilder)
					{
						areaBuilder = new AreaBuilder(engine3D);
						addChild(areaBuilder);
					}else{
						removeChild(areaBuilder);
						areaBuilder = null;
					}
					
				case "Grid":
					engine3D.grid = !engine3D.grid;
				break;
				*/
				
				case "Material":
					//lazy
					//var dae:DAE = bob.instance.getChildByName("4") as DAE;
					
					//better
					for each(var _dae:DisplayObject3D in bob.instance.children)
					{
						if(_dae is DAE)
						{
							//trace(dae==_dae);
							break;
						}
					}
					
					var dae_mat:BitmapFileMaterial = BitmapFileMaterial(_dae.getMaterialByName("SpongeBobSG"));
					dae_mat.bitmap = mat.bitmap;
					
				break;
				case "Stand":
					bob.act("stand");
				break;
				case "Jump":
					bob.act("jump");
				break;
				case "Happy":
					bob.act("happy");
				break;
				case "Walking":
					bob.act("walking");
				break;
			}
		}
	}
}
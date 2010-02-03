package examples
{
	
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.events.SDEvent;
	import com.cutecoma.playground.core.Engine3D;
	
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.objects.primitives.TilePlane;
	
	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="600")]
	public class ExTilePlane extends SDContainer
	{
		private var engine3D	: Engine3D;
		private var sphere		: Sphere;
		private var spheres		: Array;
		
		public function ExTilePlane()
		{
			super();
			alpha = .1
		}
		
        // ______________________________ Initialize ______________________________
        
		override protected function init():void
		{
			// load config?
			
			// loaded
			parse({container:this});
		}
		
		// ______________________________ Parse ______________________________
		
		override public function parse(raw:Object=null):void
		{
			create(raw);
		}
		
		override public function create(config:Object=null):void
		{
			super.create(config);
			
			engine3D = new Engine3D(config);
			engine3D.viewport.interactive = true;
			
			// Materials
			var materials:MaterialsList = new MaterialsList(
			{
				//all:
				front	: new ColorMaterial(0xFF0000,.5,!true),
				back	: new ColorMaterial(0x00FF00,.5,true)
			} );
			
			var list:Array = ["front","back"];
			var randomName:String;
			var tileMaterials:MaterialsList = new MaterialsList();
			var size :Number =500;
			var quality :Number = 10;
			
			for(var  ix:uint = 0; ix < quality; ix++ )
			{
				for(var  iy:uint= 0; iy < quality; iy++ )
				{
					randomName = list[Math.floor(list.length*Math.random())];
					tileMaterials.addMaterial(materials.getMaterialByName(randomName), ix+"_"+iy)
				}
			}
			
			// Create the tilePlane.
			tilePlane = new TilePlane( tileMaterials, size, size, quality, quality );
			//tilePlane.rotationY = -45;
			tilePlane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, onClick);
			
			engine3D.scene.addChild(tilePlane);
			
			engine3D.start();
			engine3D.addEventListener(SDEvent.DRAW, draw);
		}
		
		private function onClick(event:InteractiveScene3DEvent):void
		{
			trace(event)
		}
		
		private var tilePlane:TilePlane;
		
		override public function draw():void
		{
			//tilePlane.rotationY+=1;
		}
	}
}

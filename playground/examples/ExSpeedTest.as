package examples
{
	
	import com.sleepydesign.application.core.SDApplication;
	import com.sleepydesign.events.SDEvent;
	import com.cutecoma.playground.core.Engine3D;
	
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.Sphere;
	
	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="600")]
	public class ExSpeedTest extends SDApplication
	{
		private var engine3D	: Engine3D;
		private var sphere		: Sphere;
		private var spheres		: Array;
		
		public function ExSpeedTest()
		{
			super();
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
			
			spheres = [];
			for(var i:uint=0;i<20;i++)
			{
				sphere = new Sphere(new WireframeMaterial(0xFF0000), 100, 8, 8);
				sphere.x = -950+i*100;
				engine3D.scene.addChild(sphere);
				spheres.push(sphere);
			}
			
			var dae:DAE = new DAE();
			dae.load("assets/man_test.dae");
			
			engine3D.scene.addChild(dae);
			
			engine3D.start();
			//engine3D.addEventListener(SDEvent.DRAW, draw);
		}
		
		override public function draw():void
		{
			for(var i:uint=0;i<20;i++)
			{
				spheres[i].rotationY+=10;
			}
		}
	}
}

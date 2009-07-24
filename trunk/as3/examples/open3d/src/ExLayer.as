package
{
	import flash.filters.GlowFilter;
	
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Object3D;
	import open3d.objects.Plane;
	import open3d.objects.Sphere;
	import open3d.render.Layer;
	import open3d.view.SimpleView;

	[SWF(width=800,height=600,backgroundColor=0x666666,frameRate=30)]

	/**
	 * ExLayer
	 * @author katopz
	 */
	public class ExLayer extends SimpleView
	{
		private var sphere:Sphere;
		private var ground:Plane;
		
		override protected function create():void
		{
			// defined layer
			var layer0:Layer = new Layer();
			addChild(layer0);
			
			var layer1:Layer = new Layer();
			addChild(layer1);
			
			// we can add layer filters
			layer1.filters =[new GlowFilter(0xFFFFFF, 1, 4, 4, 16, 1)];
			
			for (var i:int = 0; i < 9; ++i)
			{
				sphere = new Sphere(100, 10, 10, new BitmapFileMaterial("assets/earth.jpg"));
				sphere.x = int(i / 3) * (256+10) - (256+10);
				sphere.z = int(i % 3) * (128+10);
				sphere.layer = layer1;
				
				renderer.addChild(sphere);
			}
			
			renderer.world.z = 1000;
			
			// ground always
			ground = new Plane(256*4, 128*4, new BitmapFileMaterial("assets/sea01.jpg"), 1, 1);
			ground.culling = "none";
			ground.layer = layer0;
			renderer.addChild(ground);
		}

		override protected function draw():void
		{
			var world:Object3D = renderer.world;
			world.rotationX = (mouseX - stage.stageWidth / 2) / 5;
			world.rotationZ = (mouseY - stage.stageHeight / 2) / 5;
			world.rotationY++;
		}
	}
}
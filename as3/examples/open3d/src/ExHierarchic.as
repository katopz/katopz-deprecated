package
{
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExHierarchic
	 * @author katopz
	 */
	public class ExHierarchic extends SimpleView
	{
		private var sphere:Sphere;
		private var sphere2:Sphere;
		private var sphere3:Sphere;
		
		private var step:Number = 0;

		override protected function create():void
		{
			var segment:uint = 32;

			sphere = new Sphere(100, segment, segment, new BitmapFileMaterial("assets/earth.jpg"));
			renderer.view.addChild(sphere);

			sphere2 = new Sphere(50, segment, segment, new BitmapFileMaterial("assets/earth.jpg"));
			sphere.addChild(sphere2);
			sphere2.x = 300;

			sphere3 = new Sphere(20, segment, segment, new BitmapFileMaterial("assets/earth.jpg"));
			sphere2.addChild(sphere3);
			sphere3.x = 150;
			
			camera.z = -1000;
		}

		override protected function draw():void
		{
			sphere.rotationY++;
			
			sphere2.rotationY++;
			
			sphere3.rotationX++;
			sphere3.rotationY++;
			sphere3.rotationZ++;

			//camera.lookAt(sphere2);

			//sphere2.x = 200 * Math.sin(step);
			//sphere2.z = 200 * Math.cos(step);

			//step += 0.1;
			
			//camera.rotationY = (mouseX - stage.stageWidth / 2) / 10;
			//camera.rotationX = -(mouseY - stage.stageHeight / 2) / 10;
		}
	}
}
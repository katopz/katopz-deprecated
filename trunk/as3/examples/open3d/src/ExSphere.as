package
{
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExSphere
	 * @author katopz
	 */
	public class ExSphere extends SimpleView
	{
		private var sphere:Sphere;
		private var sphere2:Sphere;

		private var step:Number = 0;

		override protected function create():void
		{
			// Single Core = 35, Quad Core = 56
			var segment:uint = 83;

			sphere = new Sphere(100, segment, segment, new BitmapFileMaterial("assets/earth.jpg"));
			renderer.view.addChild(sphere);

			//sphere2 = new Sphere(50, segment, segment, new BitmapFileMaterial("assets/earth.jpg"));
			//renderer.view.addChild(sphere2);

			//renderer.view.rotationX = 30;
		}

		override protected function draw():void
		{
			sphere.rotationY+=Math.PI/10;
			//sphere2.rotationY -= 2;

			//sphere2.x = 200 * Math.sin(step);
			//sphere2.z = 200 * Math.cos(step);

			//step += 0.1;
			
			//camera.rotationY = (mouseX - stage.stageWidth / 2) / 10;
			//camera.rotationX = -(mouseY - stage.stageHeight / 2) / 10;
		}
	}
}
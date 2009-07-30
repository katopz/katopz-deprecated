package
{
	import open3d.materials.shaders.NormalMaterial;
	import open3d.objects.Light;
	import open3d.materials.shaders.PhongMaterial;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * Test for a flash generated normal map
	 * @author kris@neuroproductions
	 */
	public class ExSphereNormalMapTest extends SimpleView
	{
		private var sphere : Sphere;
		private var sphere2 : Sphere;

		private var step : Number = 0;

		override protected function create() : void
		{
			this.x = 300;
			this.y =300;
			
			// Single Core = 35, Quad Core = 56
			var segment : uint = 20;
			var l:Light=new Light();
			l.setPosition(0, 1, 1);
			sphere = new Sphere(100, segment, segment, new NormalMaterial(l ));
			renderer.addChild(sphere);

			sphere2 = new Sphere(50, segment, segment, new  NormalMaterial(l ));
			renderer.addChild(sphere2);

			//renderer.world.rotationX = 30;
		}

		override protected function draw() : void
		{
			sphere.rotationY += 2;
			sphere2.rotationY -= 2;

			sphere2.x = 200 * Math.sin(step);
			sphere2.z = 200 * Math.cos(step);

			step += 0.1;
			
			//camera.rotationY = (mouseX - stage.stageWidth / 2) / 10;
			//camera.rotationX = -(mouseY - stage.stageHeight / 2) / 10;
		}

		
		
	}
}
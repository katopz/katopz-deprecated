package
{
	import __AS3__.vec.Vector;
	
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Object3D;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExSphereCubic
	 * @author katopz
	 */
	public class ExSphereCubic extends SimpleView
	{
		private var spheres:Vector.<Sphere>;

		override protected function create():void
		{
			var segment:uint = 10;
			var amount:uint = 4;
			var radius:uint = 25;
			var gap:uint = amount;

			var sphere:Sphere;
			for (var i:int = -amount / 2; i < amount / 2; ++i)
				for (var j:int = -amount / 2; j < amount / 2; ++j)
					for (var k:int = -amount / 2; k < amount / 2; ++k)
					{
						var bitmapFileMaterial:BitmapFileMaterial = new BitmapFileMaterial("assets/earth.jpg");
						sphere = new Sphere(radius, segment, segment, bitmapFileMaterial);
						renderer.addChild(sphere);
						sphere.x = gap * radius * i + gap * radius / 2;
						sphere.y = gap * radius * j + gap * radius / 2;
						sphere.z = gap * radius * k + gap * radius / 2;
					}

			renderer.world.rotationX = 30;
		}

		override protected function draw():void
		{
			var world:Object3D = renderer.world;
			world.rotationX = (mouseX - stage.stageWidth / 2) / 5;
			world.rotationZ = (mouseY - stage.stageHeight / 2) / 5;
			world.rotationY++;

			debugText.appendText(", ZSort : " + renderer.isMeshZSort + ", Right click for more option");
		}
	}
}
package
{
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Mesh;
	import open3d.objects.Plane;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExFaceHitTest
	 * @author katopz
	 */
	public class ExFaceHitTest extends SimpleView
	{
		private var sphere:Sphere;
		private var plane:Plane;
		private var step:Number = 0;

		override protected function create():void
		{
			plane = new Plane(256, 128, new BitmapFileMaterial("assets/sea01.jpg"), 10, 10);
			renderer.addChild(plane);
			plane.scaleX = plane.scaleY = plane.scaleZ = 2;
			plane.y = 100;
			plane.rotationX = -45;

			plane.culling = "none";

			sphere = new Sphere(100, 10, 10, new BitmapFileMaterial("assets/earth.jpg"));
			renderer.addChild(sphere);

			renderer.isMeshZSort = false;
			renderer.isFaceDebug = true;
		}

		override protected function draw():void
		{
			var _length:int = plane.vin.length / 3;
			for (var i:int = 0; i < _length; ++i)
			{
				plane.setVertices(i, "z", (i + 1) * 0.1 * Math.sin(step + i / 10));
				step += 0.001;
			}
		}
	}
}
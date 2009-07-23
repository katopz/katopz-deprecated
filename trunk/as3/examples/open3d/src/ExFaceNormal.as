package
{
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Plane;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExFaceNormal
	 * @author katopz
	 */
	public class ExFaceNormal extends SimpleView
	{
		private var sphere:Sphere;
		private var plane:Plane;

		override protected function create():void
		{
			plane = new Plane(256, 128, new BitmapFileMaterial("assets/sea01.jpg"), 1, 1);
			//renderer.addChild(plane);
			plane.scaleX = plane.scaleY = plane.scaleZ = 2;

			sphere = new Sphere(100, 10, 10, new BitmapFileMaterial("assets/earth.jpg"));
			renderer.addChild(sphere);
			sphere.y = -100;

			renderer.world.rotationX = -30;

			renderer.isMeshZSort = false;
			renderer.isFaceDebug = true;

			//alpha = .1;
		/*
		   renderer.render();

		   lines = new Dictionary();
		   for each(var face:Face in sphere.faces)
		   {
		   var normal:Vector3D = face.getNormal();
		   //trace(normal);
		   //var mat:Matrix3D = sphere.transform.matrix3D.clone();
		   //normal = mat.transformVector(normal);
		   //mat.appendScale(1.25, 1.25, 1.25);
		   //mat.appendTranslation(0,-100,0);

		   var _normal:Vector3D = new Vector3D(normal.x*1.25, normal.y*1.25, normal.z*1.25);
		   //mat.transformVector(_normal);

		   var line:Line3D = new Line3D(Vector.<Vector3D>([
		   normal,
		   _normal
		   ]));

		   renderer.addChild(line);
		   lines[face] = line;
		   }
		 */
		}

		override protected function draw():void
		{
			//sphere.rotationY++;
		/*
		   for each(var face:Face in sphere.faces)
		   {
		   var line:Line3D = lines[face];
		   renderer.removeChild(line);

		   var normal:Vector3D = face.getNormal();
		   trace(normal);

		   line = new Line3D(Vector.<Vector3D>([
		   normal,
		   new Vector3D(normal.x*1.25, normal.y*1.25, normal.z*1.25)
		   ]));
		   renderer.addChild(line);
		   lines[face] = line;
		   }
		 */
		}
	}
}
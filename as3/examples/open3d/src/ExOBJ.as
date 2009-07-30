package
{
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.OBJ;
	import open3d.view.SimpleView;
	
	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]
	/**
	 * ExOBJ
	 * @author katopz
	 */
	public class ExOBJ extends SimpleView
	{
		private var obj:OBJ;
		 
		override protected function create():void
		{
			//obj = new OBJ("assets/turtle.obj", new BitmapFileMaterial("assets/turtle.jpg"));
			obj = new OBJ("assets/cm9_b.obj", new BitmapFileMaterial("assets/rex.jpg"));
			//obj = new OBJ("assets/Trex1.obj", "assets/Trex1.mtl");
			renderer.addChild(obj);
		}

		override protected function draw():void
		{
			obj.rotationX++;
			obj.rotationY++;
			obj.rotationZ++;
		}
	}
}
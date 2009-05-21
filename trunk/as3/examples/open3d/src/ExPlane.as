package  
{
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Plane;
	import open3d.view.SimpleView;
	
	[SWF(width=800, height=600, backgroundColor=0x666666, frameRate=30)]
	public class ExPlane extends SimpleView
	{
		private var plane:Plane;
		
		override protected function create():void
		{
			plane = new Plane(500, 500, new BitmapFileMaterial("assets/earth.jpg"));
			//plane.x = 500/2;
			//plane.y = -500/2;
			
			renderer.addChild(plane);
			
			//plane.rotationY = -plane.rotationY;
			
			plane.rotationX = 30;
			//plane.rotationY = 30;
			//plane.rotationY = 180;
			
			isDebug = true;
			start();
		}
		
		override protected function draw():void
		{
			//plane.rotationY++;
			//trace(plane.rotationY)
		}
	}
}
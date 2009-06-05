package  
{
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Plane;
	import open3d.view.SimpleView;
	
	[SWF(width=800, height=600, backgroundColor=0x666666, frameRate=30)]
	
	/**
	 * ExFluidPlane
	 * @author katopz
	 * 
	 */	
	public class ExFluidPlane extends SimpleView
	{
		private var plane:Plane;
		private var step:Number=0;
		
		override protected function create():void
		{
			plane = new Plane(256, 128, new BitmapFileMaterial("assets/earth.jpg"), 10, 10);
			plane.scaleX = plane.scaleY = plane.scaleZ = 2;
			renderer.addChild(plane);
			plane.rotationX = -45;
		}
		
		override protected function draw():void
		{
			for (var i:int = 0; i<plane.vin.length/3; ++i)
			{
				plane.setVertices(i, "z", (i+1)*0.1*Math.sin(step+i/10));
				step+=0.001;
			}
		}
	}
}
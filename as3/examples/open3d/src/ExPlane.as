package  
{
	import flash.display.Bitmap;
	
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Plane2;
	import open3d.view.SimpleView;
	
	[SWF(width=800, height=600, backgroundColor=0x666666, frameRate=30)]
	public class ExPlane extends SimpleView
	{
		
		[Embed(source = "assets/earth.jpg")]
        private var Texture		:Class;
		
		private var plane:Plane2;
		
		override protected function create():void
		{
			var earthBitmap	:Bitmap = Bitmap(new Texture());
			earthBitmap.x = stage.stageWidth/2 - earthBitmap.width/2;
			addChild(earthBitmap);
			
			plane = new Plane2(256, 128, 1, 1, new BitmapFileMaterial("assets/earth.jpg"));
			renderer.addChild(plane);
			plane.culling = "none";
		}
		
		override protected function draw():void
		{
			plane.rotationX++;
		}
	}
}
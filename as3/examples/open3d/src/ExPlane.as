package
{
	import flash.display.Bitmap;
	
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Plane;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExPlane
	 * @author katopz
	 */
	public class ExPlane extends SimpleView
	{
		[Embed(source="assets/earth.jpg")]
		private var Texture:Class;

		private var plane:Plane;

		override protected function create():void
		{
			var earthBitmap:Bitmap = Bitmap(new Texture());
			earthBitmap.x = stage.stageWidth / 2 - earthBitmap.width / 2;
			addChild(earthBitmap);

			plane = new Plane(256, 128, new BitmapFileMaterial("assets/earth.jpg"), 2, 2);
			renderer.view.addChild(plane);
			plane.culling = "none";
		}

		override protected function draw():void
		{
			plane.rotationX++;
		}
	}
}
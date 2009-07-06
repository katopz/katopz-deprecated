package
{
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.MD2;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExMD2
	 * @author katopz
	 *
	 */
	public class ExMD2 extends SimpleView
	{
		private var cat:MD2;

		override protected function create():void
		{
			cat = new MD2("assets/pg.md2", new BitmapFileMaterial("assets/pg.png"));
			renderer.addChild(cat);
			
			// walk
			cat.loop(2,18);
		}

		override protected function draw():void
		{
			cat.rotationX++;
			cat.rotationY++;
			cat.rotationZ++;

			cat.updateFrame();
		}
	}
}
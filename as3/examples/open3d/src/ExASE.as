package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import open3d.materials.BitmapFileMaterial;
	import open3d.materials.BitmapMaterial;
	import open3d.objects.ASE;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExASE
	 * @author katopz
	 */
	public class ExASE extends SimpleView
	{
		private var shuttle:ASE;
		private var barge:ASE;

		private var step:Number = 0;

		override protected function create():void
		{
			// Embed image
			shuttle = new ASE("assets/shuttle.ase", new BitmapFileMaterial("assets/shuttle.jpg"));
			renderer.view.addChild(shuttle);

			// File image
			barge = new ASE("assets/barge.ase", new BitmapFileMaterial("assets/barge.jpg"));
			renderer.view.addChild(barge);
		}

		override protected function draw():void
		{
			barge.rotationX++;
			barge.rotationY++;
			barge.rotationZ++;

			shuttle.rotationX++;
			shuttle.rotationY++;
			shuttle.rotationZ++;

			shuttle.x = 200 * Math.sin(step);
			shuttle.z = 200 * Math.cos(step);

			step += 0.01;
		}
	}
}
package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Object3D;
	import open3d.objects.SimpleCube;
	import open3d.view.SimpleView;

	[SWF(width=800,height=600,backgroundColor=0x666666,frameRate=30)]

	/**
	 * ExSimpleCube
	 * @author katopz
	 */
	public class ExSimpleCube extends SimpleView
	{
		private var simpleCube:SimpleCube;

		override protected function create():void
		{
			simpleCube = new SimpleCube(100, new BitmapFileMaterial("assets/earth.jpg"));
			renderer.addChild(simpleCube);
		}

		override protected function draw():void
		{
			var world:Object3D = renderer.world;
			world.rotationX = (mouseX - stage.stageWidth / 2) / 5;
			world.rotationZ = (mouseY - stage.stageHeight / 2) / 5;
			world.rotationY++;
		}
	}
}
package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.TriangleCulling;
	
	import open3d.materials.BitmapMaterial;
	import open3d.objects.SimpleCube;
	import open3d.objects.Object3D;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExCube
	 * @author katopz
	 */
	public class ExSimpleCube extends SimpleView
	{
		[Embed(source="assets/earth.jpg")]
		private var Texture:Class;
		private var texture:BitmapData = Bitmap(new Texture()).bitmapData;

		private var simpleCube:SimpleCube;

		override protected function create():void
		{
			simpleCube = new SimpleCube(100, new BitmapMaterial(texture));
			renderer.addChild(simpleCube);
			// sky box
			//cube.culling = TriangleCulling.POSITIVE;
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
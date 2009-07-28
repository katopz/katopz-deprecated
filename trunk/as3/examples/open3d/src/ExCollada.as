package
{
	import open3d.objects.Collada;
	import open3d.objects.Object3D;
	import open3d.view.SimpleView;

	[SWF(width=800,height=600,backgroundColor=0x666666,frameRate=30)]

	/**
	 * ExCollada
	 * @author katopz
	 */
	public class ExCollada extends SimpleView
	{
		private var collada:Collada;

		override protected function create():void
		{
			collada = new Collada("assets/chameleon.dae", null, 0.01);
			renderer.addChild(collada);
			renderer.world.z = 4000;
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
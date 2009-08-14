package
{
	import flash.display.Sprite;
	
	import open3d.objects.Collada;
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
			renderer.view.addChild(collada);
			renderer.view.z = 4000;
		}

		override protected function draw():void
		{
			var view:Sprite = renderer.view;
			view.rotationX = (mouseX - stage.stageWidth / 2) / 5;
			view.rotationZ = (mouseY - stage.stageHeight / 2) / 5;
			view.rotationY++;
		}
	}
}
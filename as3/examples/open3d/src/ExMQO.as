package
{
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.MQO;
	import open3d.view.SimpleView;

	[SWF(width=800,height=600,backgroundColor=0x666666,frameRate=30)]

	/**
	 * ExMQO
	 * @author katopz
	 *
	 */
	public class ExMQO extends SimpleView
	{
		private var mqo:MQO;

		override protected function create():void
		{
			mqo = new MQO("assets/gunner.mqo", new BitmapFileMaterial("assets/gunner.png"));
			renderer.addChild(mqo);
		}

		override protected function draw():void
		{
			mqo.rotationX++;
			mqo.rotationY++;
			mqo.rotationZ++;
		}
	}
}
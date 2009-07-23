package
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

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

		public function ExCollada()
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.load(new URLRequest("assets/chameleon.dae"));
		}

		private function onComplete(event:Event):void
		{
			var loader:URLLoader = event.currentTarget as URLLoader;
			collada = new Collada();
			collada.parse(new XML(loader.data), 0.01);

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
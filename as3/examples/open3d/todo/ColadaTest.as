package
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import open3d.view.SimpleView;

	[SWF(width=800,height=600,backgroundColor=0x666666,frameRate=30)]

	/**
	 * @author kris@neuroproductions.be
	 * @mod katopz
	 */
	public class ColadaTest extends SimpleView
	{
		private var colladaParser:ColladaParser

		public function ColadaTest()
		{
			var urlLoader:URLLoader = new URLLoader()
			urlLoader.addEventListener(Event.COMPLETE, urlComplete)
			urlLoader.load(new URLRequest(ColladaParser.LOCATION + "Chameleon.dae"))
		}

		private function urlComplete(event:Event):void
		{
			var loader:URLLoader = event.currentTarget as URLLoader
			colladaParser = new ColladaParser()
			colladaParser.parse(new XML(loader.data), 0.01)

			renderer.addChild(colladaParser);
			renderer.world.z = 5000;
		}

		override protected function draw():void
		{
			if (colladaParser)
			{
				colladaParser.rotationX += 1
				colladaParser.rotationY += 1
			}
		}
	}
}
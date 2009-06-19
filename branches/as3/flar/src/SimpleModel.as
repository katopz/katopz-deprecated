package
{
	import flash.events.Event;

	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.parsers.MD2;

	[SWF(width=640, height = 480, backgroundColor = 0x0)]
	public class SimpleModel extends PV3DARApp
	{
		private static const PATTERN_FILE:String = "assets/patt.hiro";
		private static const CAMERA_FILE:String = "assets/camera_para.dat";

		private var player:MD2;

		public function SimpleModel()
		{
			addEventListener(Event.INIT, _onInit);
			init(CAMERA_FILE, PATTERN_FILE);
		}

		private function _onInit(e:Event):void
		{
			removeEventListener(Event.INIT, _onInit);

			player = new MD2();
			player.load("assets/pg.md2", new BitmapFileMaterial("assets/pg.png"), 12, 1);
			_baseNode.addChild(player);
		}
	}
}
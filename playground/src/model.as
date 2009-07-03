package
{
	import flash.display.Sprite;
	
	public class model extends Sprite
	{
		[Embed(source="../bin-debug/assets/man1/model.dae", mimeType = "application/octet-stream")]
		private var Model:Class;
		public var id:String = "man1";
	}
}
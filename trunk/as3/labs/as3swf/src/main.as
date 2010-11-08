package
{
	import com.codeazur.as3swf.SWF;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class main extends Sprite
	{
		public function main()
		{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onLoad);
			loader.load(new URLRequest("../src/test.swf"));
		}
		
		private function onLoad(event:Event):void
		{
			var swf:SWF = new SWF(event.target["data"]);
			trace(swf);
		}
	}
}
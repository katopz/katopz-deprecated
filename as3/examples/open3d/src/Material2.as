package  
{
	import flash.net.URLRequest;	
	import flash.display.Bitmap;	
	import flash.events.Event;	
	import flash.display.BitmapData;	
	import flash.display.Loader;	
	
	/**
	 * @author kris@neuroproductions.be
	 */
	public class Material2 
	{
		public var id:String
		public var url:String =""
		private var loader : Loader
        public var bmd : BitmapData

		public function load():void
		{
			
			
			bmd = new BitmapData(100,100,false,0)
			
			if (url != "")// && url!= "../images/Material__2noCulling.JPG")
			{
				url = ColladaParser.LOCATION + url.replace("../", "")
				//trace(url,"--")
			loader =new Loader()
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LoadComplet)
			loader.load(new URLRequest(url))
			}
		}
		
		private function LoadComplet(event : Event) : void
		{
			var bm : Bitmap = loader.contentLoaderInfo.content as Bitmap
			bmd = bm.bitmapData
			trace("complete")
		}
	}
}

package
{
	import com.sleepydesign.utils.SystemUtil;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;


	[SWF(backgroundColor="0xCCCCCC", frameRate = "30", width = "400", height = "300")]
	public class TestPNG extends Sprite
	{	
		[Embed(source="../bin-debug/pg.png")]
		private var PNG:Class;

		public function TestPNG()
		{
			var pngBMP:Bitmap = Bitmap(new PNG());
			//addChild(pngBMP);
			
			var _PNGEncoder:PNGEncoder = new PNGEncoder();
			_PNGEncoder.tEXt = "it's work!";
			
			var byteArray:ByteArray = _PNGEncoder.encode(pngBMP.bitmapData);
			
			SystemUtil.save(byteArray);
			
			SystemUtil.addContext(this, "Open PNG", onOpen);
			
			alpha = .1
			
			//var pgBMPPNGSWF:Bitmap = Bitmap(new PNGSWF());
			//addChild(pgBMPPNGSWF);
			
			/*
			var sdLoader:Loader = new Loader();
			sdLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFComplete);
					
			var ldrContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			var request:URLRequest = new URLRequest("png.swf");
			sdLoader.load(request, ldrContext);
			*/
			
			/*		
			var byteArray2:ByteArray = ByteArray(new PNGSWF());
			var png:PNGDecoder = new PNGDecoder();
			var text:String = png.getText(byteArray2);
			trace("tEXt:"+text);
			*/
		}
		
		/*
		private function onSWFComplete(event:Event):void
		{
			var _url:String = LoaderInfo(event.target).url;
			var _id:String = Sprite(event.target.content)["id"];
			//trace("onSWFComplete:"+_url);
			var _Class:Class = ApplicationDomain.currentDomain.getDefinition("pg") as Class;
			var _ByteArray:* = new _Class(0,0);
			trace(_ByteArray)
			
			//var png:PNGDecoder = new PNGDecoder();
			//var text:String = png.getText(_ByteArray);
			//trace("tEXt:"+text);
		}
		*/
		
		private function onOpen(event:Event):void
		{
			SystemUtil.open(["*.png"], onLoad);
		}
		
		private function onLoad(event:Event):void
		{
			var byteArray:ByteArray = event.target["data"] as ByteArray;
			var png:PNGDecoder = new PNGDecoder();
			var text:String = png.getText(byteArray);
			trace("tEXt:"+text);
		}
	}
}
package
{
	import com.sleepydesign.core.SDSystem;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	[SWF(backgroundColor="0xCCCCCC", frameRate = "30", width = "400", height = "300")]
	public class TestPNG extends Sprite
	{	
		[Embed(source="test2x2.png")]
		private var PNG:Class;
		
		public function TestPNG()
		{
			var pngBMP:Bitmap = Bitmap(new PNG());
			addChild(pngBMP);
			
			var _PNGEncoder:PNGEncoder = new PNGEncoder();
			var byteArray:ByteArray = _PNGEncoder.encode(pngBMP.bitmapData);
			
			var system:SDSystem = new SDSystem();
			system.save(byteArray);
		}
	}
}
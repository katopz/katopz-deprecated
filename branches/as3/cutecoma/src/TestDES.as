package
{
	import com.sleepydesign.crypto.DES;
	
	import flash.display.Sprite;

	[SWF(backgroundColor="0xFFFFFF",frameRate="30",width="800",height="600")]
	public class TestDES extends Sprite
	{
		public function TestDES()
		{
			var key:String = "ก۩!۞۩3thisisakey";
			//
			var message:String = "12345678";
			var cipherText:String;
			
			trace("original : " + message);
			
			cipherText = DES.encypt(key, message);
			trace("encypt : " + stringToHex(cipherText));

			cipherText = DES.decypt(key, cipherText);
			trace("decypt : " + cipherText);
		}

		private function stringToHex(s:String):String
		{
			var r:String = "0x";
			var hexes:Array = String("0123456789abcdef").split("");
			for (var i:int = 0; i < s.length; i++)
				r += hexes[s.charCodeAt(i) >> 4] + hexes[s.charCodeAt(i) & 0xf];
			
			return r;
		}
	}
}
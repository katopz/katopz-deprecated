package
{
	import flash.utils.ByteArray;
	
	public class MapData
	{
		// data
		public static var _n_size:Object = {width:300, height:370, x:0, y:0};
		public static var _ne_size:Object = {width:320, height:300, x:255, y:119};
		public static var _m_size:Object = {width:330, height:340, x:65, y:310};
		public static var _s_size:Object = {width:290, height:360, x:84, y:633};
		
		[Embed(source="assets/n.txt", mimeType="application/octet-stream")]
		private static var __n:Class;
		public static var _n:ByteArray = new __n() as ByteArray;
		
		[Embed(source="assets/s.txt", mimeType="application/octet-stream")]
		private static var __s:Class;
		public static var _s:ByteArray = new __s() as ByteArray;
		
		[Embed(source="assets/ne.txt", mimeType="application/octet-stream")]
		private static var __ne:Class;
		public static var _ne:ByteArray = new __ne() as ByteArray;
		
		[Embed(source="assets/m.txt", mimeType="application/octet-stream")]
		private static var __m:Class;
		public static var _m:ByteArray = new __m() as ByteArray;
	}
}
package
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class MapData
	{
		public static var _n_rect:Rectangle = new Rectangle(0, 0, 300, 370);
		public static var _ne_rect:Rectangle = new Rectangle(255, 119, 320, 300);
		public static var _m_rect:Rectangle = new Rectangle(65, 310, 330, 340);
		public static var _s_rect:Rectangle = new Rectangle(84, 633, 290, 360);
		public static var _t_rect:Rectangle = new Rectangle(0, 0, 550, 1000);

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
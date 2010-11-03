package mx.utils
{
	public class Base64
	{
		public static function encode(data:String, offset:uint = 0, length:uint = 0):String
		{
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encode(data, offset, length);
			return encoder.toString();
		}

		public static function decode(encoded:String):String
		{
			var decoder:Base64Decoder = new Base64Decoder();
			decoder.decode(encoded);
			return decoder.toString();
		}
	}
}
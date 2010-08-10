package
{
	import flash.display.Sprite;
	import flash.text.Font;
	import flash.text.TextFormat;

	public class Fonts extends Sprite
	{
		[Embed(source="tahoma.ttf", mimeType="application/x-font", fontName="tahoma")]
		public var tahoma:Class; 
		
		/**
		 * Constuctor
		 */
		public function Fonts()
		{
			// Register the font with the global Font manager class
			Font.registerFont(tahoma);
		}
		
		/**
		 * A utility function
		 *
		 * @param font	A font object
		 * @return 	A sting of the font name combined with the font style
		 */
		public static function getUniqueFontName(font:Font):String
		{
			return font.fontName + ":" + font.fontStyle;
		}
		
		/*
		[Embed(source='/assets/AKKURAT_.TTF', fontName="Akkurat", mimeType="application/x-font-truetype", 
		unicodeRange='U+0020-U+007F,U+00A2-U+00A3,U+00A9-U+00A9,U+00AE-U+00AE,U+2122-U+2122')] public static var font_akkurat:String;
		
		[Embed(source='/assets/AKKURATB.TTF', fontName="Akkurat", fontWeight="bold", mimeType="application/x-font-truetype", 
		unicodeRange='U+0020-U+007F,U+00A2-U+00A3,U+00A9-U+00A9,U+00AE-U+00AE,U+2122-U+2122')] public static var font_akkurat_bold:String;
		*/
	}
}
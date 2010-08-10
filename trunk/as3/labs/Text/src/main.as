package
{
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextField;

	public class main extends Sprite
	{
		[Embed(source="Vera.ttf", mimeType="application/x-font", fontName="Vera", embedAsCFF="false")]
		public var tahoma:Class; 
		
		private var tf:TextField;
		
		public function main()
		{
			Font.registerFont(tahoma);
			
			var text:TextField = new TextField();
			text.antiAliasType = AntiAliasType.ADVANCED;
			text.embedFonts = true;
			
			//text.defaultTextFormat = new TextFormat("Vera", 12, 0x000000)
			//text.text = 'Vera';
			
			text.styleSheet = new StyleSheet();
			text.styleSheet.parseCSS("p {font-family: Vera;font-size: 12px;color:#000000;}");
			
			text.htmlText = '<p>Vera</p>';
			
			addChild(text);
		}
	}
}
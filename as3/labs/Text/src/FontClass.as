package 
{
	import flash.text.*;
	import flash.display.MovieClip;
	import mx.core.FontAsset;
	public class FontClass extends MovieClip
	{
		[Embed(source="Vera.ttf", fontName="myFont", advancedAntiAliasing="true", mimeType="application/x-font")] 
		private var theClass:Class;
		/*
		public function FontClass ()
		{
			var _theClass:* = new theClass;
			
			var t:TextField=new TextField();
			t.embedFonts = true;
			var textFormat:TextFormat=new TextFormat();
			textFormat.size = "30";
			textFormat.font = "VeraSans-Roman";
			t.text = "[Embed] Jmetadata rocks!!!";
			t.width = 500;
			t.setTextFormat (textFormat);
			addChild (t);
			
		}
		*/
		
		public function FontClass ()
		{
			var t:TextField=new TextField();
			t.embedFonts = true;
			var textFormat:TextFormat=new TextFormat();
			textFormat.size = "30";
			textFormat.font = "myFont";
			parseCSS(t);
			t.htmlText = "<p>[Embed] metadata rocks!!!</p>";
			t.width = 500;
			//t.setTextFormat (textFormat);
			addChild (t);
			
		}
		
		private function parseCSS(t:TextField, css:String = null):void
		{
			var style:StyleSheet = new StyleSheet();
			var p:String;
			var aLink:String;
			var aHover:String;
			
			if (!css)
			{
				p = "p {font-family: VeraSans-Roman;font-size: 12px;color:#000000;}";
				aLink = "a:link {color:#009900;}";
				aHover = "a:hover {color:#00CC00;text-decoration:underline}";
				css = p + aLink + aHover;
			}
			style.parseCSS(css);
			
			t.styleSheet = style;
		}
	}
}
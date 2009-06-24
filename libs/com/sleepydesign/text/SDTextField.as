package com.sleepydesign.text
{
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class SDTextField extends TextField
	{
		public var defaultText:String = "";

		public function SDTextField(text:String = null, textFormat:TextFormat = null, css:String=null)
		{
			super();

			selectable = false;
			mouseEnabled = false;
			mouseWheelEnabled = false;
			defaultTextFormat = textFormat ? textFormat : new TextFormat("Tahoma", 12, 0x000000);
			autoSize = "left";
			cacheAsBitmap = true;
			filters = [new GlowFilter(0x000000, 0, 0, 0, 0, 0)];
			
			parseCSS(css);
			
			if (text)
				this.htmlText = "<p>"+text+"</p>";
		}

		public function parseCSS(css:String = null):void
		{
			var style:StyleSheet = new StyleSheet();
			var p:String;
			var aLink:String;
			var aHover:String;

			if (!css)
			{
				p = "p {font-family: Tahoma;font-size: 12px;color:#000000;}"
				aLink = "a:link {color:#009900;}"
				aHover = "a:hover {color:#00CC00;text-decoration:underline}"
				css = p + aLink + aHover;
			}
			style.parseCSS(css);
			//styleSheet = style;
		}
	}
}
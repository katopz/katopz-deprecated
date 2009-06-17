package com.sleepydesign.text
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class SDTextField extends TextField
	{
		public var defaultText:String="";
		
		public function SDTextField(text:String=null, textFormat:TextFormat=null)
		{
			super();
			
	    	selectable = false;
	    	mouseEnabled = false;
	    	mouseWheelEnabled = false;
	    	defaultTextFormat = textFormat?textFormat:new TextFormat("Tahoma", 12, 0x000000);
	    	autoSize = "left";
	    	cacheAsBitmap = true;
	    	filters = [new GlowFilter(0x000000,0,0,0,0,0)];
	    	
	    	if(text)
	    		this.htmlText = text;
		}
		
		/*
		public function parseCSS(iCSSText:String = null)
		{
			var style:StyleSheet = new StyleSheet();
			var p,aLink,aHover : String;
			
			if (!iCSSText)
			{
				p = "p {font-family: Tahoma;font-size: 12px;color:#000000;}"
				aLink = "a:link {color:#009900;}"
				aHover = "a:hover {color:#00CC00;text-decoration:underline}"
				iCSSText = p+aLink+aHover;
			}
			style.parseCSS(iCSSText);
			styleSheet = style;
		}
		*/
	}
}
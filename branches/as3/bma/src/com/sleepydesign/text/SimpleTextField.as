/**
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.text {
	
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.StyleSheet;
	
	
	
    public class SimpleTextField extends TextField {
		
		//public function SimpleTextField(iText:String,iName:String=null,iCSSText:String=null) {
		
		public function SimpleTextField(iText:String,isEmbed:Boolean=false,iCSSText:String=null) {
			
			embedFonts = isEmbed;
			selectable = !true;
			multiline = true;
			autoSize = TextFieldAutoSize.LEFT;
			
			//cacheAsBitmap = true;
			
			/*
            var format:TextFormat = new TextFormat();
            format.font = "Sleepy Sans Serif 12";
            format.color = 0x000000;
            format.size = 8;
			
			defaultTextFormat = format;
			*/
			parseCSS(iCSSText);
			
			htmlText = "<p>"+iText+"</p>";

		}
		
		public function parseCSS(iCSSText:String=null) {
			var style:StyleSheet = new StyleSheet();
			
			/*
			var p:Object = new Object();
			p.fontName = "Sleepy Sans Serif 12";
            p.color = 0x000000;
            p.size = 8;
			style.setStyle("p", p);
			
            var aLink:Object = new Object();
            aLink.color = "#009900";
			aLink.textDecoration = "none";
            style.setStyle("a:link", aLink);
			
            var aHover:Object = new Object();
            aHover.color = "#00EE00";
			aHover.textDecoration = "underline";
            style.setStyle("a:hover", aHover);
			*/
			var p,aLink,aHover : String;
			
			if(iCSSText==null){
				if(embedFonts){
					p = "p {font-family: Sleepy Sans Serif 12;font-size: 8px;color:#000000;}"
					aLink = "a:link {color:#009900;}"
					aHover = "a:hover {color:#00CC00;text-decoration:underline}"
					iCSSText = p+aLink+aHover;
				}else{
					p = "p {font-family: Tahoma;font-size: 9px;color:#000000;}"
					aLink = "a:link {color:#009900;}"
					aHover = "a:hover {color:#00CC00;text-decoration:underline}"
					iCSSText = p+aLink+aHover;					
				}
			}
			
			style.parseCSS(iCSSText);
			
			styleSheet = style;
			
		}
		
    }
}
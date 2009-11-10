/**
* @author katopz@sleepydesign.com
* @version 0.1
*/

package com.sleepydesign.containers {

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.xml.XMLDocument;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import caurina.transitions.Tweener;
	
	import com.sleepydesign.text.SimpleTextField;
	import com.sleepydesign.utils.URLUtil;
	
	public class Balloon extends Sprite {
		
		//public var urlUtil:URLUtil = new URLUtil();
		public var container:Sprite;
		public var gas:Sprite;
		public var content:Object;
		public var label:SimpleTextField;
		public var whbug:Number=0;
		public var bug:Number=0;
		public var extra:Object;
		
		namespace custom;
		
		custom function hide(delay:Number=0) {
			this.hide(delay)
		}
		
		custom function jump(id:String="0",nodeName:String="question") {
			this.jump(id,nodeName)
		}		
		
		var pad:Number = 2;
		var lenght:Number = 4;
		public var begPoint:Number = 0;
		
		public function Balloon(iText:*) {
			
			gas = new Sprite();
			container = new Sprite();
			
			container.addEventListener(Event.RESIZE, renderHandler);
			container.addEventListener(Event.CHANGE, renderHandler);
			
			content = new XMLDocument();
			content.parseXML(String(iText));
			
			htmlText = iText;
			
			addChild(gas);
			addChild(container);
			
			gas.cacheAsBitmap = true;
			cacheAsBitmap = true;
        }
		
		private function renderHandler(event:Event):void {
			
			if(container.hasEventListener(Event.ENTER_FRAME)){
				if(container.width+container.height!=whbug && ++bug>10){
					container.removeEventListener(Event.ENTER_FRAME, renderHandler);
				} 
			}
			
			update();
		}
		
		public function forceUpdate() {
			
			//trace("-------------forceUpdate-------------")
			
			whbug = container.width+container.height;
			if(container.hasEventListener(Event.ENTER_FRAME)){
				container.removeEventListener(Event.ENTER_FRAME, renderHandler);
			}
			container.addEventListener(Event.ENTER_FRAME, renderHandler);
			
		}
		
		public function update() {
			//trace("-------------update--------------");
			
			var w = (container.width>pad)?container.width:pad;
			var h = (container.height>pad)?container.height:pad;
			
			//trace(width,height,container.width,container.height)
			//trace(label.width,label.height,label.textWidth,label.textHeight)			
			
			container.x = Math.round(-w/2-1);
			container.y = Math.round(-pad-lenght-h+pad/4-1);
			
			gas.graphics.clear();
			gas.graphics.beginFill(0xFFFFFF);
			gas.graphics.drawRoundRect(-w/2-pad/2+pad/4, -h-pad-lenght, w+pad/2,h+pad/2,pad,pad);
			gas.graphics.moveTo(0,-begPoint);
			gas.graphics.lineTo(-4,-lenght-pad*.5);
			gas.graphics.lineTo(4,-lenght-pad*.5);
			gas.filters = [new GlowFilter( 0x000000, .25, 6, 6, 2, 1, false, false ) ];
			
		}
		
		public function copyPosition(iTarget:DisplayObject) {
			x = iTarget.x;
			y = iTarget.y;
		}
		
		public function get text():String {
			return htmlText
		}
		
		
		public function set text(iText:*) {
			htmlText = iText
		}
		
		public function get htmlText():String {
			
			var iText = label.htmlText;
			
			if((iText.indexOf("<p>")==0)&&(iText.lastIndexOf("</p>")==iText.length-4)){
				
				iText = iText.substring(3,iText.length-4);
				
			}
			
			return iText
		}
		
		public function set htmlText(iText:*) {
			
			removeLabel();
			createLabel(iText);
			
			update();
		}
		
		public function parseCSS(iCSSText:String=null) {
			label.parseCSS(iCSSText);
			update();
		}
		
		public function hide(delay:Number=0) {
			Tweener.addTween(this, {onComplete:function(){this.visible = false}, alpha:0, time:1, delay:delay});
		}
		
		public function show(delay:Number=0) {
			Tweener.addTween(this, {onComplete:function(){this.visible = true}, alpha:1, time:1, delay:delay});
		}
		
		private function jump(id:String="0",nodeName:String="question") {
			
			htmlText = new XML(content.idMap[id]);
			
		}
		
        private function createAnswer(url:String, iText:String):String {
            var link:String = "";
            link += " ๛ <font color='#009900'>";
            link += "<u>";
            link += "<a href='event:" + url + "'>" + iText + "</a>";
            link += "</u>";
            link += "</font>";
            return link;
        }
		
		/*
		 * <question id="0">
		 * 	<![CDATA[Who say <b>Hello World</b>?<br/>Do you remember?]]>
		 * 	<answer src="actionscript:jump(1)"><![CDATA[Maybe me]]></answer>
		 * 	<question id="1">
		 * 		<![CDATA[Really you?]]>
		 * 		<answer src="actionscript:jump(2)"><![CDATA[Yes!]]></answer>
		 * 		<question id="2">
		 * 			<title><![CDATA[Are you Sure?]]></title>
		 * 			<answer src="actionscript:jump(3)"><![CDATA[Holy Yes!]]></answer>
		 * 			<question id="3" src="actionscript:hide()"><![CDATA[OK!]]></question>
		 * 			<answer src="actionscript:jump(1)"><![CDATA[Hell No!]]></answer>
		 * 		</question>
		 * 		<answer src="actionscript:jump(0)"><![CDATA[No!]]></answer>
		 * 	</question>
		 * 	<answer src="http://www.google.com"><![CDATA[Try ask google!]]></answer>
		 * </question>;
		*/
			
		private function createLabel(iText:*) {
			
			var inputText:String;
			
			if(typeof(iText)=="string"){
				
				if((iText.indexOf("<img")>-1)&&(iText.indexOf("width")==-1)){
					forceUpdate();
				}
				
				inputText = iText;
				
			}else{
				
				inputText = iText.children()[0].toString()
				for each (var answer:XML in iText.answer)
				{
					inputText += "<br/>"+createAnswer(answer.@src,answer.toString())
				}
				
			}
			
			label = new SimpleTextField(inputText);
			
			label.addEventListener(TextEvent.LINK, linkHandler);
			label.filters = [new GlowFilter( 0, 0,0, 0, 0, 0, false, false ) ]
			
			//label.addEventListener(Event.RESIZE, renderHandler);
			label.addEventListener(Event.CHANGE, renderHandler);
			
			container.addChild(label);
			
			
			
		}
		
		private function removeLabel() {
			if(label){
				container.removeChild(label)
			}
		}
		
		private function linkHandler(e:TextEvent):void {
			var src = e.text.split(":")
			var protocal = src[0];
			var functionString = src[1];
			var functionName = functionString.split("(")[0];
			var argumentString = functionString.substring(1+functionString.indexOf("("),functionString.indexOf(")"))
			var argumentArray = argumentString.split(",");
			var argument;
			
			//TODO arguments
			var arg = argumentArray[0];
			if((arg.indexOf("'")==0)&&(arg.lastIndexOf("'")==arg.length)){
				//string
				argument = arg.substring(1,arg.length-1);
			}else{
				//number
				argument = int(arg);
			}
			
			switch(protocal){
				case "actionscript":
					if(argumentString.length>0){
						custom::[functionName](argument);
						//this[functionName].apply(this, [argument]);
					}else{
						custom::[functionName]();
					}
				break;
				
				case "javascript":
					URLUtil.goToURL(String(e.text));
				break;
				
				case "http":
					URLUtil.goToURL(String(e.text));
				break;
			}
        }
		
	}
}
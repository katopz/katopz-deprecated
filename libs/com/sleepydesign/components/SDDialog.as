package com.sleepydesign.components
{
	import com.sleepydesign.text.SDTextField;
	import com.sleepydesign.utils.SystemUtil;
	import com.sleepydesign.utils.URLUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.xml.XMLDocument;

	public class SDDialog extends SDComponent
	{
		private var _back:Shape;
		private var content:Object;
		private var label:SDTextField;
		private var pad:Number = 8;
		private var length:Number = 8;
		private var begPoint:Point = new Point(0, 0);

		private var iText:*;
		private var isTail:Boolean;

		public function SDDialog(iText:* = "", isTail:Boolean = true)
		{
			this.iText = iText;
			this.isTail = isTail;
			
			super();
		}

		override public function init(raw:Object = null):void
		{
			super.init(raw);
			mouseEnabled = true;
			mouseChildren = true;
		}

		override public function create(config:Object = null):void
		{
			//default
			if (!_config)
				_config = {color: 0xFFFFFF, multiline: true}

			super.create(config);

			_back = new Shape();
			_back.filters = [new GlowFilter(0xCCCCCC, 1, 4, 4, 2, 1, true, false)];
			_back.cacheAsBitmap = true;

			label = new SDTextField(iText);
			label.multiline = true;
			label.mouseEnabled = true;

			content = new XMLDocument();
			content.parseXML(String(iText));

			htmlText = iText;

			addChild(_back);
			addChild(label);

			cacheAsBitmap = true;
		}

		private function onComplete(event:Event):void
		{
			event.target.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			draw();
		}

		private function onIOError(event:IOErrorEvent):void
		{
			event.target.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			draw();
		}

		override public function draw():void
		{
			var w:Number = (label.width > pad) ? label.width : pad;
			var h:Number = (label.height > pad) ? label.height : pad;

			label.x = int(-w * .5);
			label.y = int(-pad - length - h + pad * .25 - 1);

			_back.graphics.clear();
			_back.graphics.beginFill(_config.color);
			_back.graphics.drawRoundRect(-w * .5 - pad * .5 + pad * .25, -h - pad - length, w + pad * .5, h + pad * .5, pad, pad);
			
			if(isTail)
			{
				_back.graphics.moveTo(0, 0);
				_back.graphics.lineTo(-4, -length - pad * .5);
				_back.graphics.lineTo(4, -length - pad * .5);
			}

			dispatchEvent(new Event(Event.CHANGE));
		}

		public function setPosition(iX:Number, iY:Number):void
		{
			x = begPoint.x + iX;
			y = begPoint.y + iY;
		}

		public function copyPosition(iTarget:DisplayObject):void
		{
			setPosition(iTarget.x, iTarget.y);
		}

		public function get text():String
		{
			return label.text
		}

		public function set text(iText:*):void
		{
			label.text = iText
			draw();
		}

		public function get htmlText():String
		{
			var iText:String = label.htmlText;
			if ((iText.indexOf("<p>") == 0) && (iText.lastIndexOf("</p>") == iText.length - 4))
			{
				iText = iText.substring(3, iText.length - 4);
			}
			return iText;
		}

		public function set htmlText(iText:*):void
		{
			visible = (iText != "")
			setLabel(iText);
			draw();
		}
		
		public function set xmlText(iText:*):void
		{
			htmlText = XML(iText);
		}

		public function parseCSS(iCSSText:String = null):void
		{
			label.parseCSS(iCSSText);
			draw();
		}

		override public function set visible(iVisible:Boolean):void
		{
			super.visible = iVisible;
			dispatchEvent(new Event(Event.CHANGE));
		}

		private function jump(id:String = "0", nodeName:String = "question"):void
		{
			htmlText = new XML(content.idMap[id]);
		}

		private function createAnswer(url:String, iText:String):String
		{
			var link:String = "";
			link += " … <font color='#009900'>";
			link += "<u>";
			link += '<a href="event:' + url + '">' + iText + "</a>";
			link += "</u>";
			link += "</font>";
			return link;
		}

		/*
		 * <question id="0">
		 * 	<![CDATA[Who say <b>Hello World</b>?<br/>Do you remember?]]>
		 * 	<answer src="as:jump(1)"><![CDATA[Maybe me]]></answer>
		 * 	<question id="1">
		 * 		<![CDATA[Really you?]]>
		 * 		<answer src="as:jump(2)"><![CDATA[Yes!]]></answer>
		 * 		<question id="2">
		 * 			<![CDATA[Are you Sure?]]>
		 * 			<answer src="as:jump(3)"><![CDATA[Holy Yes!]]></answer>
		 * 			<question id="3" src="as:hide()"><![CDATA[OK!]]></question>
		 * 			<answer src="as:jump(1)"><![CDATA[Hell No!]]></answer>
		 * 		</question>
		 * 		<answer src="as:jump(0)"><![CDATA[No!]]></answer>
		 * 	</question>
		 * 	<answer src="http://www.google.com"><![CDATA[Try ask google!]]></answer>
		 * </question>;
		 */

		private function setLabel(iText:*):void
		{
			var inputText:String;

			if (typeof(iText) == "string")
			{
				inputText = iText;

				inputText = inputText.replace("<img ", "__bug__<img id='imgId' ");
				label.htmlText = inputText;
				var loader:Loader = label.getImageReference("imgId") as Loader;

				if (loader)
				{
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				}
			}
			else
			{
				inputText = iText.children()[0].toString()
				for each (var answer:XML in iText.answer)
				{
					inputText += "<br/>" + createAnswer(answer.@src, answer.toString())
				}
			}

			//'ve link
			if (inputText.indexOf("<a") > -1)
			{
				label.addEventListener(TextEvent.LINK, linkHandler);
			}

			label.parseCSS();

			inputText = inputText.replace("__bug__", "");
			label.htmlText = "<p>" + inputText + "</p>";

		}

		private function linkHandler(e:TextEvent):void
		{
			var src:Array = e.text.split(":")
			var protocal:String = src[0];
			var functionString:String = e.text.substring(1 + e.text.indexOf(":"));
			var functionName:String = functionString.split("(")[0];
			var argumentString:String = functionString.substring(1 + functionString.indexOf("("), functionString.lastIndexOf(")"))
			var argumentArray:Array = argumentString.split(",");
			var argument:*;

			//TODO arguments
			var arg:String = argumentArray[0];
			if ((arg.indexOf("'") == 0) && (arg.lastIndexOf("'") == arg.length-1))
			{
				//string
				argument = arg.substring(1, arg.length - 1);
			}
			else if ((arg.indexOf('"') == 0) && (arg.lastIndexOf('"') == arg.length-1))
			{
				//string
				argument = arg.substring(1, arg.length - 1);
			}
			else
			{
				//number
				argument = int(arg);
			}

			switch (protocal)
			{
				case "as":
					if (argumentString.length > 0)
					{
						//custom::[functionName](argument);
						this[functionName].apply(this, [argument]);
					}
					else
					{
						//custom::[functionName]();
						this[functionName].apply(this);
					}
					break;

				case "js":
					var isExternal:Boolean = false; 
					if (argumentString.length > 0)
					{
						isExternal = SystemUtil.callJS(functionName, argument);
					}
					else
					{
						isExternal = SystemUtil.callJS(functionName);
					}
					/*
					if(!isExternal)
					{
						URLUtil.getURL(String(e.text));
					}
					*/
					break;
				case "http":
					URLUtil.getURL(String(e.text));
					break;
			}
		}

	}
}
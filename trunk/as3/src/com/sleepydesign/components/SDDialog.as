package com.sleepydesign.components
{
	import com.sleepydesign.system.SystemUtil;
	import com.sleepydesign.text.SDTextField;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.xml.XMLDocument;

	public class SDDialog extends SDComponent
	{
		private var _config:Object;
		
		private var _header:Sprite;
		private var _back:Shape;
		private var content:Object;
		private var label:SDTextField;
		private var pad:Number = 8;
		private var length:Number = 8;
		private var begPoint:Point = new Point(0, 0);

		private var iText:*;
		private var isTail:Boolean;
		
		private var caller:Object

		public function SDDialog(iText:* = "", caller:Object=null)
		{
			this.iText = iText;
			this.isTail = isTail;
			
			this.caller = caller;
			
			super();
		}
		
		override protected function init():void
		{
			create();
			
			this.caller = caller?caller:this.parent;
			mouseEnabled = true;
			mouseChildren = true;
			dragEnabled = true;
			align = "center";
		}

		override protected function create():void
		{
			//default
			if (!_config)
				_config = {color: 0xFFFFFF, multiline: true}

			_back = new Shape();
			_back.filters = [new GlowFilter(0xCCCCCC, 1, 4, 4, 2, 1, true, false)];
			_back.cacheAsBitmap = true;

			label = new SDTextField(iText);
			label.multiline = true;
			label.mouseEnabled = true;

			content = new XMLDocument();
			content.parseXML(String(iText));
			
			// drag
			_header = new Sprite();
			
			addChild(_back);
			addChild(label);
			addChild(_header);

			cacheAsBitmap = true;
			
			htmlText = iText;
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
			
			/*
			if(isTail)
			{
				_back.graphics.moveTo(0, 0);
				_back.graphics.lineTo(-4, -length - pad * .5);
				_back.graphics.lineTo(4, -length - pad * .5);
			}
			*/
			
			_back.graphics.endFill();
			
			_header.graphics.beginFill(0xFF00FF, 0);
			_header.graphics.drawRoundRect(-w * .5 - pad * .5 + pad * .25, -h - pad - length, w + pad * .5, 20, pad, pad);
			_header.graphics.endFill();

			dispatchEvent(new Event(Event.CHANGE));
		}

		public function setPosition(iX:Number=0, iY:Number=0):void
		{
			x = begPoint.x + ((iX>0)?iX:x);
			y = begPoint.y + ((iY>0)?iY:y);
		}

		public function copyPosition(iTarget:DisplayObject):void
		{
			setPosition(iTarget.x, iTarget.y);
		}

		public function get text():String
		{
			return label.text;
		}

		public function set text(iText:*):void
		{
			label.text = iText;
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
		
		private var _align:String = "center";
		public function get align():String
		{
			return _align;
		}
		
		public function set align(value:String):void
		{
			_align = value;
			switch(_align)
			{
				case "center" :
					begPoint.x = _container.stage.stageWidth/2 - width/2;
					begPoint.y = _container.stage.stageHeight/2 - height/2;
				break;
			}
			setPosition();
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
			SystemUtil.doCommand(e.text, caller);
		}
		
		private function set dragEnabled(value:Boolean):void
		{
			if(value)
				_header.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			else
				_header.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
		}
		
		private function onDrag(event:MouseEvent):void
		{
			startDrag(false);//, root.scrollRect);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(Event.MOUSE_LEAVE, onDrop);
		}
		
		private function onDrop(event:MouseEvent):void
		{
			stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(Event.MOUSE_LEAVE, onDrop);
		}
	}
}
package com.sleepydesign.components
{
	import com.sleepydesign.text.SDTextField;
	import com.sleepydesign.utils.SystemUtil;

	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.xml.XMLDocument;

	public class SDDialog extends SDComponent
	{
		private var _header:Sprite;
		private var _back:Shape;
		private var content:Object;
		private var label:SDTextField;
		private var pad:Number = 8;
		private var length:Number = 8;

		private var iText:*;
		private var isTail:Boolean;

		private var caller:Object

		public function SDDialog(iText:* = "", caller:Object = null)
		{
			this.iText = iText;
			this.isTail = isTail;

			this.caller = caller;

			super();
		}

		override protected function onStage(event:Event):void
		{
			super.onStage(event);
			this.caller = caller ? caller : this.parent;
			mouseEnabled = true;
			mouseChildren = true;
			dragEnabled = true;
			draw();
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

			label.x = int(pad); //int(-w * .5);
			label.y = int(pad); //int(-pad - length - h + pad * .25 - 1);

			_back.graphics.clear();
			_back.graphics.beginFill(_config.color);
			_back.graphics.drawRoundRect(0, 0, w + pad * 2, h + pad * 2, pad, pad);

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
			_header.graphics.drawRoundRect(0, 0, w + pad * 2, 20, pad, pad);
			_header.graphics.endFill();
			
			// align
			if(stage)
			switch (_align)
			{
				case StageAlign.TOP_LEFT:
					setPosition(0, 0);
					break;
				case StageAlign.TOP_RIGHT:
					setPosition(stage.stageWidth - width, 0);
					break;
				default:
					setPosition(stage.stageWidth / 2 - width / 2, stage.stageHeight / 2 - height / 2);
					break;
			}

			dispatchEvent(new Event(Event.CHANGE));
		}

		public function setPosition(x:int, y:int):void
		{
			this.x = x; //+(width+pad)/2;
			this.y = y; //+(height+pad)/2;
		}

		override public function get width():Number
		{
			return _back.width;
		}

		override public function get height():Number
		{
			return _back.height;
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

		private var _align:String;

		public function get align():String
		{
			return _align;
		}

		public function set align(value:String):void
		{
			_align = value;
			draw();
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
			SystemUtil.link(e.text, caller);
		}

		private function set dragEnabled(value:Boolean):void
		{
			if (value)
				_header.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			else
				_header.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
		}

		private function onDrag(event:MouseEvent):void
		{
			startDrag(false); //, root.scrollRect);
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
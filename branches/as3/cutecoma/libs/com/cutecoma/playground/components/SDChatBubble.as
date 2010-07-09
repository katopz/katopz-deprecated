package com.cutecoma.playground.components
{
	import com.sleepydesign.components.SDComponent;
	import com.sleepydesign.system.SystemUtil;
	import com.sleepydesign.text.SDTextField;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	import flash.xml.XMLDocument;
	
	import org.osflash.signals.Signal;

	public class SDChatBubble extends SDComponent
	{
		private var _bgColor:Number = 0xFFFFFF;
		
		private var _header:Sprite;
		private var _back:Shape;
		
		private var label:SDTextField;
		private var pad:Number = 8;
		private var length:Number = 8;
		private var begPoint:Point = new Point(0, 0);

		private var iText:*;
		
		public var drawSignal:Signal = new Signal();

		public function SDChatBubble(iText:String = "")
		{
			this.iText = iText;
			
			super();
			
			this.align = align;
			
			init();
		}
		
		protected function init():void
		{
			create();
			
			mouseEnabled = true;
			mouseChildren = true;
			isDraggable = true;
		}

		protected function create():void
		{
			//default

			_back = new Shape();
			_back.filters = [new GlowFilter(0xCCCCCC, 1, 4, 4, 2, 1, true, false)];
			_back.cacheAsBitmap = true;

			label = new SDTextField(iText);
			label.multiline = true;
			label.mouseEnabled = true;
			label.autoSize = TextFieldAutoSize.LEFT;

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
			_back.graphics.beginFill(_bgColor);
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
			
			super.draw();

			dispatchEvent(new Event(Event.CHANGE));
		}

		override public function setPosition(x:int, y:int):void
		{
			this.x = x; //+(width+pad)/2;
			this.y = y; //+(height+pad)/2;
		}

		public function copyPosition(iTarget:DisplayObject):void
		{
			setPosition(iTarget.x, iTarget.y);
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
		
		/*
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
		*/

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

		private function setLabel(iText:String):void
		{
			label.parseCSS();
			label.htmlText = "<p>" + iText + "</p>";
		}
	}
}
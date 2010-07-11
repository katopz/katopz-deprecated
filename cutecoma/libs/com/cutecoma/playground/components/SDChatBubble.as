package com.cutecoma.playground.components
{
	import com.sleepydesign.components.SDComponent;
	import com.sleepydesign.text.SDTextField;

	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;

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

		private var _currentText:String;

		public var drawSignal:Signal = new Signal();

		public function SDChatBubble(text:String = "")
		{
			_currentText = text;

			super();

			// default
			addChild(_back = new Shape());
			_back.filters = [new GlowFilter(0xCCCCCC, 1, 4, 4, 2, 1, true, false)];
			_back.cacheAsBitmap = true;

			addChild(label = new SDTextField(_currentText));
			label.multiline = true;
			label.mouseEnabled = true;
			label.autoSize = TextFieldAutoSize.LEFT;

			// drag
			addChild(_header = new Sprite());

			// speed
			mouseEnabled = mouseChildren = isDraggable = false;
			cacheAsBitmap = true;

			htmlText = _currentText;
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
			_back.graphics.endFill();

			_header.graphics.beginFill(0xFF00FF, 0);
			_header.graphics.drawRoundRect(0, 0, w + pad * 2, 20, pad, pad);
			_header.graphics.endFill();

			super.draw();

			drawSignal.dispatch();
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

		public function set text(value:*):void
		{
			label.text = value;
			draw();
		}

		public function get htmlText():String
		{
			var _text:String = label.htmlText;
			if ((_text.indexOf("<p>") == 0) && (_text.lastIndexOf("</p>") == _text.length - 4))
				_text = _text.substring(3, _text.length - 4);
			
			return _text;
		}

		public function set htmlText(value:*):void
		{
			visible = (value != "")
			label.parseCSS();
			label.htmlText = "<p>" + value + "</p>";
			draw();
		}

		public function parseCSS(iCSSText:String = null):void
		{
			label.parseCSS(iCSSText);
			draw();
		}

		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			draw();
		}
	}
}
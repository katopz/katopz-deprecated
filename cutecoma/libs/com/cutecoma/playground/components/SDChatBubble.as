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
		public var id:String;
		
		private var _bgColor:Number = 0xFFFFFF;

		private var _header:Sprite;
		private var _back:Shape;

		private var _label:SDTextField;
		private var _pad:Number = 8;
		private var _length:Number = 8;
		private var _begPoint:Point = new Point(0, 0);

		private var _currentText:String;
		private var _CSS:String;

		public var drawSignal:Signal = new Signal(SDChatBubble);

		public function SDChatBubble(text:String = "")
		{
			_currentText = text;

			super();

			// default
			addChild(_back = new Shape());
			_back.filters = [new GlowFilter(0xCCCCCC, 1, 4, 4, 2, 1, true, false)];
			_back.cacheAsBitmap = true;

			addChild(_label = new SDTextField(_currentText));
			_label.multiline = true;
			_label.mouseEnabled = true;
			_label.autoSize = TextFieldAutoSize.LEFT;

			// drag
			addChild(_header = new Sprite());

			// speed
			mouseEnabled = mouseChildren = isDraggable = false;
			cacheAsBitmap = true;

			htmlText = _currentText;
		}

		override public function draw():void
		{
			var w:Number = (_label.width > _pad) ? _label.width : _pad;
			var h:Number = (_label.height > _pad) ? _label.height : _pad;

			_label.x = int(_pad); //int(-w * .5);
			_label.y = int(_pad); //int(-pad - length - h + pad * .25 - 1);

			_back.graphics.clear();
			_back.graphics.beginFill(_bgColor);
			_back.graphics.drawRoundRect(0, 0, w + _pad * 2, h + _pad * 2, _pad, _pad);
			_back.graphics.endFill();

			_header.graphics.beginFill(0xFF00FF, 0);
			_header.graphics.drawRoundRect(0, 0, w + _pad * 2, 20, _pad, _pad);
			_header.graphics.endFill();

			super.draw();

			drawSignal.dispatch(this);
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
			return _label.text;
		}

		public function set text(value:*):void
		{
			_label.text = value;
			draw();
		}

		public function get htmlText():String
		{
			var _text:String = _label.htmlText;
			if ((_text.indexOf("<p>") == 0) && (_text.lastIndexOf("</p>") == _text.length - 4))
				_text = _text.substring(3, _text.length - 4);
			
			return _text;
		}

		public function set htmlText(value:*):void
		{
			super.visible = (value != "");
			
			_label.parseCSS();
			_label.htmlText = "<p>" + value + "</p>";
			
			draw();
		}

		public function parseCSS(CSS:String = null):void
		{
			_CSS = CSS;
			
			_label.parseCSS(_CSS);
			draw();
		}

		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			draw();
		}
	}
}
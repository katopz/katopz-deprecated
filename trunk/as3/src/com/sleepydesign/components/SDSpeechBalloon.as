package com.sleepydesign.components
{
	import com.sleepydesign.text.SDTextField;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextFormat;

	public class SDSpeechBalloon extends SDComponent
	{
		private var _back:Shape;
		private var _text:String = "";
		protected var _htmlText:String = "";

		private var _float:String = "center";

		public var pad:uint = 8;
		public var length:uint = 4;
		public var textFormat:TextFormat;
		public var multiline:Boolean = true;
		public var color:Number = 0xFFFFFF;
		public var borderColor:Number = 0x000000;
		public var textColor:Number = 0x000000;

		protected var _tf:SDTextField;

		public function set float(value:String):void
		{
			_float = value;
			draw();
		}

		public function get float():String
		{
			return _float;
		}

		public function get label():SDTextField
		{
			return _tf
		}

		public function SDSpeechBalloon(text:String = "", textFormat:TextFormat = null, color:int = 0xFFFFFF, borderColor:int = 0x000000, pad:uint = 8, length:uint = 4)
		{
			_htmlText = _text = text;

			mouseEnabled = false;
			mouseChildren = false;

			this.textFormat = textFormat;
			this.color = color;
			this.borderColor = borderColor;
			this.pad = pad;
			this.length = length;

			_back = new Shape();
			addChild(_back);

			_tf = new SDTextField(_text, textFormat);
			_tf.multiline = multiline;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			_tf.autoSize = "left";

			addChild(_tf);

			draw();

			_tf.addEventListener(Event.CHANGE, onChange, false, 0, true);
		}

		override public function draw():void
		{
			_tf.text = _text;
			_tf.htmlText = _htmlText;

			var w:Number = (label.width > pad) ? label.width : pad;
			var h:Number = (label.height > pad) ? label.height : pad;

			w = (w < pad * 2) ? pad * 2 : w;

			//_tf.x = int(-w * .5);
			var _p0:int;

			_back.graphics.clear();

			// border
			_back.graphics.beginFill(borderColor);
			if (_float == "right")
			{
				_p0 = w * .5 - pad;
			}
			else if (_float == "left")
			{
				_p0 = -(w * .5 - pad);
			}
			else if (_float == "center")
			{
				_p0 = 0;
			}

			_tf.x = int(_p0 - w * .5);
			_tf.y = int(-pad - length - h + pad * .25 - 1);

			_back.graphics.drawRoundRect(_p0 - (w + .5) * .5 - (pad + 1) * .5 + (pad + 1) * .25, -(h - .5) - (pad + 1) - length, (w + .5) + (pad + 1) * .5, (h + .5) + (pad + 1) * .5, (pad + 1), (pad + 1));

			if (_float == "right")
			{
				_back.graphics.moveTo(-.5, 1);
				_back.graphics.lineTo(-.5, -length - (pad - 1) * .5);
				_back.graphics.lineTo((pad + .25), -length - (pad - 1) * .5);
			}
			else if (_float == "left")
			{
				_back.graphics.moveTo(.5, 1);
				_back.graphics.lineTo(.5, -length - (pad - 1) * .5);
				_back.graphics.lineTo(-(pad + .25), -length - (pad - 1) * .5);
			}
			else if (_float == "center")
			{
				_back.graphics.moveTo(0, 1);
				_back.graphics.lineTo(pad / 2 + .25, -length - (pad - 1) * .5);
				_back.graphics.lineTo(-pad / 2 - .25, -length - (pad - 1) * .5);
			}

			_back.graphics.endFill();

			_back.graphics.beginFill(color);
			_back.graphics.drawRoundRect(_p0 - w * .5 - pad * .5 + pad * .25, -h - pad - length, w + pad * .5, h + pad * .5, pad, pad);
			_back.graphics.moveTo(0, 0);

			if (_float == "right")
			{
				_back.graphics.lineTo(0, -length - pad * .5);
				_back.graphics.lineTo(pad, -length - pad * .5);
			}
			else if (_float == "left")
			{
				_back.graphics.lineTo(0, -length - pad * .5);
				_back.graphics.lineTo(-pad, -length - pad * .5);
			}
			else if (_float == "center")
			{
				_back.graphics.lineTo(pad / 2, -length - pad * .5);
				_back.graphics.lineTo(-pad / 2, -length - pad * .5);
			}
			_back.graphics.endFill();

			_width = _back.width;
			_height = _back.height;

			super.draw();
		}

		protected function onChange(event:Event):void
		{
			draw();
		}

		public function set text(t:String):void
		{
			_htmlText = _text = t;
			draw();
		}

		public function get text():String
		{
			return _text;
		}

		public function set htmlText(t:*):void
		{
			_htmlText = t;
			draw();
		}

		public function get htmlText():String
		{
			return _htmlText;
		}
	}
}
package com.sleepydesign.components
{
	import com.sleepydesign.text.SDTextField;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextFormat;

	public class DialogBalloon extends AbstractComponent
	{
		private var _back:Shape;
		private var _text:String = "";
		protected var _htmlText:String = "";

		public var pad:uint = 8;
		public var length:uint = 4;
		public var textFormat:TextFormat;
		public var multiline:Boolean = true;
		public var color:Number = 0xDDFFFFFF;

		protected var _tf:SDTextField;

		public function get label():SDTextField
		{
			return _tf
		}

		public function DialogBalloon(text:String = "")
		{
			_htmlText = _text = text;

			mouseEnabled = false;
			mouseChildren = false;

			create();
			draw();
		}

		public function create():void
		{
			_back = new Shape();
			addChild(_back);

			_tf = new SDTextField(_text, textFormat);
			_tf.multiline = multiline;
			_tf.selectable = false;
			_tf.mouseEnabled = false;

			addChild(_tf);

			filters = this.filters;

			_tf.addEventListener(Event.CHANGE, onChange);
		}

		override public function draw():void
		{
			_tf.text = _text;
			_tf.htmlText = _htmlText;

			var w:Number = (label.width > pad) ? label.width : pad;
			var h:Number = (label.height > pad) ? label.height : pad;

			//_tf.x = int(-w * .5);
			var _p0:int = w*.5-pad;
			_tf.x = int(_p0-w * .5);
			_tf.y = int(-pad - length - h + pad * .25 - 1);

			_back.graphics.clear();
			_back.graphics.beginFill(color);
			_back.graphics.drawRoundRect(_p0-w * .5 - pad * .5 + pad * .25, -h - pad - length, _p0+w + pad * .5, h + pad * .5, pad, pad);
			_back.graphics.moveTo(0, 0);
			_back.graphics.lineTo(0, -length - pad * .5);
			_back.graphics.lineTo(4, -length - pad * .5);

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
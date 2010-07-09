package com.cutecoma.effects
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class Btn extends Sprite
	{
		public var id:uint;
		private var shade:Shape;
		private var bottom:Shape;
		private var light:Shape;
		private var base:Shape;
		private var txt:TextField;
		private var label:String = "";
		private static var fontType:String = "_ゴシック";
		private var _width:uint = 60;
		private static var _height:uint = 20;
		private static var corner:uint = 5;
		private var type:uint = 1;
		private static var bColor:uint = 0xFFFFFF;
		private static var sColor:uint = 0x000000;
		private static var upColor:uint = 0x666666;
		private static var overColor:uint = 0x333333;
		private static var offColor:uint = 0x999999;
		private static var gColor:uint = 0x0099FF;
		private var blueGlow:GlowFilter;
		private var shadeGlow:GlowFilter;
		private var _clicked:Boolean = false;
		private var _enabled:Boolean = true;

		public function Btn()
		{
		}

		public function init(option:Object):void
		{
			if (option.id != undefined)
				id = option.id;
			if (option.label != undefined)
				label = option.label;
			if (option.width != undefined)
				_width = option.width;
			if (option.type != undefined)
				type = option.type;
			draw();
		}

		private function draw():void
		{
			switch (type)
			{
				case 1:
					bColor = 0xFFFFFF;
					sColor = 0x000000;
					upColor = 0x666666;
					overColor = 0x333333;
					offColor = 0x999999;
					break;
				case 2:
					bColor = 0x000000;
					sColor = 0xFFFFFF;
					upColor = 0x666666;
					overColor = 0x999999;
					offColor = 0x333333;
					break;
			}
			blueGlow = new GlowFilter(gColor, 0.6, 5, 5, 2, 3, false, true);
			shadeGlow = new GlowFilter(sColor, 0.3, 4, 4, 2, 3, false, true);
			shade = new Shape();
			bottom = new Shape();
			light = new Shape();
			base = new Shape();
			txt = new TextField();
			addChild(shade);
			addChild(bottom);
			addChild(light);
			addChild(base);
			addChild(txt);
			createBase(shade, _width, _height, corner, sColor);
			shade.filters = [shadeGlow];
			createBase(bottom, _width, _height, corner, sColor, 0.3);
			createBase(light, _width, _height, corner, gColor);
			light.filters = [blueGlow];
			createBase(base, _width, _height, corner, bColor);
			txt.x = -_width * 0.5;
			txt.y = -_height * 0.5;
			txt.width = _width;
			txt.height = _height - 1;
			txt.type = TextFieldType.DYNAMIC;
			txt.selectable = false;
			//txt.embedFonts = true;
			//txt.antiAliasType = AntiAliasType.ADVANCED;
			var tf:TextFormat = new TextFormat();
			tf.font = fontType;
			tf.size = 12;
			tf.align = TextFormatAlign.CENTER;
			txt.defaultTextFormat = tf;
			txt.text = label;
			enabled = true;
			mouseChildren = false;
		}

		private function rollOver(evt:MouseEvent):void
		{
			_over();
		}

		private function rollOut(evt:MouseEvent):void
		{
			_up();
		}

		private function press(evt:MouseEvent):void
		{
			_down();
		}

		private function release(evt:MouseEvent):void
		{
			_up();
		}

		private function click(evt:MouseEvent):void
		{
		}

		private function _up():void
		{
			txt.y = -_height * 0.5;
			txt.textColor = upColor;
			base.y = -1;
			light.visible = false;
			light.y = -1;
		}

		private function _over():void
		{
			txt.y = -_height * 0.5;
			txt.textColor = overColor;
			base.y = -1;
			light.visible = true;
			light.y = -1;
		}

		private function _down():void
		{
			txt.y = -_height * 0.5 + 1;
			txt.textColor = overColor;
			base.y = 0;
			light.visible = true;
			light.y = 0;
		}

		private function _off():void
		{
			txt.y = -_height * 0.5 + 1;
			txt.textColor = offColor;
			base.y = 0;
			light.visible = false;
			light.y = 0;
		}

		public function get clicked():Boolean
		{
			return _clicked;
		}

		public function set clicked(param:Boolean):void
		{
			_clicked = param;
			enabled = !_clicked;
			if (_clicked)
			{
				_down();
			}
			else
			{
				_up();
			}
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(param:Boolean):void
		{
			_enabled = param;
			buttonMode = _enabled;
			mouseEnabled = _enabled;
			useHandCursor = _enabled;
			if (_enabled)
			{
				_up();
				addEventListener(MouseEvent.MOUSE_OVER, rollOver, false, 0, true);
				addEventListener(MouseEvent.MOUSE_OUT, rollOut, false, 0, true);
				addEventListener(MouseEvent.MOUSE_DOWN, press, false, 0, true);
				addEventListener(MouseEvent.MOUSE_UP, release, false, 0, true);
				addEventListener(MouseEvent.CLICK, click, false, 0, true);
			}
			else
			{
				_off();
				removeEventListener(MouseEvent.MOUSE_OVER, rollOver);
				removeEventListener(MouseEvent.MOUSE_OUT, rollOut);
				removeEventListener(MouseEvent.MOUSE_DOWN, press);
				removeEventListener(MouseEvent.MOUSE_UP, release);
				removeEventListener(MouseEvent.CLICK, click);
			}
		}

		private function createBase(target:Shape, w:uint, h:uint, c:uint, color:uint, alpha:Number = 1):void
		{
			target.graphics.beginFill(color, alpha);
			target.graphics.drawRoundRect(-w * 0.5, -h * 0.5, w, h, c * 2);
			target.graphics.endFill();
		}

	}
}
package com.cutecoma.effects
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.InterpolationMethod;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Slider extends Sprite
	{
		private var hole:Shape;
		private var line:Sprite;
		private var thumb:Sprite;
		private var light:Shape;
		private var shade:Shape;
		private var base:Shape;
		private var title:TextField;
		private var txt:TextField;
		private var label:String = "";
		private static var fontType:String = "_ゴシック";
		private var _width:uint = 100;
		private static var tHeight:uint = 20;
		private static var bHeight:uint = 30;
		private var grid:uint = 5;
		private static var bColor:uint = 0xFFFFFF;
		private static var tColor:uint = 0x666666;
		private static var gColor:uint = 0x999999;
		private static var mColor:uint = 0x333333;
		private static var bgColor:uint = 0x0099FF;
		private static var sColor:uint = 0x000000;
		private static var offColor:uint = 0x999999;
		private var min:Number = 0;
		private var max:Number = 100;
		private var initValue:Number = 0;
		private var blueGlow:GlowFilter;
		private var shadeDrop:DropShadowFilter;
		private var value:Number;
		private var _enabled:Boolean = true;

		public function Slider()
		{
		}

		public function init(option:Object):void
		{
			if (option.label != undefined)
				label = option.label;
			if (option.width != undefined)
				_width = option.width;
			if (option.min != undefined)
				min = option.min;
			if (option.max != undefined)
				max = option.max;
			if (option.grid != undefined)
				grid = option.grid;
			if (option.init != undefined)
				initValue = option.init;
			draw();
		}

		private function draw():void
		{
			shadeDrop = new DropShadowFilter(1, 90, sColor, 0.5, 4, 4, 2, 3, false, false);
			blueGlow = new GlowFilter(bgColor, 0.6, 5, 5, 2, 3, false, true);
			hole = new Shape();
			line = new Sprite();
			title = new TextField();
			txt = new TextField();
			thumb = new Sprite();
			shade = new Shape();
			light = new Shape();
			base = new Shape();
			addChild(hole);
			addChild(line);
			addChild(title);
			addChild(txt);
			addChild(thumb);
			thumb.addChild(shade);
			thumb.addChild(light);
			thumb.addChild(base);
			hole.y = bHeight;
			createGradientHole(hole, _width, 3);
			line.y = bHeight;
			createGrid(line);
			title.height = tHeight - 1;
			title.type = TextFieldType.DYNAMIC;
			title.selectable = false;
			//title.embedFonts = true;
			//title.antiAliasType = AntiAliasType.ADVANCED;
			title.textColor = tColor;
			title.autoSize = TextFieldAutoSize.LEFT;
			var tfl:TextFormat = new TextFormat();
			tfl.font = fontType;
			tfl.size = 12;
			tfl.align = TextFormatAlign.LEFT;
			title.defaultTextFormat = tfl;
			title.text = label;
			//txt.x = title.textWidth;
			txt.x = 40;
			txt.width = 50;
			txt.height = tHeight - 1;
			txt.selectable = false;
			//txt.embedFonts = true;
			//txt.antiAliasType = AntiAliasType.ADVANCED;
			var tfr:TextFormat = new TextFormat();
			tfr.font = fontType;
			tfr.size = 12;
			tfr.align = TextFormatAlign.RIGHT;
			txt.defaultTextFormat = tfr;
			reset();
			thumb.y = bHeight;
			createThumb(shade, 8, 20, 12, sColor);
			shade.filters = [shadeDrop];
			createThumb(light, 8, 20, 12, bgColor);
			light.filters = [blueGlow];
			createThumb(base, 8, 20, 12, bColor);
			_up();
			enabled = true;
			thumb.mouseChildren = false;
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
			var rect:Rectangle = new Rectangle(0, bHeight, _width, 0);
			thumb.startDrag(false, rect);
			thumb.addEventListener(MouseEvent.MOUSE_UP, release, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, release, false, 0, true);
			stage.addEventListener(Event.MOUSE_LEAVE, leave, false, 0, true);
			thumb.addEventListener(Event.ENTER_FRAME, change, false, 0, true);
		}

		private function release(evt:MouseEvent):void
		{
			_up();
			thumb.stopDrag();
			checkValue();
			var e:CompoEvent = new CompoEvent(CompoEvent.SELECT, value);
			dispatchEvent(e);
			thumb.removeEventListener(MouseEvent.MOUSE_UP, release);
			stage.removeEventListener(MouseEvent.MOUSE_UP, release);
			stage.removeEventListener(Event.MOUSE_LEAVE, leave);
			thumb.removeEventListener(Event.ENTER_FRAME, change);
		}

		private function leave(evt:Event):void
		{
			_up();
			thumb.stopDrag();
			checkValue();
			var e:CompoEvent = new CompoEvent(CompoEvent.SELECT, value);
			dispatchEvent(e);
			thumb.removeEventListener(MouseEvent.MOUSE_UP, release);
			stage.removeEventListener(MouseEvent.MOUSE_UP, release);
			stage.removeEventListener(Event.MOUSE_LEAVE, leave);
			thumb.removeEventListener(Event.ENTER_FRAME, change);
		}

		private function _up():void
		{
			light.visible = false;
		}

		private function _over():void
		{
			light.visible = true;
		}

		private function _down():void
		{
			light.visible = true;
		}

		private function _off():void
		{
			light.visible = false;
			txt.textColor = offColor;
		}

		private function change(evt:Event):void
		{
			_down();
			checkValue();
			var e:CompoEvent = new CompoEvent(CompoEvent.CHANGE, value);
			dispatchEvent(e);
		}

		private function checkValue():void
		{
			value = min + Math.round(thumb.x / _width * (max - min));
			txt.text = String(value);
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function set enabled(param:Boolean):void
		{
			_enabled = param;
			if (!_enabled)
				_off();
			thumb.buttonMode = _enabled;
			thumb.mouseEnabled = _enabled;
			thumb.useHandCursor = _enabled;
			if (_enabled)
			{
				thumb.addEventListener(MouseEvent.MOUSE_OVER, rollOver, false, 0, true);
				thumb.addEventListener(MouseEvent.MOUSE_OUT, rollOut, false, 0, true);
				thumb.addEventListener(MouseEvent.MOUSE_DOWN, press, false, 0, true);
				thumb.addEventListener(MouseEvent.MOUSE_UP, release, false, 0, true);
			}
			else
			{
				thumb.removeEventListener(MouseEvent.MOUSE_OVER, rollOver);
				thumb.removeEventListener(MouseEvent.MOUSE_OUT, rollOut);
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN, press);
				thumb.removeEventListener(MouseEvent.MOUSE_UP, release);
			}
		}

		public function reset():void
		{
			thumb.x = _width * (initValue - min) / (max - min);
			value = initValue;
			txt.text = String(value);
		}

		private function createGrid(target:Sprite):void
		{
			for (var n:uint = 0; n <= grid; n++)
			{
				var w:uint = Math.floor(_width / grid);
				if (n == 0 || n == grid * 0.5 || n == grid)
				{
					createGridLine(target, w * n, mColor);
					var _txt:TextField = new TextField();
					target.addChild(_txt);
					_txt.x = w * n - 20;
					_txt.y = 13;
					_txt.width = 40;
					_txt.height = 14;
					_txt.selectable = false;
					//_txt.embedFonts = true;
					//_txt.antiAliasType = AntiAliasType.ADVANCED;
					//_txt.antiAliasType = AntiAliasType.NORMAL;
					_txt.textColor = mColor;
					var tfc:TextFormat = new TextFormat();
					tfc.font = fontType;
					tfc.size = 8;
					tfc.align = TextFormatAlign.CENTER;
					_txt.defaultTextFormat = tfc;
					if (n == 0)
						_txt.text = String(min);
					if (n == grid * 0.5)
						_txt.text = String(min + (max - min) * 0.5);
					if (n == grid)
						_txt.text = String(max);
				}
				else
				{
					createGridLine(target, w * n, gColor);
				}
			}
		}

		private function createThumb(target:Shape, w:uint, h:uint, y:uint, color:uint, alpha:Number = 1):void
		{
			target.graphics.beginFill(color, alpha);
			target.graphics.drawRoundRect(-w * 0.5, -y, w, h, w);
			target.graphics.endFill();
		}

		private function createGradientHole(target:Shape, w:uint, c:Number):void
		{
			var colors:Array = [0x000000, 0x000000];
			var alphas:Array = [0.4, 0];
			var ratios:Array = [0, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w + c * 2, c * 2, 0.5 * Math.PI, -c, -c);
			target.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
			target.graphics.drawRoundRect(-c, -c, w + c * 2, c * 2, c * 2);
			target.graphics.endFill();
		}

		private function createGridLine(target:Sprite, x:uint, color:uint):void
		{
			target.graphics.lineStyle(0, color);
			target.graphics.moveTo(x, 8);
			target.graphics.lineTo(x, 12);
		}

	}
}
package com.cutecoma.effects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.events.Event;

	//import sketchbook.colors.ColorUtil;

	public class LightFolium extends Sprite
	{
		private var light:Light;
		private var blink:Number;
		private var b:Number;
		private static var color1:uint = 0x66FFFF;
		private static var color2:uint = 0x3399FF;
		private var trans:ColorTransform;
		private var tx:Number;
		private var ty:Number;
		private var cx:Number;
		private var cy:Number;
		private var r:Number;
		private var angle:Number;
		private var a:Number;
		private var nx:Number;
		private var ny:Number;
		private static var radian:Number = Math.PI / 180;
		private static var deceleration:Number = 0.2;

		public function LightFolium()
		{
			light = new Light();
			addChild(light);
			trans = new ColorTransform(0, 0, 0, 1, 0, 0, 0, 0);
		}

		public function init(x:int, y:int, a:Number):void
		{
			this.x = cx = x;
			this.y = cy = y;
			angle = a;
			_blink(angle, 10);
		}

		private function _blink(blink:Number, b:Number):void
		{
			this.blink = blink;
			this.b = b;
		}

		private function blinking():void
		{
			blink += b;
			setRGB(Math.sin(blink * radian));
			light.transform.colorTransform = trans;
		}

		private function setRGB(percent:Number):void
		{
			var r1:int = (color1 >> 16 & 0xFF);
			var g1:int = (color1 >> 8 & 0xFF);
			var b1:int = (color1 & 0xFF);
			var r2:int = (color2 >> 16 & 0xFF);
			var g2:int = (color2 >> 8 & 0xFF);
			var b2:int = (color2 & 0xFF);
			trans.alphaMultiplier = 0.75 + 0.5 * percent;
			trans.redOffset = (r1 + r2) * 0.5 + (r2 - r1) * 0.5 * percent;
			trans.greenOffset = (g1 + g2) * 0.5 + (g2 - g1) * 0.5 * percent;
			trans.blueOffset = (b1 + b2) * 0.5 + (b2 - b1) * 0.5 * percent;
		}

		public function fly(r:Number, a:Number, nx:Number, ny:Number, dec:Number = 0.2):void
		{
			this.r = r;
			this.a = a;
			this.nx = nx;
			this.ny = ny;
			deceleration = dec;
			addEventListener(Event.ENTER_FRAME, flying, false, 0, true);
		}

		private function flying(evt:Event):void
		{
			blinking();
			angle += a;
			tx = cx + r * Math.sin(angle * nx * radian) * Math.cos(angle * radian);
			ty = cy + r * Math.sin(angle * ny * radian) * Math.sin(angle * radian);
			x += (tx - x) * deceleration;
			y += (ty - y) * deceleration;
		}
	}
}
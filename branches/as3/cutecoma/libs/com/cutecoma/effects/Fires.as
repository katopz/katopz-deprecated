package com.cutecoma.effects
{

	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Fires extends Sprite
	{
		private var flare:FlareMap;
		private var detection:DetectPixels;
		private static var max:uint = 30;
		private static var cx:int = 232;
		private static var cy:int = 250;
		private static var fw:uint = 340;
		private static var fh:uint = 360;
		private static var tw:uint = 320;
		private static var th:uint = 320;
		private var area:Rectangle;
		private var folium:Sprite;
		private var lights:Array;
		private var nx:uint = 1;
		private var ny:uint = 1;
		private static var interval:uint = 1500;

		public function Fires()
		{
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 465, 465);
			graphics.endFill();
			folium = new Sprite();
			addChild(folium);
			folium.x = cx - fw * 0.5;
			folium.y = fh - th;
			lights = [];
			for (var n:uint = 0; n < max; n++)
			{
				var light:LightFolium = new LightFolium();
				var angle:Number = 360 / max * n;
				light.init(fw * 0.5, cy - fh + th, angle);
				folium.addChild(light);
				light.fly(150, 1, nx, ny);
				lights.push(light);
			}
			var rect:Rectangle = new Rectangle(0, 0, fw, fh);
			flare = new FlareMap(rect);
			addChild(flare);
			flare.x = cx;
			flare.y = fh;
			area = new Rectangle(0, fh - th, tw, th);
			detection = new DetectPixels(4);
			detection.search(folium, area, 0x66FFFFFF);
			flare.map = detection.pixels();
			flare.setup(6, 2, 60);
			flare.start();
			var timer:Timer = new Timer(interval);
			timer.addEventListener(TimerEvent.TIMER, exchange, false, 0, true);
			timer.start();
			addEventListener(Event.ENTER_FRAME, draw, false, 0, true);
		}

		private function draw(evt:Event):void
		{
			detection.search(folium, area, 0x66FFFFFF);
			flare.map = detection.pixels();
		}

		private function exchange(evt:TimerEvent):void
		{
			var count:uint = evt.target.currentCount;
			nx = uint(count / 10) % 10 + 1;
			ny = count % 10 + 1;
			apply();
		}

		private function apply():void
		{
			for (var n:Number = 0; n < max; n++)
			{
				var light:LightFolium = lights[n];
				light.fly(150, 1, nx, ny);
			}
		}
	}
}
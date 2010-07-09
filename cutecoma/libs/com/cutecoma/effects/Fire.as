package com.cutecoma.effects
{
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class Fire extends Sprite
	{
		private var flare:Flare;
		private static var cx:uint = 232;
		private static var cy:uint = 250;
		private static var fw:uint = 80;
		private static var fh:uint = 250;
		private var speed:uint = 6;
		private var unit:uint = 8;
		private var segments:uint = 8;
		private var fireBtn:Btn;
		private var clearBtn:Btn;
		private var loader:Loader;

		public function Fire()
		{
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 465, 465);
			graphics.endFill();
			var rect:Rectangle = new Rectangle(0, 0, fw, fh);
			flare = new Flare(rect);
			addChild(flare);
			flare.x = cx;
			flare.y = cy;
			//flare.scaleX = flare.scaleY = 1.2;
			flare.addEventListener(Event.COMPLETE, complete, false, 0, true);
			setup();
		}

		private function fire(evt:MouseEvent):void
		{
			flare.start();
			fireBtn.clicked = true;
			clearBtn.enabled = true;
		}

		private function clear(evt:MouseEvent):void
		{
			flare.stop();
			clearBtn.enabled = false;
		}

		private function complete(evt:Event):void
		{
			fireBtn.clicked = false;
		}

		private function change1(evt:CompoEvent):void
		{
			speed = evt.value;
			flare.setup(speed, unit, segments);
		}

		private function change2(evt:CompoEvent):void
		{
			unit = evt.value;
			flare.setup(speed, unit, segments);
		}

		private function change3(evt:CompoEvent):void
		{
			segments = evt.value;
			flare.setup(speed, unit, segments);
		}

		private function setup():void
		{
			fireBtn = new Btn();
			fireBtn.x = 192;
			fireBtn.y = 350;
			addChild(fireBtn);
			fireBtn.init({id: 0, label: "fire", type: 2});
			fireBtn.addEventListener(MouseEvent.CLICK, fire, false, 0, true);
			clearBtn = new Btn();
			clearBtn.x = 272;
			clearBtn.y = 350;
			addChild(clearBtn);
			clearBtn.init({id: 1, label: "clear", type: 2});
			clearBtn.addEventListener(MouseEvent.CLICK, clear, false, 0, true);
			clearBtn.enabled = false;
			var base:Shape = new Shape();
			addChild(base);
			base.graphics.beginFill(0xFFFFFF);
			base.graphics.drawRect(0, 385, 465, 80);
			base.graphics.endFill();
			var slider1:Slider = new Slider();
			slider1.x = 62;
			slider1.y = 395;
			addChild(slider1);
			slider1.init({label: "speed", width: 100, min: 0, max: 10, grid: 10, init: 6});
			slider1.addEventListener(CompoEvent.CHANGE, change1, false, 0, true);
			var slider2:Slider = new Slider();
			slider2.x = 182;
			slider2.y = 395;
			addChild(slider2);
			slider2.init({label: "unit", width: 100, min: 0, max: 20, grid: 10, init: 8});
			slider2.addEventListener(CompoEvent.CHANGE, change2, false, 0, true);
			var slider3:Slider = new Slider();
			slider3.x = 302;
			slider3.y = 395;
			addChild(slider3);
			slider3.init({label: "segments", width: 100, min: 0, max: 20, grid: 10, init: 8});
			slider3.addEventListener(CompoEvent.CHANGE, change3, false, 0, true);
		}
	}
}
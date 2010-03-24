package com.sleepydesign.skins
{
	import com.sleepydesign.display.SDSprite;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class MacLoadingClip extends SDSprite
	{
		protected var timer:Timer;
		protected var slices:int;
		protected var radius:int;
		protected var colorValue:Number;
		
		protected var _canvas:SDSprite;

		public function MacLoadingClip(colorValue:Number = 0x666666, slices:int = 12, radius:int = 6)
		{
			this.slices = slices;
			this.radius = radius;
			this.colorValue = colorValue;
			
			_canvas = new SDSprite();
			addChild(_canvas);
			
			draw();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			timer = new Timer(65);
			timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			timer.start();
		}

		protected function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			timer.reset();
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer = null;
		}

		protected function onTimer(event:TimerEvent):void
		{
			_canvas.rotation = (_canvas.rotation + (360 / slices)) % 360;
		}

		protected function draw():void
		{
			var i:int = slices;
			var degrees:int = 360 / slices;
			while (i--)
			{
				var slice:Shape = getSlice();
				slice.alpha = Math.max(0.2, 1 - (0.1 * i));
				var radianAngle:Number = (degrees * i) * Math.PI / 180;
				slice.rotation = -degrees * i;
				slice.x = Math.sin(radianAngle) * radius;
				slice.y = Math.cos(radianAngle) * radius;
				_canvas.addChild(slice);
			}
		}

		protected function getSlice():Shape
		{
			var slice:Shape = new Shape();
			slice.graphics.beginFill(colorValue);
			slice.graphics.drawRoundRect(-1, 0, 2, 6, 12, 12);
			slice.graphics.endFill();
			return slice;
		}
	}
}
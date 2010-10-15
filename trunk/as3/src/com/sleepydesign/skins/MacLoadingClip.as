package com.sleepydesign.skins
{
	import com.sleepydesign.display.SDSprite;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class MacLoadingClip extends SDSprite
	{
		protected var _timer:Timer;
		protected var _slices:int;
		protected var _radius:int;
		protected var _colorValue:Number;
		
		protected var _canvas:SDSprite;

		public function MacLoadingClip(colorValue:Number = 0x666666, slices:int = 12, radius:int = 6)
		{
			_slices = slices;
			_radius = radius;
			_colorValue = colorValue;
			
			_canvas = new SDSprite();
			addChild(_canvas);
			
			cacheAsBitmap = true;
			mouseEnabled = false;
			
			draw();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			_timer = new Timer(64);
			_timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			_timer.start();
		}

		protected function onRemovedFromStage(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer = null;
		}

		protected function onTimer(event:TimerEvent):void
		{
			if(!visible)
				return;
			
			_canvas.rotation = (_canvas.rotation + (360 / _slices)) % 360;
		}

		protected function draw():void
		{
			if(!visible)
				return;
				
			var i:int = _slices;
			var degrees:int = 360 / _slices;
			while (i--)
			{
				var slice:Shape = getSlice();
				slice.alpha = Math.max(0.2, 1 - (0.1 * i));
				var radianAngle:Number = (degrees * i) * Math.PI / 180;
				slice.rotation = -degrees * i;
				slice.x = Math.sin(radianAngle) * _radius;
				slice.y = Math.cos(radianAngle) * _radius;
				_canvas.addChild(slice);
			}
		}

		protected function getSlice():Shape
		{
			var slice:Shape = new Shape();
			slice.graphics.beginFill(_colorValue);
			slice.graphics.drawRoundRect(-1, 0, 2, 6, 12, 12);
			slice.graphics.endFill();
			return slice;
		}
	}
}
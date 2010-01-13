package com.sleepydesign.controls
{
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.events.TransformEvent;
	
	import flash.events.Event;
	
	public class AbstractComponent extends SDSprite
	{
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		public function AbstractComponent():void
		{
			//
		}
		
		public function setSize(w:Number, h:Number):void
		{
			if(_width != w || _height != h)
			{
				_width = w;
				_height = h;
				draw();
				dispatchEvent(new TransformEvent(TransformEvent.RESIZE));
			}
		}

		override public function set width(w:Number):void
		{
			_width = w;
			draw();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set height(h:Number):void
		{
			_height = h;
			draw();
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		override public function get height():Number
		{
			return _height;
		}

		override public function set x(value:Number):void
		{
			super.x = int(value);
		}

		override public function set y(value:Number):void
		{
			super.y = int(value);
		}
		
		public function draw():void
		{
			
		}
	}
}
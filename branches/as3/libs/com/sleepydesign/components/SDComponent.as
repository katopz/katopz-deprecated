package com.sleepydesign.components
{
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.events.SDEvent;
	
	import flash.events.Event;
	
	/**
	 * 
	 * SDComponent : Abstract Class for Component
	 * @author katopz
	 * 
	 */	
	public class SDComponent extends SDContainer
	{
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		public function SDComponent():void
		{
			//
		}
		
		override protected function init():void
		{
			super.init();
			create();
			draw();
		}
		
		public function setSize(w:Number, h:Number):void
		{
			if(_width != w || _height != h)
			{
				_width = w;
				_height = h;
				draw();
				dispatchEvent(new SDEvent(SDEvent.RESIZE));
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
	}
}
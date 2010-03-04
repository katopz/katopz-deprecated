package com.sleepydesign.components
{
	import com.sleepydesign.display.SDSprite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class SDSlider extends SDComponent
	{
		protected var _handle:Sprite;
		private var _track:Sprite;
		
		protected var _value:Number = 0;
		protected var _max:Number = 100;
		protected var _min:Number = 0;
		protected var _orientation:String;
		
		private var _scrollSize:Number = SDStyle.SIZE;
		private var _pageSize:Number = 0;
		private var _lastPosition:Point;
		
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		
		public function SDSlider(orientation:String = SDSlider.HORIZONTAL)
		{
			_orientation = orientation;
			
			_track = new SDSprite();
			addChild(_track);
			
			_handle = new SDSprite();
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag, false, 0, true);
			_handle.buttonMode = false;
			_handle.useHandCursor = false;
			addChild(_handle);
			
			if(_orientation == HORIZONTAL)
				setSize(100, _scrollSize);
			else
				setSize(_scrollSize, 100);
		}
		
		protected function drawTrack():void
		{
			_track.graphics.clear();
			_track.graphics.lineStyle(.25,0x000000,1);
			_track.graphics.beginFill(SDStyle.BACKGROUND);
			_track.graphics.drawRect(0, 0, _width, _height);
			_track.graphics.endFill();
			
			_track.addEventListener(MouseEvent.MOUSE_DOWN, onTrackClick, false, 0, true);
		}
		
		protected function drawHandle(size:Number=0):void
		{
			_handle.graphics.clear();
			_scrollSize = size;
			
			_handle.graphics.lineStyle(SDStyle.BORDER_THICK, SDStyle.BORDER_COLOR, SDStyle.BORDER_ALPHA);
			_handle.graphics.beginFill(SDStyle.BUTTON_COLOR);
			
			if(_orientation == HORIZONTAL)
				_handle.graphics.drawRect(0, 0, _scrollSize, _height);
			else
				_handle.graphics.drawRect(0, 0, _width, _scrollSize);
			
			_handle.graphics.endFill();
			positionHandle();
		}
		
		protected function correctValue():void
		{
			if(_max > _min)
			{
				_value = Math.min(_value, _max);
				_value = Math.max(_value, _min);
			}
			else
			{
				_value = Math.max(_value, _max);
				_value = Math.min(_value, _min);
			}
		}
		
		protected function positionHandle():void
		{
			if(_orientation == HORIZONTAL)
			{
				_handle.x = Math.min(_value*(_width-_handle.width)/(_max-_min),(_width-_handle.width));
				_handle.x = Math.max(_handle.x,0);
			}
			else
			{
				_handle.y = Math.min(_value*(_height-_handle.height)/(_max-_min),(_height-_handle.height));
				_handle.y = Math.max(_handle.y,0);
			}
		}
		
		override public function draw():void
		{
			drawTrack();
			drawHandle(_scrollSize);
			super.draw();
		}
		
		public function setSliderParams(min:Number, max:Number, value:Number, pageSize:Number=10):void
		{
			this.minimum = min;
			this.maximum = max;
			this.value = value;
			this.pageSize = pageSize;
		}
		
		protected function onTrackClick(event:MouseEvent):void
		{
			var oldValue:Number = _value;
			if(_orientation == HORIZONTAL)
			{
				_handle.x = Math.max(mouseX - _handle.width*.5, 0);
				_handle.x = Math.min(_handle.x, width - _handle.width);
				_value = _handle.x*(_max-_min)/(_width-_handle.width);
			}
			else
			{
				_handle.y = Math.max(mouseY - _handle.height*.5, 0);
				_handle.y = Math.min(_handle.y, height - _handle.height);
				_value = _handle.y*(_max-_min)/(_height-_handle.height);
			}
			
			positionHandle();
			
			if(_value != oldValue)
				dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onDrag(event:MouseEvent):void
		{
			//click some where on _handle
			_lastPosition = new Point(DisplayObject(event.target).mouseX, DisplayObject(event.target).mouseY);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide, false, 0, true);
		}
		
		protected function onDrop(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			stopDrag();
		}
		
		protected function onSlide(event:MouseEvent):void
		{
	        var pt:Point = new Point(event.localX, event.localY);
	        pt = event.target.localToGlobal(pt);
	        pt = globalToLocal(pt);
			
			var oldValue:Number = _value;
			if(_orientation == HORIZONTAL)
			{
				_handle.x = Math.min(pt.x-_lastPosition.x*_handle.scaleX, _width - _handle.width);
				_handle.x = Math.max(_handle.x, 0);
				
				_value = _handle.x*(_max-_min)/(_width-_handle.width);
			}
			else
			{
				_handle.y = Math.min(pt.y-_lastPosition.y, _height - _handle.height);
				_handle.y = Math.max(_handle.y, 0);
				
				_value = _handle.y*(_max-_min)/(_height-_handle.height);
			}
			
			positionHandle();
			
			if(_value != oldValue)
				dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function set value(v:Number):void
		{
			_value = v;
			correctValue();
			positionHandle();
		}
		public function get value():Number
		{
			return _value;
		}
		
		public function set maximum(m:Number):void
		{
			_max = m;
			correctValue();
			positionHandle();
		}
		
		public function get maximum():Number
		{
			return _max;
		}
		
		public function set minimum(m:Number):void
		{
			_min = m;
			correctValue();
			positionHandle();
		}
		
		public function get minimum():Number
		{
			return _min;
		}
		
		public function set pageSize(v:Number):void
		{
			_value = v+_pageSize;
			correctValue();
			positionHandle();
		}
		
		public function get pageSize():Number
		{
			return _pageSize;
		}
	}
}

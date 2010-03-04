package com.sleepydesign.components
{
	import com.sleepydesign.events.TransformEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class SDScrollBar extends SDSlider
	{
		private var _scrollTarget:DisplayObject;
		public var step:Number = 10;

		public function SDScrollBar(orientation:String = SDSlider.VERTICAL)
		{
			super(orientation);
		}

		override public function draw():void
		{
			if (!_scrollTarget || !_scrollTarget.scrollRect)
				return;
				
			var _contentRect:Rectangle = _scrollTarget.getRect(_scrollTarget.parent);

			var _size:Number;
			if (_orientation == HORIZONTAL)
			{
				// auto align
				this.x = 0;
				this.y = _scrollTarget.height;

				// auto size
				_size = Math.max(SDStyle.SIZE, _width * _scrollTarget.scrollRect.width / _contentRect.width);
				setSize(_scrollTarget.scrollRect.width, SDStyle.SIZE);

				// full bar -> disable?
				visible = (_scrollTarget.scrollRect.width < _contentRect.width);

			}
			else
			{
				// auto align
				this.x = _scrollTarget.width;
				this.y = 0;

				// auto size
				_size = Math.max(SDStyle.SIZE, _height * _scrollTarget.scrollRect.height / _contentRect.height);
				setSize(SDStyle.SIZE, _scrollTarget.scrollRect.height);

				// full bar -> disable?
				visible = (_scrollTarget.scrollRect.height < _contentRect.height);
			}
			
			// draw
			drawTrack();
			drawHandle(_size);

			super.draw();
		}

		private function _onResize(event:TransformEvent):void
		{
			draw();
		}

		override public function get visible():Boolean
		{
			if (!_scrollTarget || !_scrollTarget.scrollRect)
				return true;
				
			var _contentRect:Rectangle = _scrollTarget.getRect(_scrollTarget.parent);
			
			if (_orientation == HORIZONTAL)
				return Boolean(_scrollTarget.scrollRect.width < _contentRect.width);
			else
				return Boolean(_scrollTarget.scrollRect.height < _contentRect.height);
		}

		private function onWheel(event:MouseEvent):void
		{
			if (_orientation == HORIZONTAL)
			{
				// not scroll content for HORIZONTAL
				if (event.currentTarget == this)
					value -= int(event.delta * step);
			}
			else
			{
				value -= int(event.delta * step);
			}
		}

		override protected function positionHandle():void
		{			
			if (!_scrollTarget || !_scrollTarget.scrollRect)
				return;
				
			super.positionHandle();
			
			var gap:Number;
			var _content:DisplayObject = _scrollTarget["content"] || _scrollTarget;
			var _contentRect:Rectangle = _content.getRect(_content);
			
			if (_orientation == HORIZONTAL)
			{
				gap = Math.max(0, _contentRect.width - _scrollTarget.scrollRect.width);
				_content.x = -value * gap / 100;
			}
			else
			{
				gap = Math.max(0, _contentRect.height - _scrollTarget.scrollRect.height);
				_content.y = -value * gap / 100;
			}
		}
		
		public function get scrollTarget():DisplayObject
		{
			return _scrollTarget;
		}

		public function set scrollTarget(panel:DisplayObject):void
		{
			// Remove event
			panel.removeEventListener(TransformEvent.RESIZE, _onResize);
			panel.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);

			// Setup
			_scrollTarget = panel;

			// View
			draw();

			// Add event
			panel.addEventListener(TransformEvent.RESIZE, _onResize, false, 0, true);
			panel.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
			addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
		}
	}
}
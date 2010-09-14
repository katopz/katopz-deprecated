package com.sleepydesign.components
{
	import com.sleepydesign.events.TransformEvent;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class SDScrollBar extends SDSlider
	{
		private var _scrollTarget:DisplayObject;
		public var lineScrollSize:Number = 10;

		public var enableHorizonWheel:Boolean;

		public function SDScrollBar(orientation:String = SDSlider.VERTICAL)
		{
			super(orientation);
		}

		override public function draw():void
		{
			if (!_scrollTarget || !_scrollTarget.scrollRect)
				return;

			//var _contentRect:Rectangle = _scrollTarget.getRect(_scrollTarget.parent);
			var _content:DisplayObject;
			try
			{
				_content = _scrollTarget["content"];
			}
			catch (e:*)
			{
				_content = _scrollTarget;
			}
			var _contentRect:Rectangle = _content.getRect(_content.parent);

			if (_orientation == HORIZONTAL)
			{
				// auto align
				this.x = 0;
				this.y = _scrollTarget.height;

				// auto size
				_scrollSize = Math.max(SDStyle.SIZE, _width * _scrollTarget.scrollRect.width / _contentRect.width);
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
				_scrollSize = Math.max(SDStyle.SIZE, _height * _scrollTarget.scrollRect.height / _contentRect.height);
				setSize(SDStyle.SIZE, _scrollTarget.scrollRect.height);

				// full bar -> disable?
				visible = (_scrollTarget.scrollRect.height < _contentRect.height);
			}

			// draw
			super.draw();
		}

		private function onResize(event:TransformEvent):void
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
				// not scroll content for HORIZONTAL if VERTICAL not exist
				if (event.currentTarget == this || enableHorizonWheel)
					scrollPosition -= int(event.delta * lineScrollSize);
			}
			else
			{
				scrollPosition -= int(event.delta * lineScrollSize);
			}
		}

		override protected function positionHandle():void
		{
			super.positionHandle();

			if (!_scrollTarget || !_scrollTarget.scrollRect)
				return;

			var gap:Number;
			var _content:DisplayObject;
			try
			{
				_content = _scrollTarget["content"];
			}
			catch (e:*)
			{
				_content = _scrollTarget;
			}
			var _contentRect:Rectangle = _content.getRect(_content.parent);

			if (_orientation == HORIZONTAL)
			{
				gap = Math.max(0, _contentRect.width - _scrollTarget.scrollRect.width);
				_content.x = -_scrollPosition * gap / 100;
			}
			else
			{
				gap = Math.max(0, _contentRect.height - _scrollTarget.scrollRect.height);
				_content.y = -_scrollPosition * gap / 100;
			}
		}

		public function get scrollTarget():DisplayObject
		{
			return _scrollTarget;
		}

		public function set scrollTarget(value:DisplayObject):void
		{
			// Remove event
			value.removeEventListener(TransformEvent.RESIZE, onResize);
			value.removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			removeEventListener(MouseEvent.MOUSE_WHEEL, onWheel);

			// Setup
			_scrollTarget = value;

			// View
			draw();

			// Add event
			value.addEventListener(TransformEvent.RESIZE, onResize, false, 0, true);
			value.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
			addEventListener(MouseEvent.MOUSE_WHEEL, onWheel, false, 0, true);
		}
	}
}
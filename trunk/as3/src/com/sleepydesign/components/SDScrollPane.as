package com.sleepydesign.components
{
	import com.sleepydesign.events.TransformEvent;

	import flash.display.DisplayObject;
	import flash.display.Shape;

	public class SDScrollPane extends SDComponent
	{
		public var panel:SDPanel;
		protected var _back:Shape;

		public var pad:uint = 0;

		private var _vScrollBar:SDScrollBar;
		private var _hScrollBar:SDScrollBar;

		public function SDScrollPane()
		{
			_back = new Shape();
			addChild(_back);

			_vScrollBar = new SDScrollBar(SDSlider.VERTICAL);
			addChild(_vScrollBar);

			_hScrollBar = new SDScrollBar(SDSlider.HORIZONTAL);
			addChild(_hScrollBar);

			panel = new SDPanel();
			addChild(panel);
			target = panel;

			setSize(100, 100);
		}

		public function set target(value:SDPanel):void
		{
			_vScrollBar.scrollTarget = value;
			_hScrollBar.scrollTarget = value;

			draw();
		}

		public function addContent(child:DisplayObject):DisplayObject
		{
			panel.addChild(child);
			target = panel;
			draw();
			return child;
		}

		public function removeContent(child:DisplayObject):DisplayObject
		{
			panel.removeChild(child);
			draw();
			return child;
		}

		override public function setSize(w:Number, h:Number):void
		{
			if (_width != w || _height != h)
			{
				_width = w;
				_height = h;

				panel.setSize(w, h);

				draw();
				dispatchEvent(new TransformEvent(TransformEvent.RESIZE));
			}
		}

		public function setPage(hPageNum:int, vPageNum:int = 0):void
		{
			contentX = -_hScrollBar.scrollTarget.scrollRect.width * hPageNum;
			contentY = -_vScrollBar.scrollTarget.scrollRect.height * vPageNum;
		}

		public function set contentX(value:Number):void
		{
			_hScrollBar.contentX = value;

			draw();
		}

		public function set contentY(value:Number):void
		{
			_vScrollBar.contentY = value;

			draw();
		}

		override public function draw():void
		{
			_vScrollBar.draw();
			_hScrollBar.draw();

			_hScrollBar.enableHorizonWheel = !_vScrollBar.visible;

			_back.graphics.clear();
			_back.graphics.lineStyle(SDStyle.BORDER_THICK, SDStyle.BORDER_COLOR, SDStyle.BORDER_ALPHA, true);
			_back.graphics.beginFill(SDStyle.BACKGROUND);
			_back.graphics.drawRoundRect(-pad / 2, -pad / 2, _vScrollBar.visible ? _vScrollBar.width + _width + pad : _width + pad, _hScrollBar.visible ? _hScrollBar.height + _height + pad : _height + pad, pad);
			_back.graphics.endFill();

			super.draw();
		}
	}
}
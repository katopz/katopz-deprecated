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

		private var _vscrollBar:SDScrollBar;
		private var _hscrollBar:SDScrollBar;

		public function SDScrollPane()
		{
			_back = new Shape();
			addChild(_back);

			_vscrollBar = new SDScrollBar(SDSlider.VERTICAL);
			addChild(_vscrollBar);

			_hscrollBar = new SDScrollBar(SDSlider.HORIZONTAL);
			addChild(_hscrollBar);

			panel = new SDPanel();
			addChild(panel);
			target = panel;

			setSize(100, 100);
		}

		public function set target(value:SDPanel):void
		{
			_vscrollBar.scrollTarget = value;
			_hscrollBar.scrollTarget = value;
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

		override public function draw():void
		{
			_vscrollBar.draw();
			_hscrollBar.draw();

			_hscrollBar.enableHorizonWheel = !_vscrollBar.visible;

			_back.graphics.clear();
			_back.graphics.lineStyle(SDStyle.BORDER_THICK, SDStyle.BORDER_COLOR, SDStyle.BORDER_ALPHA, true);
			_back.graphics.beginFill(SDStyle.BACKGROUND);
			_back.graphics.drawRoundRect(-pad / 2, -pad / 2, _vscrollBar.visible ? _vscrollBar.width + _width + pad : _width + pad, _hscrollBar.visible ? _hscrollBar.height + _height + pad : _height + pad, pad);
			_back.graphics.endFill();

			super.draw();
		}
	}
}
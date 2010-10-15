package com.sleepydesign.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.sleepydesign.events.TransformEvent;
	import com.sleepydesign.system.DebugUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;

	public class SDScrollPane extends SDComponent
	{
		public var panel:SDPanel;
		protected var _back:Shape;

		public var pad:uint = 0;

		private var _vScrollBar:SDScrollBar;
		private var _hScrollBar:SDScrollBar;
		
		public var scrollBarVisible:Boolean = true;
		private var _useMouseWheel:Boolean = true;

		public function get useMouseWheel():Boolean
		{
			return _useMouseWheel;
		}

		public function set useMouseWheel(value:Boolean):void
		{
			_useMouseWheel = value;
			
			_vScrollBar.useMouseWheel = value;
			_hScrollBar.useMouseWheel = value;
		}
		
		public function SDScrollPane(style:ISDStyle = null)
		{
			super(_style);
			
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

		public function slidePage(hPageNum:int, vPageNum:int = 0):void
		{
			// todo : custom slide tween
			
			var contentX:Number = -_hScrollBar.scrollTarget.scrollRect.width * hPageNum;
			if(_hScrollBar.contentX != contentX)
				TweenLite.to(_hScrollBar, 0.5, {contentX: contentX, onUpdate:draw, ease:Quad.easeOut});
			
			var contentY:Number = -_vScrollBar.scrollTarget.scrollRect.height * vPageNum;
			if(_vScrollBar.contentY != contentY)
				TweenLite.to(_vScrollBar, 0.5, {contentY: contentY, onUpdate:draw, ease:Quad.easeOut});
		}

		public function setPage(hPageNum:int, vPageNum:int = 0):void
		{
			var isDirty:Boolean = false;
			
			var contentX:Number = -_hScrollBar.scrollTarget.scrollRect.width * hPageNum;
			if(_hScrollBar.contentX != contentX)
			{
				_hScrollBar.contentX = contentX;
				isDirty = true;
			}
			
			var contentY:Number = -_vScrollBar.scrollTarget.scrollRect.height * vPageNum;
			if(_vScrollBar.contentY != contentY)
			{
				_vScrollBar.contentY = contentY;
				isDirty = true;
			}
			
			if(isDirty)
				draw();
		}
		
		public function get hPageNum():int
		{
			return Math.ceil(_hScrollBar.scrollTarget.width / _hScrollBar.scrollTarget.scrollRect.width);
		}
		
		public function get vPageNum():int
		{
			return Math.ceil(_hScrollBar.scrollTarget.height / _vScrollBar.scrollTarget.scrollRect.height);
		}

		override public function draw():void
		{
			_vScrollBar.draw();
			_hScrollBar.draw();

			_hScrollBar.enableHorizonWheel = !_vScrollBar.visible;
			
			_hScrollBar.enableHorizonWheel = _hScrollBar.enableHorizonWheel && useMouseWheel;
			
			_vScrollBar.visible = _vScrollBar.visible && scrollBarVisible;
			_hScrollBar.visible = _hScrollBar.visible && scrollBarVisible;

			/*
			_back.graphics.clear();
			_back.graphics.lineStyle(_style.BORDER_THICK, _style.BORDER_COLOR, _style.BORDER_ALPHA, true);
			_back.graphics.beginFill(0xFF0000, .5);//_style.BACKGROUND, _style.BACKGROUND_ALPHA);
			_back.graphics.drawRoundRect(-pad / 2, -pad / 2, _vScrollBar.visible ? _vScrollBar.width + _width + pad : _width + pad, _hScrollBar.visible ? _hScrollBar.height + _height + pad : _height + pad, pad);
			_back.graphics.endFill();
			*/

			super.draw();
		}
	}
}
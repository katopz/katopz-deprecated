package com.sleepydesign.components
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Rectangle;

	public class SDPanel extends SDComponent
	{
		protected var _back:Shape;

		public var content:DisplayObject;

		public function SDPanel(style:ISDStyle = null)
		{
			super(style);

			_back = new Shape();
			addChild(_back);

			setSize(100, 100);
			scrollRect = _back.getRect(_back.parent);
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			content = child;
			return super.addChild(content);
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return super.removeChild(content);
		}

		override public function draw():void
		{
			_back.graphics.clear();
			_back.graphics.lineStyle(); //_style.BORDER_THICK, _style.BORDER_COLOR, _style.BORDER_ALPHA, true);
			_back.graphics.beginFill(_style.BACKGROUND, _style.BACKGROUND_ALPHA);

			_back.graphics.drawRect(0, 0, _width, _height);
			_back.graphics.endFill();

			var _scrollRect:Rectangle = _back.getRect(_back.parent);
			//_scrollRect.width += _style.BORDER_THICK;
			//_scrollRect.height += _style.BORDER_THICK;
			scrollRect = _scrollRect;

			super.draw();
		}
	}
}
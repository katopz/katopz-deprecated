package com.sleepydesign.components
{
	import com.sleepydesign.events.TransformEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	
	public class SDScrollPane extends SDComponent
	{
		public var panel:SDPanel;
		protected var _back:Shape;
		
		public var pad :uint = 0;
		
		private var vscrollBar:SDScrollBar;
		private var hscrollBar:SDScrollBar;
		
		public function SDScrollPane()
		{
			_back = new Shape();
			addChild(_back);
			
			vscrollBar = new SDScrollBar(SDSlider.VERTICAL);
			addChild(vscrollBar);
			
			hscrollBar = new SDScrollBar(SDSlider.HORIZONTAL);
			addChild(hscrollBar);
			
			panel = new SDPanel();
			addChild(panel);
			target = panel;
			
			setSize(100, 100);
		}
		
		public function set target(value:SDPanel):void
		{
			vscrollBar.scrollTarget = value;
			hscrollBar.scrollTarget = value;
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
			if(_width != w || _height != h)
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
			vscrollBar.draw();
			hscrollBar.draw();
			
			_back.graphics.clear();
			_back.graphics.lineStyle(SDStyle.BORDER_THICK, SDStyle.BORDER_COLOR, SDStyle.BORDER_ALPHA, true );
			_back.graphics.beginFill(SDStyle.BACKGROUND);
			_back.graphics.drawRoundRect(-pad/2, -pad/2, vscrollBar.visible?vscrollBar.width+_width+pad:_width+pad, hscrollBar.visible?hscrollBar.height+_height+pad:_height+pad, pad);
			_back.graphics.endFill();
			
			super.draw();
		}
	}
}
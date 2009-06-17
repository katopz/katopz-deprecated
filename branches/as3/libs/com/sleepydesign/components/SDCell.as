package com.sleepydesign.components
{
	import com.sleepydesign.core.SDSprite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SDCell extends Component
	{
		private var _back:SDSprite;
		private var _face:SDSprite;
		private var _label:Label;
		private var _labelText:String = "";
		private var _over:Boolean = false;
		private var _down:Boolean = false;
		
		public function SDCell(label:String = "")
		{
			_labelText = label;
			super();
		}
		
		override protected function init():void
		{
			super.init();
			buttonMode = true;
			useHandCursor = true;
			setSize(23, 23);
		}
		
		override public function create(config:Object=null):void
		{
			_back = new SDSprite();
			_back.filters = [getShadow(2, true)];
			addChild(_back);
			
			_face = new SDSprite();
			_face.filters = [getShadow(1)];
			_face.x = 1;
			_face.y = 1;
			addChild(_face);
			
			_label = new Label();
			addChild(_label);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseIsDown, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
		}

		override public function draw():void
		{
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawRect(0, 0, _width, _height);
			_back.graphics.endFill();
			
			_face.graphics.clear();
			_face.graphics.beginFill(Style.BUTTON_FACE);
			_face.graphics.drawRect(0, 0, _width - 2, _height - 2);
			_face.graphics.endFill();
			
			_label.autoSize = true;
			_label.text = _labelText;
			if(_label.width > _width - 4)
			{
				_label.autoSize = false;
				_label.width = _width - 4;
			}
			_label.x = _width / 2 - _label.width / 2
			_label.y = _height / 2 - _label.height / 2;
			
			super.draw();
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			_over = true;
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			_over = false;
			if(!_down)
			{
				_face.filters = [getShadow(1)];
			}
		}
		
		private function onMouseIsDown(event:MouseEvent):void
		{
			_down = true;
			_face.filters = [getShadow(1, true)];
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseIsUp, false, 0, true);
		}
		
		private function onMouseIsUp(event:MouseEvent):void
		{
			_down = false;
			_face.filters = [getShadow(1)];
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseIsUp);
		}
		
		public function set label(str:String):void
		{
			_labelText = str;
			draw();
		}
		
		public function get label():String
		{
			return _labelText;
		}
	}
}
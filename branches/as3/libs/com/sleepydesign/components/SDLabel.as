package com.sleepydesign.components
{
	import com.sleepydesign.styles.SDStyle;
	import com.sleepydesign.text.SDTextField;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class SDLabel extends SDComponent
	{
		private var _text:String = "";
		private var _tf:TextField;
		public function get textField():TextField
		{
			return _tf;
		}
		
		public function SDLabel(text:String = "")
		{
			_text = text;
			super();
		}
		
		override protected function init():void
		{
			super.init();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		override public function create(config:Object=null):void
		{
			_height = SDStyle.SIZE;
			_tf = new SDTextField(_text);
			_tf.autoSize = TextFieldAutoSize.LEFT;
			addChild(_tf);
			_width = _tf.width;
		}
		
		override public function draw():void
		{
			_tf.text = _text?_text:"";
			
			if(_tf.autoSize!=TextFieldAutoSize.NONE)
			{
				_tf.autoSize = TextFieldAutoSize.LEFT;
				_width = _tf.width;
			}
			else
			{
				_tf.autoSize = TextFieldAutoSize.NONE;
			}
			_height = SDStyle.SIZE;
			super.draw();
		}
		
		public function set text(t:String):void
		{
			_text = t;
			draw();
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set autoSize(b:String):void
		{
			_tf.autoSize = b;
		}
		
		public function get autoSize():String
		{
			return _tf.autoSize;
		}
		
		override public function get width():Number
		{
			return _tf.width;
		}
		
		override public function get height():Number
		{
			return _tf.height;
		}
	}
}
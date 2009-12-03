package com.sleepydesign.components
{
	import com.sleepydesign.text.SDTextField;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	public class SDBalloon extends SDComponent
	{
		private var _back:Shape;
		private var _text:String = "";
		protected var _htmlText:String = "";
		
		public var pad :uint = 8;
		public var length :uint = 8;
		
		protected var _tf:SDTextField;
		
		public function get label():SDTextField{return _tf}
		
		public function SDBalloon( text:String="" )
		{
			_htmlText = text;
			
			mouseEnabled = false;
			mouseChildren = false;
			
			//create();
		}
		
		override public function create(config:Object=null):void
		{
			//default
			_config = config?config:{color:0xFFFFFF, multiline:true};
			
			super.create(_config);
			
			_back = new Shape();
			addChild(_back);

			_tf = new SDTextField(_text, _config.textFormat);
			_tf.multiline = _config.multiline;
    		_tf.selectable = false;
    		_tf.mouseEnabled = false;
    		
			addChild(_tf);
			
			filters = this._config.filters;
			
			_tf.addEventListener(Event.CHANGE, onChange);			
		}
		
		override public function draw():void
		{
			_tf.text = _text;
			_tf.htmlText = _htmlText;
			
			var w:Number = (label.width > pad)?label.width:pad;
			var h:Number = (label.height > pad)?label.height:pad;
			
			_tf.x = int(-w*.5);
			_tf.y = int( -pad - length - h + pad*.25 - 1);
			
			_back.graphics.clear();
			_back.graphics.beginFill(_config.color);
			_back.graphics.drawRoundRect(-w*.5-pad*.5+pad*.25, -h-pad-length, w+pad*.5,h+pad*.5,pad,pad);
			_back.graphics.moveTo(0,0);
			_back.graphics.lineTo(-4,-length-pad*.5);
			_back.graphics.lineTo(4, -length - pad * .5);
			
			_width = _back.width;
			_height = _back.height;
			
			super.draw();
		}
		
		protected function onChange(event:Event):void
		{
			draw();
		}
		
		public function set text(t:String):void
		{
			_htmlText =_text = t;
			draw();
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set htmlText(t:*):void
		{
			_htmlText = t;
			draw();
		}
		
		public function get htmlText():String
		{
			return _htmlText;
		}
	}
}
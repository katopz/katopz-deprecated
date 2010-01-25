package com.sleepydesign.components
{
	import com.sleepydesign.text.SDTextField;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	/**
	 * 
	 * InputText Component can be export from Flash MovieClip
	 * @author katopz
	 * 
	 */	
	public class TextInput extends AbstractComponent
	{
		public var id:String;
		
		private var _password:Boolean 		= false;
		private var _text:String 			= "";
		private var _tf:TextField;
		
		public var type:String 				= "";
		
		public var defaultText : String 	= "";
		public var isRequired : Boolean 	= false;
		public var isReset : Boolean 		= false;
		
		private var _disable : Boolean 		= false;
		public var isEdit : Boolean 		= false;
		public var isValid : Boolean 		= false;
		
		private var _isFlash:Boolean 		= false;
		
		public function get label():TextField{return _tf}
		public function set label(value:TextField):void
		{
			if(value)
			{
				addChildAt(value, 0);
				create();
			}else{
				label.parent.removeChild(label);
				_tf = null;
			}
		}
		
		public function TextInput(text:String = "" , textField:TextField = null)
		{
			_text = this.defaultText = text;
			
			if(textField)
			{
				textField.parent.addChild(this);
				label = textField;
			}
		}
		
		protected function create():void
		{
			try
			{
				// Flash TextField exist
				_tf = this.getChildAt(0) as TextField;//["labelText"];
				_isFlash = true;
				
				// no internal config?
				if(this.defaultText=="")
				{
					// use default from flash
					this.defaultText = _tf.text;
					text = this.defaultText; 
				}
				
				if(_tf.displayAsPassword)
				{
					type = "password";
				}
			}
			catch(e:*)
			{
				// Pure AS3
				_isFlash = false;
				_tf = new SDTextField(_text);
	    		_tf.selectable = true;
	    		_tf.mouseEnabled = true;
	    		_tf.background = true;
	    		_tf.type = TextFieldType.INPUT;
	    		_tf.autoSize = TextFieldAutoSize.NONE;
	    		_tf.styleSheet = null;
	    		
				addChild(_tf);
				setSize(100, 18);
			}
			
			_tf.addEventListener(Event.CHANGE, onChange);
			
		}
		
		override public function destroy():void
		{
			_tf.removeEventListener(Event.CHANGE, onChange);
			if(_tf.parent)
				_tf.parent.removeChild(_tf);
			_tf = null;
			
			super.destroy();
		}
		
		override public function draw():void
		{
			if(!_tf)return;
			
			_tf.displayAsPassword = _password;
			_tf.text = _text;
			
			if(!_isFlash)
			{
				_tf.width = _width;
				_tf.height = _height;
			}
			super.draw();
		}		
		
		protected function onChange(event:Event):void
		{
			_text = _tf.text;
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
		
		public function setText(t:String):void
		{
			_text = t;
		}
		
		public function set restrict(str:String):void
		{
			_tf.restrict = str;
		}
		
		public function get restrict():String
		{
			return _tf.restrict;
		}
		
		public function set maxChars(max:int):void
		{
			_tf.maxChars = max;
		}
		
		public function get maxChars():int
		{
			return _tf.maxChars;
		}
		
		public function set displayAsPassword(b:Boolean):void
		{
			_password = b;
			draw();
		}
		
		public function get displayAsPassword():Boolean
		{
			return _password;
		}
		
		public function set disable(b:Boolean):void
		{
			_disable = b;
			_tf.mouseEnabled = !b;
			_tf.tabEnabled = !b;
			_tf.selectable = !b;
		}
		
		public function get disable():Boolean
		{
			return _disable;
		}
	}
}
package com.sleepydesign.ui
{

	import com.sleepydesign.core.SDApplication;
	import com.sleepydesign.core.SDObject;
	import com.sleepydesign.events.SDKeyboardEvent;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class SDKeyBoard extends SDObject
	{
		public static var keyRight 		:Boolean = false;
		public static var keyLeft    	:Boolean = false;
		public static var keyForward 	:Boolean = false;
		public static var keyBackward 	:Boolean = false;
		public static var keyUp 		:Boolean = false;
		public static var keyDown 		:Boolean = false;
		
		public static var keyPeekLeft 	:Boolean = false;
		public static var keyPeekRight	:Boolean = false;
		
		public static var isCTRL		:Boolean = false;
		public static var isALT			:Boolean = false;
		public static var isSHIFT		:Boolean = false;
		public static var isSPACE		:Boolean = false;
		public static var isCAPLOCK		:Boolean = false;
		
		private var target:InteractiveObject;
		
		public function SDKeyBoard(target:InteractiveObject)
		{
			init({target:target});
		}
		
		override public function init(raw:Object=null):void
		{
			target = raw.target?raw.target:SDApplication.getStage();
			create();
		}
		
		override public function create(config:Object=null):void
		{
			target.addEventListener(KeyboardEvent.KEY_DOWN, onInnerKey, false, 0, true);
			target.addEventListener(KeyboardEvent.KEY_UP, onInnerKey, false, 0, true);
		}
			
		override public function destroy():void
		{
			target.removeEventListener(KeyboardEvent.KEY_DOWN, onInnerKey);
			target.removeEventListener(KeyboardEvent.KEY_UP, onInnerKey);
			target.removeEventListener(Event.ENTER_FRAME, onKey);
		}
		
		private function onKey( event:Event ):void
		{
			var dx :int = 0;
			var dy :int = 0;
			var dz :int = 0;
			var dr :int = 0;
			
			//up,down
			if( keyForward ){
				dz=1;
			}else if ( keyBackward ){
				dz=-1;
			}
			
			//left,right
			if( keyRight ){
				dx=1;
			}else if ( keyLeft ){
				dx=-1;
			}
			
			//up,down
			if( keyUp ){
				dy=1
			}else if ( keyDown ){
				dy=-1;
			}
			
			//peek left, peek right
			if( keyPeekLeft ){
				dr=-1
			}else if ( keyPeekRight ){
				dr=1;
			}			
			dispatchEvent(new SDKeyboardEvent(SDKeyboardEvent.KEY_PRESS,{dx:dx, dy:dy, dz:dz, dr:dr}))
		}
		
		private function onInnerKey( event:KeyboardEvent ):void
		{
			isCTRL = event.ctrlKey;
			isALT = event.altKey;
			isSHIFT = event.shiftKey;
			isSPACE = (event.keyCode == Keyboard.SPACE);
			//trace("event.shiftKey:"+event.shiftKey)
			
			switch(event.type) 
			{
				case KeyboardEvent.KEY_DOWN:
					switch(event.keyCode)
					{
						case "W".charCodeAt():
						case Keyboard.UP:
							keyForward = true;
							keyBackward = false;
							break;

						case "S".charCodeAt():
						case Keyboard.DOWN:
							keyBackward = true;
							keyForward = false;
							break;

						case "A".charCodeAt():
						case Keyboard.LEFT:
							keyLeft = true;
							keyRight = false;
							break;

						case "D".charCodeAt():
						case Keyboard.RIGHT:
							keyRight = true;
							keyLeft = false;
							break;

						case "C".charCodeAt():
						case Keyboard.PAGE_UP:
							keyDown = true;
							keyUp = false;
							break;

						case "V".charCodeAt():
						case Keyboard.PAGE_DOWN:
							keyUp = true;
							keyDown = false;
							break;
							
						case "Q".charCodeAt():
						case "[".charCodeAt():
							keyPeekLeft = true;
							keyPeekRight = false;
							break;

						case "E".charCodeAt():
						case "]".charCodeAt():
							keyPeekRight = true;
							keyPeekLeft = false;
							break;
					}
					if(keyForward || keyBackward || keyLeft || keyRight || keyUp || keyDown || keyPeekLeft || keyPeekRight)
						target.addEventListener(Event.ENTER_FRAME, onKey, false, 0, true);
				break;
				case KeyboardEvent.KEY_UP:
					switch( event.keyCode )
					{
						case "W".charCodeAt():
						case Keyboard.UP:
							keyForward = false;
							break;

						case "S".charCodeAt():
						case Keyboard.DOWN:
							keyBackward = false;
							break;

						case "A".charCodeAt():
						case Keyboard.LEFT:
							keyLeft = false;
							break;

						case "D".charCodeAt():
						case Keyboard.RIGHT:
							keyRight = false;
							break;
							
						case "C".charCodeAt():
						case Keyboard.PAGE_UP:
							keyDown = false;
							break;

						case "V".charCodeAt():
						case Keyboard.PAGE_DOWN:
							keyUp = false;
							break;
							
						case "Q".charCodeAt():
						case "[".charCodeAt():
							keyPeekLeft = false;
							keyPeekRight = false;
							break;

						case "E".charCodeAt():
						case "]".charCodeAt():
							keyPeekRight = false;
							keyPeekLeft = false;
							break;
					}
					if(!keyForward && !keyBackward && !keyLeft && !keyRight && !keyPeekLeft && !keyPeekRight && !keyUp && !keyDown)
						target.removeEventListener(Event.ENTER_FRAME, onKey);
				break;
			}
		}
	}
}

package com.sleepydesign.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;

	public class InputController extends EventDispatcher
	{
		public var keyboard:SDKeyBoard;
		public var mouse:SDMouse;

		public function InputController(container:DisplayObjectContainer, isMouse:Boolean = true, isKey:Boolean = false)
		{
			if (!container.stage)
				return;

			//Mouse
			if (isMouse)
				mouse = new SDMouse(container.stage);

			//Keyboard
			if (isKey)
				keyboard = new SDKeyBoard(container.stage);
		}

		public function destroy():void
		{
			mouse.destroy();
			keyboard.destroy();
		}
	}
}
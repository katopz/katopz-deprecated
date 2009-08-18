package com.sleepydesign.ui
{

	import com.sleepydesign.application.core.SDApplication;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;

	public class InputController extends EventDispatcher
	{
		private var currentStage	:Stage;
		
		public var keyboard			:SDKeyBoard;
		public var mouse			:SDMouse;
		
		public function InputController( isMouse:Boolean = true, isKey:Boolean = false) 
		{
			// Application
			currentStage = SDApplication.getStage();
			
			if(!currentStage)return;
			
			//Mouse
			if (isMouse)
				mouse = new SDMouse(currentStage);
							
			//Keyboard
			if (isKey)
				keyboard = new SDKeyBoard(currentStage);
		}
			
		public function destroy():void
		{
			mouse.destroy();
			keyboard.destroy();
		}
	}
}

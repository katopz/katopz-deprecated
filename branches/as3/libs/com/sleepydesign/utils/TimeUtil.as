package com.sleepydesign.utils 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.*;
	
	public class TimeUtil 
	{
		public static var startTime:Number;
		public static var currentTime:String;
		public static var separateChar:String;
		
		public static function getTime(container:Sprite, separateChar:String=":"):void 
		{
			TimeUtil.separateChar = separateChar;
			
			startTime = getTimer();
			
			container.removeEventListener(Event.ENTER_FRAME, run);
			container.addEventListener(Event.ENTER_FRAME, run);
		}
		
		public static function run(event:Event):void
		{
			var msecs:Number = getTimer()-startTime;
		
			var secs:Number = Math.floor(msecs/1000); // 1000 milliseconds make a second
			var mins:Number = Math.floor(secs/60); // 60 seconds make a minute
			var hours:Number = Math.floor(mins/60); // 60 minutes make a hour
			var days:Number = Math.floor(hours/24); // 24 hours make a second
		
			msecs = (msecs % 1000);
			secs = (secs % 60);
			mins = (mins % 60);
			hours = (hours % 24);
			
			var arr:Array = [
				StringUtil.add0(days),
				StringUtil.add0(hours),
				StringUtil.add0(mins),
				StringUtil.add0(secs),
				StringUtil.add0(msecs,3)
			];
			
			currentTime = arr.join(separateChar);
		}
	}
}

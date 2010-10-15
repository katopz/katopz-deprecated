package com.sleepydesign.components
{
	public interface ISDStyle
	{
		function get INPUT_BG_COLOR():uint;
		function get INPUT_BG_ALPHA():uint;
		
		function get BACKGROUND():uint;
		function get BACKGROUND_ALPHA():uint;
		
		function get BUTTON_COLOR():uint;
		function get BUTTON_ALPHA():uint;
		
		function get BORDER_THICK():Number;
		function get BORDER_COLOR():uint;
		function get BORDER_ALPHA():uint;
		
		function get BUTTON_UP_TWEEN():Object;
		function get BUTTON_OVER_TWEEN():Object;
		function get BUTTON_DOWN_TWEEN():Object;
		
		function get LABEL_TEXT():uint;
		
		function get SIZE():uint;
	}
}
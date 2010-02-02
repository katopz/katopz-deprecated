package com.sleepydesign.styles
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	public class SDStyle
	{
		public static const _effect:Boolean = TweenPlugin.activate([AutoAlphaPlugin, GlowFilterPlugin]);
		
		public static var BACKGROUND:uint = 0x000000;
		public static var BACKGROUND_ALPHA:uint = 1;
		
		public static var BUTTON_COLOR:uint 		= 0xFFFFFF;
		public static var BUTTON_ALPHA:uint			= 1;
		
		public static var BORDER_THICK:Number 		= 1;
		public static var BORDER_COLOR:uint			= 0x000000;
		public static var BORDER_ALPHA:uint			= 1;
		
		public static var BUTTON_UP_TWEEN:Object 	= {glowFilter:{alpha:1, blurX:4, blurY:4, color:0x999999, strength:1, quality:1, inner:true}};
		public static var BUTTON_OVER_TWEEN:Object 	= {glowFilter:{alpha:1, blurX:4, blurY:4, color:0xFFFFFF, strength:2, quality:1, inner:true}};
		public static var BUTTON_DOWN_TWEEN:Object 	= {glowFilter:{alpha:1, blurX:4, blurY:4, color:0x000000, strength:1, quality:1, inner:true}};
		
		public static var LABEL_TEXT:uint = 0x000000;
		/*
		public static var INPUT_TEXT:uint = 0x000000;
		
		public static var DROPSHADOW:uint = 0x000000;
		public static var PANEL:uint = 0xF3F3F3;
		public static var PROGRESS_BAR:uint = 0xFFFFFF;
		*/
		public static var SIZE:uint = 10; 
	}
}
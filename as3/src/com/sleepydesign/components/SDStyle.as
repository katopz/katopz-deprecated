package com.sleepydesign.components
{
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;

	public class SDStyle implements ISDStyle
	{
		private const _effect:Boolean = TweenPlugin.activate([AutoAlphaPlugin, GlowFilterPlugin, BlurFilterPlugin]);

		public function get INPUT_BG_COLOR():uint
		{
			return 0xFFFFFF
		}
		;

		public function get INPUT_BG_ALPHA():uint
		{
			return 1
		}
		;

		public function get BACKGROUND():uint
		{
			return 0xEEEEEE
		}
		;

		public function get BACKGROUND_ALPHA():uint
		{
			return 1
		}
		;

		public function get BUTTON_COLOR():uint
		{
			return 0xFFFFFF
		}
		;

		public function get BUTTON_ALPHA():uint
		{
			return 1
		}
		;

		public function get BORDER_THICK():Number
		{
			return 1
		}
		;

		public function get BORDER_COLOR():uint
		{
			return 0x000000
		}
		;

		public function get BORDER_ALPHA():uint
		{
			return 1
		}
		;

		public function get BUTTON_UP_TWEEN():Object
		{
			return {glowFilter: {alpha: 1, blurX: 4, blurY: 4, color: 0x999999, strength: 1, quality: 1, inner: true}}
		}
		;

		public function get BUTTON_OVER_TWEEN():Object
		{
			return {glowFilter: {alpha: 1, blurX: 4, blurY: 4, color: 0xFFFFFF, strength: 2, quality: 1, inner: true}}
		}
		;

		public function get BUTTON_DOWN_TWEEN():Object
		{
			return {glowFilter: {alpha: 1, blurX: 4, blurY: 4, color: 0x000000, strength: 1, quality: 1, inner: true}}
		}
		;

		public function get LABEL_TEXT():uint
		{
			return 0x000000
		}
		;

		/*
		   public function get INPUT_TEXT():uint{return 0x000000};

		   public function get DROPSHADOW():uint{return 0x000000};
		   public function get PANEL():uint{return 0xF3F3F3};
		   public function get PROGRESS_BAR():uint{return 0xFFFFFF};
		 */
		public function get SIZE():uint
		{
			return 10
		}
		;
	}
}
package com.sleepydesign.components.items
{
	import com.sleepydesign.display.SDSprite;

	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class SDItemSkin extends SDSprite
	{
		protected var _skin:Sprite;

		public function get skin():Sprite
		{
			return _skin;
		}

		public function get titleText():TextField
		{
			return skin.getChildByName("titleText") as TextField;
		}

		public function get imgClip():Sprite
		{
			return skin.getChildByName("imgClip") as Sprite;
		}

		public function get hitClip():Sprite
		{
			return skin.getChildByName("hitClip") as Sprite;
		}

		public function get boundClip():Sprite
		{
			return skin.getChildByName("boundClip") as Sprite;
		}

		/*
		override public function get width():Number
		{
			return scrollRect.width;
		}

		override public function get height():Number
		{
			return scrollRect.height;
		}
		*/

		public function SDItemSkin(skin:Sprite, scrollRect:Rectangle = null)
		{
			addChild(_skin = skin);
			this.scrollRect = scrollRect; // ? scrollRect : boundClip.getRect(boundClip);
		}
	}
}
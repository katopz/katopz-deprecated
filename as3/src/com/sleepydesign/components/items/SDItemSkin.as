package com.sleepydesign.components.items
{
	import com.sleepydesign.display.SDSprite;

	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class SDItemSkin extends SDSprite
	{
		public function get _skin():Sprite
		{
			return null;
		}

		public function get titleText():TextField
		{
			return _skin.getChildByName("titleText") as TextField;
		}

		public function get imgClip():Sprite
		{
			return _skin.getChildByName("imgClip") as Sprite;
		}

		public function get hitClip():Sprite
		{
			return _skin.getChildByName("hitClip") as Sprite;
		}

		public function get boundClip():Sprite
		{
			return _skin.getChildByName("boundClip") as Sprite;
		}

		public static function get SKIN_WIDTH():Number
		{
			return 100;
		}

		public static function get SKIN_HEIGHT():Number
		{
			return 100;
		}

		override public function get width():Number
		{
			return SKIN_WIDTH;
		}

		override public function get height():Number
		{
			return SKIN_HEIGHT;
		}

		public function SDItemSkin()
		{
			scrollRect = new Rectangle(0, 0, width, height);
			addChild(_skin);

		/*
		graphics.beginFill(0x00FFFF, 0.5);
		graphics.drawRect(0, 0, item_width, 100);
		graphics.endFill();

		imgClip = new Sprite;
		imgClip.graphics.beginFill(0x00FF00, 0.5);
		imgClip.graphics.drawRect(0, 0, 50, 50);
		imgClip.graphics.endFill();
		addChild(imgClip);

		imgClip.x = (scrollRect.width - imgClip.width) * .5;
		imgClip.y = (scrollRect.height - imgClip.height) * .5;

		titleText = new TextField
		titleText.width = 50;
		titleText.height = 16;
		//titleText.autoSize = TextFieldAutoSize.LEFT;
		addChild(titleText);
		*/
		}
	}
}
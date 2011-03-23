package com.sleepydesign.components.items
{
	import com.facebook.gallery.view.styles.AlbumItemSkin;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.sleepydesign.display.DrawUtil;
	import com.sleepydesign.display.SDClip;
	import com.sleepydesign.skins.MacLoadingClip;
	import com.sleepydesign.system.DebugUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class SDItemThumb extends SDClip
	{
		public var isSelected:Boolean;

		public var index:int;

		public var id:String;
		public var title:String;

		public var bitmap:Bitmap;

		protected var _skin:SDItemSkin

		public var loaderClip:MacLoadingClip;

		private var _hitArea:Sprite;

		protected var _disable:Boolean;

		public var isAutoSize:Boolean = true;

		public function get disable():Boolean
		{
			return _disable;
		}

		public function set disable(value:Boolean):void
		{
			_disable = value;
		}

		public function SDItemThumb(index:int, id:String, title:String, skin:SDItemSkin)
		{
			this.index = index;

			this.id = id;
			this.title = title;

			//useHandCursor = true;
			//buttonMode = true;
			//cacheAsBitmap = true;

			// skin
			addChild(_skin = skin);

			_skin.mouseEnabled = false;

			if (title && title != "")
				setTitle(title);

			// loader
			addChild(loaderClip = new MacLoadingClip(0xFFFFFF));
			loaderClip.x = _skin.imgClip.x + _skin.imgClip.width * .5;
			loaderClip.y = _skin.imgClip.y + _skin.imgClip.height * .5;

			//deactivate();

			TweenLite.defaultEase = Quad.easeOut;
			TweenLite.to(this, .25, {autoAlpha: 1});

			// mouse effect
			TweenPlugin.activate([GlowFilterPlugin]);

			// hit area
			var rect:Rectangle;

			if (_skin.hitClip)
				rect = new Rectangle(0, 0, _skin.hitClip.width, _skin.hitClip.height);
			else
				rect = new Rectangle(0, 0, _skin.width, _skin.height);

			if (_skin.boundClip)
				_skin.boundClip.visible = false;

			//rect.inflate(-10, -10);

			_hitArea = addChild(DrawUtil.drawRect(rect, 0xFF0000, 0)) as Sprite;
			_hitArea.useHandCursor = true;
			_hitArea.buttonMode = true;

			_hitArea.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			_hitArea.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);

			//_hitArea.mouseEnabled = true;

			//DrawUtil.drawRectTo(graphics, rect, 0xFF0000, 0);

			//addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			//addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);

			//var bgClip:Sprite = _clip.getChildByName("bgClip") as Sprite;
			//bgClip.mouseEnabled = false;

			//can be click even image didn't load yet
			//activate();
		}

		private function onMouseOver(event:MouseEvent):void
		{
			if (!isSelected)
				TweenLite.to(this, .25, {glowFilter: {color: 0xFFFFFF, blurX: 4, blurY: 4, strength: 1, alpha: .75}});
		}

		private function onMouseOut(event:MouseEvent):void
		{
			if (!isSelected)
				restoreEffect();
		}

		public function restoreEffect():void
		{
			TweenLite.to(this, 1, {glowFilter: {color: 0xFFFFFF, blurX: 0, blurY: 0, strength: 0, alpha: 0, remove: true}});
		}

		override public function show():void
		{
			TweenLite.to(bitmap, .25, {autoAlpha: 1, onComplete: shown});
		}

		override public function hide():void
		{
			TweenLite.to(bitmap, .25, {autoAlpha: 0, onComplete: hidden});
		}

		override public function deactivate():void
		{
			super.deactivate();

			if (parent && parent.contains(this))
				parent.removeChild(this);
		}

		public function setTitle(value:String):void
		{
			var titleText:TextField = _skin["titleText"] as TextField;
			titleText.text = value;
			titleText.mouseEnabled = false;
			titleText.mouseWheelEnabled = false;
			//DebugUtil.trace(" ! setTitle : " + titleText.text);
		}

		public function setImage(bitmapData:BitmapData):void
		{
			if (!bitmap)
			{
				// add guide
				var imgClip:Sprite = _skin.imgClip as Sprite;

				// real bitmap
				//imgClip.addChild();

				// deactivate
				//bitmap.visible = false;
				//bitmap.alpha = 0;

				bitmap = new Bitmap(new BitmapData(imgClip.width, imgClip.height));
				addChild(bitmap);
				bitmap.x = imgClip.x;
				bitmap.y = imgClip.y;

				/*				// copy transform
								bitmap.transform.matrix = imgClip.transform.matrix.clone();

								// remove guide
								TweenLite.to(imgClip, .25, {autoAlpha: 0, onCompleteParams: [imgClip], onComplete: function(imgClip:Sprite):void
										{
											imgClip.parent.removeChild(imgClip);
										}});
				*/
				// hide loader
				if (loaderClip)
				{
					loaderClip.destroy();
					loaderClip = null;
				}
			}

			var ratioH:Number = bitmap.height / bitmapData.height;
			var ratioV:Number = bitmap.width / bitmapData.width;

			if (ratioV > ratioH)
				ratioH = ratioV;
			else
				ratioV = ratioH;

			var offsetX:Number = -((bitmapData.width * ratioH) - bitmap.width) * .5;
			var offsetY:Number = -((bitmapData.height * ratioV) - bitmap.height) * .5;

			bitmap.smoothing = true;
			bitmap.bitmapData.draw(bitmapData, isAutoSize ? new Matrix(ratioH, 0, 0, ratioV, offsetX, offsetY) : null);

			//bitmap.bitmapData.fillRect(bitmap.bitmapData.rect, 0x00FFFFFF);
			//bitmap.bitmapData.copyPixels(bitmapData, bitmap.bitmapData.rect, new Point);
		}

		override public function destroy():void
		{
			if (loaderClip)
				loaderClip.destroy();
			loaderClip = null;

			if (bitmap)
			{
				TweenLite.killTweensOf(bitmap);
				bitmap.bitmapData.dispose();
			}

			_hitArea.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_hitArea.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			super.destroy();
		}
	}
}
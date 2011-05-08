package com.sleepydesign.components.items
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.sleepydesign.display.DrawUtil;
	import com.sleepydesign.display.SDClip;
	import com.sleepydesign.skins.MacLoadingClip;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class SDItemThumb extends SDClip
	{
		public var isSelected:Boolean;

		public var index:int;

		public var id:String;
		public var title:String;
		public var type:String;

		public var bitmap:Bitmap;

		protected var _skin:SDItemSkin

		public function get skin():SDItemSkin
		{
			return _skin;
		}

		public var loaderClip:MacLoadingClip;

		//private var _hitArea:Sprite;

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

		public function SDItemThumb(index:int, id:String, title:String, skin:SDItemSkin, type:String = null)
		{
			this.index = index;

			this.id = id;
			this.title = title;
			this.type = type;

			cacheAsBitmap = true;

			// skin
			addChild(_skin = skin);

			_skin.mouseEnabled = false;
			_skin.mouseChildren = false;

			if (title && title != "")
				setTitle(title);

			// loader
			addChild(loaderClip = new MacLoadingClip(0xFFFFFF));
			loaderClip.x = _skin.imgClip.x + _skin.imgClip.width * .5;
			loaderClip.y = _skin.imgClip.y + _skin.imgClip.height * .5;

			TweenLite.defaultEase = Quad.easeOut;
			alpha = 1;
			visible = true;

			// mouse effect
			TweenPlugin.activate([GlowFilterPlugin]);

			// hit area
			var rect:Rectangle;

			if (_skin.hitClip)
			{
				rect = new Rectangle(_skin.hitClip.x, _skin.hitClip.y, _skin.hitClip.x + _skin.hitClip.width, _skin.hitClip.y + _skin.hitClip.height);
				_skin.hitClip.parent.removeChild(_skin.hitClip);
			}
			else
			{
				rect = new Rectangle(0, 0, _skin.width, _skin.height);
			}

			if (_skin.boundClip)
				_skin.boundClip.parent.removeChild(_skin.boundClip);

			hitArea = addChild(DrawUtil.drawRect(rect, 0xFF0000, 0)) as Sprite;
			//DrawUtil.drawRectTo(graphics, rect, 0xFFFF00, 0.5);

			mouseChildren = false;
			useHandCursor = true;
			buttonMode = true;

			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
		}

		protected function onMouseOver(event:MouseEvent):void
		{
			if (!isSelected)
				TweenLite.to(_skin, .25, {glowFilter: {color: 0xFFFFFF, blurX: 4, blurY: 4, strength: 1, alpha: .75}});
		}

		protected function onMouseOut(event:MouseEvent):void
		{
			if (!isSelected)
				restoreEffect();
		}

		public function restoreEffect():void
		{
			TweenLite.to(_skin, .5, {glowFilter: {color: 0xFFFFFF, blurX: 0, blurY: 0, strength: 0, alpha: 0, remove: true}});
		}

		override public function show():void
		{
			TweenLite.to(_skin, .25, {autoAlpha: 1, onComplete: shown});
			TweenLite.to(_skin.imgClip, .25, {autoAlpha: 1});
		}

		override public function hide():void
		{
			TweenLite.to(_skin, .25, {autoAlpha: 0, onComplete: hidden});
		}

		override public function deactivate():void
		{
			super.deactivate();

			if (parent && parent.contains(this))
				parent.removeChild(this);
		}

		public function setTitle(value:String):void
		{
			_skin.titleText.text = value;
			_skin.titleText.mouseEnabled = false;
			_skin.titleText.mouseWheelEnabled = false;
			//DebugUtil.trace(" ! setTitle : " + _skin.titleText.text);
		}

		public function setImage(bitmapData:BitmapData):void
		{
			if (!bitmap)
			{
				// add guide
				var imgClip:Sprite = _skin.imgClip as Sprite;

				bitmap = new Bitmap(new BitmapData(imgClip.width, imgClip.height));
				bitmap.smoothing = true;
				imgClip.addChild(bitmap);
				imgClip.alpha = 0;

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
			bitmap.bitmapData.draw(bitmapData, isAutoSize ? new Matrix(ratioH, 0, 0, ratioV, offsetX, offsetY) : null, null, null, null, true);
			bitmap.smoothing = true;
		}

		override public function destroy():void
		{
			if (loaderClip)
				loaderClip.destroy();
			loaderClip = null;

			if (bitmap)
			{
				TweenLite.killTweensOf(_skin);
				bitmap.bitmapData.dispose();
			}

			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			super.destroy();
		}
	}
}
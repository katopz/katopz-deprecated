package view
{
	import com.sleepydesign.core.IDestroyable;
	import com.sleepydesign.display.DrawUtil;
	import com.sleepydesign.display.SDSprite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Crystal extends SDSprite implements IDestroyable
	{
		[Embed(source="assets/game.swf", symbol="CrystalClip")]
		private const _CrystalClip:Class;
		private var _crystalClip:MovieClip = new _CrystalClip();

		public var id:int;
		
		private var _width:Number = config.CYSTAL_SIZE;

		override public function get width():Number
		{
			return _width;
		}

		private var _height:Number = config.CYSTAL_SIZE;

		override public function get height():Number
		{
			return _height;
		}

		private var _focus:Boolean;

		public function Crystal()
		{
			addChild(_crystalClip);

			_crystalClip.cacheAsBitmap = true;
			_crystalClip.stop();

			_crystalClip["hilightClip"].visible = false;

			useHandCursor = true;
			buttonMode = true;
			cacheAsBitmap = true;

			hitArea = addChild(DrawUtil.drawRect(_width, _height, 0x000000, 0)) as Sprite;
		}

		public function spin(value:int = -1):void
		{
			if (value == -1)
				_crystalClip.gotoAndStop(int(_crystalClip.totalFrames * Math.random()));
		}

		public function set focus(value:Boolean):void
		{
			_crystalClip["hilightClip"].visible = _focus = value;
		}

		public function get focus():Boolean
		{
			return _focus;
		}

		override public function destroy():void
		{
			_crystalClip = null;

			super.destroy();
		}
	}
}
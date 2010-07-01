package com.cutecoma.game.core
{
	import com.cutecoma.playground.data.AreaData;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.net.FileUtil;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.system.DebugUtil;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 *
	 * Background is any assets type that's always on bottom.
	 * best format is PNG via SWF compression as JPG
	 *
	 * @author katopz
	 *
	 */
	public class Background extends SDSprite
	{
		private var _content:DisplayObject;
		private var _src:String;

		public var path:String = "";

		public function Background()
		{
			mouseEnabled = false;
			mouseChildren = false;
		}

		public function open():void
		{
			FileUtil.openImage(onBackgroundComplete, [_src]);
		}

		public function update(areaData:AreaData):void
		{
			dispose();

			LoaderUtil.loadAsset(path + areaData.background, onBackgroundComplete);
			DebugUtil.trace(" ! BackGround : " + path + areaData.background);
		}

		private function onBackgroundComplete(event:Event):void
		{
			if (event.type == "complete")
			{
				_content = addChild(event.target["content"]);
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		// ______________________________ Destroy ______________________________

		private function dispose():void
		{
			if (_content && _content.parent)
				_content.parent.removeChild(_content);

			_content = null;
		}

		override public function destroy():void
		{
			dispose();

			super.destroy();
		}
	}
}
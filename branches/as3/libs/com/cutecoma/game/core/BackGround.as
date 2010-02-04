package com.cutecoma.game.core
{
	import com.cutecoma.playground.data.AreaData;
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.utils.LoaderUtil;

	import flash.display.DisplayObject;
	import flash.events.Event;

	public class BackGround extends SDContainer
	{
		private var content:DisplayObject;

		public function BackGround(areaData:AreaData)
		{
			super("background");
			mouseEnabled = false;
			mouseChildren = false;
		}

		public function update(areaData:AreaData):void
		{
			if (content)
				destroy();

			LoaderUtil.loadAsset(areaData.background, onBackgroundComplete);

			//this._data = areaData;
		}

		private function onBackgroundComplete(event:Event):void
		{
			if (event.type == "complete")
				content = addChild(event.target["content"]);
		}

		// ______________________________ Destroy ______________________________

		override public function destroy():void
		{
			if (content)
				removeChild(content);

			content = null;
		}
	}
}
﻿package com.cutecoma.game.core
{
	import com.cutecoma.playground.data.AreaData;
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.utils.FileUtil;
	import com.sleepydesign.utils.LoaderUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class BackGround extends SDContainer
	{
		private var content:DisplayObject;
		private var _src:String;

		public function BackGround(src:String)
		{
			super("background");
			mouseEnabled = false;
			mouseChildren = false;
			
			var _srcs:Array = src.split("/"); 
			_src = _srcs.pop();
		}

		public function open():void
		{
			FileUtil.openAsset(onBackgroundComplete, [_src]);//FileUtil.DEFAULT_ASSETS.concat(["*.swf"]));
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
			{
				content = addChild(event.target["content"]);
				dispatchEvent(new Event(Event.CHANGE));
			}
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
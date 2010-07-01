package com.cutecoma.game.core
{
	import com.cutecoma.playground.data.AreaData;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.net.FileUtil;
	import com.sleepydesign.net.LoaderUtil;
	import com.sleepydesign.system.DebugUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class Background extends SDSprite
	{
		private var content:DisplayObject;
		private var _src:String;
		
		public var path:String = "";

		public function Background()
		{
			mouseEnabled = false;
			mouseChildren = false;
			
			/*
			var _srcs:Array = src.split("/"); 
			_src = _srcs.pop();
			*/
		}

		public function open():void
		{
			FileUtil.openImage(onBackgroundComplete, [_src]);//FileUtil.DEFAULT_ASSETS.concat(["*.swf"]));
		}
		
		public function update(areaData:AreaData):void
		{
			dispose();

			LoaderUtil.loadAsset(path+areaData.background, onBackgroundComplete);
			DebugUtil.trace(" ! BackGround : "+path+areaData.background);
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
		
		private function dispose():void
		{
			if (content && content.parent)
				content.parent.removeChild(content);
			
			content = null;
		}

		override public function destroy():void
		{
			dispose();
			
			super.destroy();
		}
	}
}
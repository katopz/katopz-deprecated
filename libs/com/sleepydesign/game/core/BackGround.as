﻿package com.sleepydesign.game.core
{
	import com.sleepydesign.core.SDApplication;
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.core.SDLoader;
	import com.sleepydesign.events.SDEvent;
	
	import flash.display.Bitmap;
	
	public class BackGround extends SDContainer
	{
		private var loader:SDLoader;
		private var background:Bitmap;
		
		public function BackGround(raw:Object)
		{
			super("background", raw);
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		override public function init(raw:Object=null):void
		{
			loader = SDApplication.getLoader();
			update(raw);
		}
		
		/*
		override public function create(config:Object=null):void
		{
			super.create(config);
			
			loader.load(config.background);
			loader.addEventListener(SDEvent.COMPLETE, onBackground);
		}
		*/
		
		override public function update(data:Object=null):void
		{
			trace("update:"+data.background);
			
			if(background)
				removeChild(background);
			
			loader.load(data.background);
			loader.addEventListener(SDEvent.COMPLETE, onBackground);
			
			// TODO : BackGroundData
			this._data = data;
		}
		
		private function onBackground(event:SDEvent):void
		{
			if(loader.isContent(_data.background))
			{
				loader.removeEventListener(SDEvent.COMPLETE, onBackground);
				background = Bitmap(loader.getContent(_data.background));
				addChild(background);
			}
		}
		
		// ______________________________ Destroy ______________________________
/*
		override public function destroy():void
		{
			if(background)
				removeChild(background);
		}
*/
		/*
		public function toCenter(obj) {
			obj.x = (stage.stageWidth - obj.width) * .5;
			obj.y = (stage.stageHeight - obj.height) * .5;			
		}
		*/
	}
}
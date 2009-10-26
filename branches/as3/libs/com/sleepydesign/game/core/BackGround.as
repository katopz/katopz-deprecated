package com.sleepydesign.game.core
{
	import com.sleepydesign.application.core.SDApplication;
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.core.SDLoader;
	import com.sleepydesign.events.SDEvent;
	
	import flash.display.Bitmap;
	
	public class BackGround extends SDContainer
	{
		private var loader:SDLoader;
		private var bitmap:Bitmap;
		
		public function BackGround(raw:Object)
		{
			super("background");
			mouseEnabled = false;
			mouseChildren = false;
			
			loader = SDApplication.getLoader();
		}
		/*
		override protected function init():void
		{
			
			//update(raw);
		}
		*/
		/*
		override public function create(config:Object=null):void
		{
			super.create(config);
			
			loader.load(config.background);
			loader.addEventListener(SDEvent.COMPLETE, onBackground);
		}
		*/
		
		public function update(data:Object=null):void
		{
			trace("update:"+data.background);
			
			if(bitmap)
				removeChild(bitmap);
			
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
				bitmap = Bitmap(loader.getContent(_data.background));
				addChild(bitmap);
			}
		}
		
		// ______________________________ Destroy ______________________________

		override public function destroy():void
		{
			if(bitmap)
				removeChild(bitmap);
		}

		/*
		public function toCenter(obj) {
			obj.x = (stage.stageWidth - obj.width) * .5;
			obj.y = (stage.stageHeight - obj.height) * .5;			
		}
		*/
	}
}
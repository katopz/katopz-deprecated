package com.cutecoma.playground.core
{
	import com.cutecoma.game.core.BackGround;
	import com.cutecoma.playground.data.AreaData;
	import com.sleepydesign.display.SDSprite;
	
	public class Area extends SDSprite
	{
		public var background:BackGround;
		public var map:Map;
		public var ground:Ground;

		private var _data:AreaData;

		public function get data():AreaData
		{
			return _data;
		}
		
		public function Area(areaData:AreaData)
		{
			// background
			background = new BackGround(areaData.background);
			addChild(background);
		
			update(areaData);
		}
		
		public function update(areaData:AreaData):void
		{
			if(_data == areaData)
				return;
			
			_data = areaData;
			
			background.update(areaData);
			
			// map
			if(!map)
			{
				map = new Map();
				addChild(map);
			}
			
			map.update(areaData);
			
			if(ground)
				ground.update();
		}
		
		override public function destroy():void
		{
			background.destroy();
			map.destroy();
			ground.destroy();
			
			super.destroy();
		}
	}
}
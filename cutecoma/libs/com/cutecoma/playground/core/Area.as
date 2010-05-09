package com.cutecoma.playground.core
{
	import away3dlite.primitives.Plane;
	
	import com.cutecoma.game.core.BackGround;
	import com.cutecoma.game.core.IEngine3D;
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
		
		public function Area(engine3D:IEngine3D, areaData:AreaData)
		{
			// background
			background = new BackGround(areaData.background);
			addChild(background);
			
			//map
			addChild(map = new Map);
			map.update(areaData);
			
			// Ground
			ground = new Ground(engine3D);
			//ground.update(map.data);
		
			update(areaData);
		}
		
		public function update(areaData:AreaData):void
		{
			if(_data == areaData)
				return;
			
			_data = areaData;
			
			background.update(areaData);
			map.update(areaData);
			ground.update(map.data);
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
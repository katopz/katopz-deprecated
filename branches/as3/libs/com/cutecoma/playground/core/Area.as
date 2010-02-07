package com.cutecoma.playground.core
{
	import com.cutecoma.game.core.BackGround;
	import com.cutecoma.playground.data.AreaData;
	import com.sleepydesign.core.SDContainer;
	
	import flash.events.Event;
	
	public class Area extends SDContainer
	{
		public var background:BackGround;
		public var map:Map;
		public var ground:Ground;

		public var data:AreaData;
		
		public function Area(areaData:AreaData)
		{
			//super();
			//init({engine3D:engine3D, game:game});
			// background
			background = new BackGround(areaData.background);
			//DEV//
			addChild(background);
			
			//background.addEventListener(Event.CHANGE);
			
			//mouseEnabled = false;
			//mouseChildren = false;
			
			super("Area");
			
			id  = areaData.id;
			data = areaData;
			create(areaData);
		}
		
		// ______________________________ Create ______________________________
		
		override public function create(config:Object=null):void
		{
			super.create(config);
			update(AreaData(config));
		}
		
		// ______________________________ Update ____________________________
		
		public function update(data:AreaData):void
		{
			this.data = data;
			
			id  = data.id;
			background.update(data);
			
			// map
			if(!map)
			{
				map = new Map();
				addChild(map);
				//map.visible = false;
			}
			
			map.update(data);
			
			if(ground)
				ground.update();
		}
		
		// ______________________________ Destroy ______________________________

		override public function destroy():void
		{
			id = null;
			background.destroy();
			map.destroy();
			ground.destroy();
		}
		
		/*
		public function setArea(areaID:String):void
		{
			trace("setMap:"+areaID);
			background.update({
				background:"assets/day2.jpg"
			});
		}
		*/
	}
}
package com.sleepydesign.playground.core
{
	import com.sleepydesign.core.SDContainer;
	import com.sleepydesign.game.core.BackGround;
	import com.sleepydesign.playground.data.AreaData;
	
	public class Area extends SDContainer
	{
		public var background:BackGround;
		public var map:Map;
		public var ground:Ground;

		public var data:AreaData;
		
		public function Area(config:*)
		{
			//super();
			//init({engine3D:engine3D, game:game});
			// background
			background = new BackGround(config);
			addChild(background);
			
			mouseEnabled = false;
			mouseChildren = false;
			
			super("Area", config);
		}
		
        // ______________________________ Initialize ______________________________
        
		override public function init(raw:Object=null):void
		{
			id  = raw.id;
			data = AreaData(raw);
			create(raw);
		}
		
		// ______________________________ Create ______________________________
		
		override public function create(config:Object=null):void
		{
			super.create(config);
				
			// Map
			map = new Map({
				source 	: config.src, 
				factorX : config.width, 
				factorZ : config.height
			});
			addChild(map);
		}
		
		// ______________________________ Update ____________________________
		
		override public function update(data:Object=null):void
		{
			id  = data.id;
			background.update(data);
			map.update(data);
			ground.update(data);
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
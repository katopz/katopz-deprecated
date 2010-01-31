package com.cutecoma.playground.core
{
	import com.sleepydesign.core.SDContainer;
	import com.cutecoma.game.core.BackGround;
	import com.cutecoma.playground.data.AreaData;
	
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
			
			super("Area");
			
			parse(config);
		}
		
        // ______________________________ Initialize ______________________________
        
		public function parse(raw:Object=null):void
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
			map.visible = false;
			
			update(AreaData(config));
		}
		
		// ______________________________ Update ____________________________
		
		public function update(data:AreaData):void
		{
			this.data = data;
			
			id  = data.id;
			background.update(data);
			map.update(data);
			
			if(ground)
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
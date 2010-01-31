package com.cutecoma.playground.core
{
	import com.sleepydesign.core.SDContainer;
	import com.cutecoma.game.core.BackGround;
	import com.cutecoma.playground.data.AreaData;
	
	public class Area extends SDContainer
	{
		public var background:BackGround;
		public var terrain:Terrain;
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
				
			// terrain
			if(!terrain)
			{
				terrain = new Terrain(AreaData(config));
				addChild(terrain);
				terrain.visible = false;
			}
			
			update(AreaData(config));
		}
		
		// ______________________________ Update ____________________________
		
		public function update(data:AreaData):void
		{
			this.data = data;
			
			id  = data.id;
			background.update(data);
			terrain.update(data);
			
			if(ground)
				ground.update(data);
		}
		
		// ______________________________ Destroy ______________________________

		override public function destroy():void
		{
			id = null;
			background.destroy();
			terrain.destroy();
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
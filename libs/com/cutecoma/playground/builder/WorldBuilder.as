package com.cutecoma.playground.builder
{
	import com.cutecoma.playground.core.Area;
	import com.cutecoma.playground.core.Engine3D;
	import com.cutecoma.playground.events.GroundEvent;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class WorldBuilder extends Sprite
	{
		public var areaBuilder:AreaBuilder;

		private var engine3D:Engine3D;
		private var area:Area;

		public function WorldBuilder(engine3D:Engine3D, area:Area)
		{
			this.engine3D = engine3D;
			this.area = area;
		}

		private var _isActivate:Boolean = false;
		public function get isActivate():Boolean
		{
			return _isActivate;
		}
		/*
		public function set isActivate(value:Boolean):void
		{
			_isActivate = value;
		}
		*/

		public function deactivate():void
		{
			_isActivate = false;

			if (areaBuilder)
			{
				area.ground.removeEventListener(GroundEvent.MOUSE_DOWN, onTileClick);
				area.map.visible = engine3D.grid = area.ground.debug = engine3D.axis = false;
				removeChild(areaBuilder);
				areaBuilder = null;
			}
		}

		public function activate():void
		{
			_isActivate = true;

			if (!areaBuilder)
			{
				areaBuilder = new AreaBuilder(engine3D, area);
				addChild(areaBuilder);
				area.map.visible = engine3D.grid = area.ground.debug = engine3D.axis = true;
				area.ground.addEventListener(GroundEvent.MOUSE_DOWN, onTileClick);
			}
		}
		
		public function onTileClick(event:GroundEvent):void
		{
			trace("TilePlane:"+event, event.bitmapX, event.bitmapZ);
			
			var _bitmapData:BitmapData = area.map.data.bitmapData;
			_bitmapData.setPixel32(event.bitmapX, event.bitmapZ , 0xFF000000);
			area.ground.update();
		}
	}
}
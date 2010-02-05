package com.cutecoma.playground.editors
{
	import com.cutecoma.playground.core.Area;
	import com.cutecoma.playground.core.Engine3D;
	import com.cutecoma.playground.events.GroundEvent;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class WorldEditor extends Sprite
	{
		public var areaEditor:AreaEditor;

		private var engine3D:Engine3D;
		private var area:Area;

		public function WorldEditor(engine3D:Engine3D, area:Area)
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
		
		public function activate():void
		{
			_isActivate = true;

			if (!areaEditor)
			{
				areaEditor = new AreaEditor(engine3D, area);
				//addChild(areaEditor);
				area.map.visible = engine3D.grid = area.ground.debug = engine3D.axis = true;
			}
		}
		
		public function deactivate():void
		{
			_isActivate = false;

			if (areaEditor)
			{
				area.map.visible = engine3D.grid = area.ground.debug = engine3D.axis = false;
				//removeChild(areaEditor);
				areaEditor.destroy();
				areaEditor = null;
			}
		}
	}
}
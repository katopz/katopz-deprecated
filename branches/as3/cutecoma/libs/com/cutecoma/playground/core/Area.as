package com.cutecoma.playground.core
{
	import away3dlite.core.base.Face;
	import away3dlite.events.MouseEvent3D;
	import away3dlite.materials.ColorMaterial;
	
	import com.cutecoma.game.core.BackGround;
	import com.cutecoma.game.core.IEngine3D;
	import com.cutecoma.playground.data.AreaData;
	import com.sleepydesign.display.SDSprite;
	
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeMappedSignal;
	
	public class Area extends SDSprite
	{
		public var background:BackGround;
		public var map:Map;
		public var ground:Ground;

		private var _data:AreaData;
		
		//event
		public var mouseSignal:Signal = new Signal(MouseEvent3D);

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
			//map.update(areaData);
			
			// Ground
			ground = new Ground(engine3D);
			//ground.update(map.data);
		
			update(areaData);
			
			// plug event to engine
			engine3D.scene3D.addEventListener(MouseEvent3D.MOUSE_DOWN, onSceneMouseDown);
		}
		
		private function onSceneMouseDown(event:MouseEvent3D):void
		{
			//var _face:Face = event.face;
			//_face.material = new ColorMaterial(int(Math.random() * 0xFF0000));
			mouseSignal.dispatch(event);
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
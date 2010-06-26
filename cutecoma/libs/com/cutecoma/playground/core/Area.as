package com.cutecoma.playground.core
{
	import away3dlite.cameras.Camera3D;
	import away3dlite.core.base.Face;

	import com.cutecoma.game.core.BackGround;
	import com.cutecoma.game.core.IEngine3D;
	import com.cutecoma.playground.data.AreaData;
	import com.cutecoma.playground.data.CameraData;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.system.DebugUtil;

	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class Area extends SDSprite
	{
		private var _engine3D:IEngine3D;

		public var background:BackGround;
		public var map:Map;
		public var ground:Ground;

		private var _path:String = "";

		private var _data:AreaData;

		public function get data():AreaData
		{
			return _data;
		}

		public function Area(engine3D:IEngine3D, areaData:AreaData, path:String = "")
		{
			_engine3D = engine3D;
			_path = path;

			// to stage
			_engine3D.contentLayer.addChild(this);

			// background
			background = new BackGround();
			background.path = path;
			addChild(background);

			//map
			addChild(map = new Map);

			// Ground
			ground = new Ground(_engine3D);
			ground.mouseSignal.add(onGroundClick);

			update(areaData);
		}

		protected function onGroundClick(event:MouseEvent, position:Vector3D, face:Face, point:Point):void
		{
			//DebugUtil.trace("TODO : bind to player : " + position, face, point);
		}

		public function updateBitmap(bitmapData:BitmapData):void
		{
			map.updateBitmapData(bitmapData);
			ground.updateBitmapData(bitmapData);
		}

		public function update(areaData:AreaData):void
		{
			if (_data == areaData)
				return;

			_data = areaData;

			background.update(areaData);

			map.update(areaData);
			ground.updateBitmapData(map.data.bitmapData);

			var _camera:Camera3D = _engine3D.view3D.camera;
			var _cameraData:CameraData = areaData.viewData.cameraData;

			_engine3D.view3D.camera.zoom = _cameraData.zoom;
			_engine3D.view3D.camera.focus = _cameraData.focus;

			_camera.x = _cameraData.x;
			_camera.y = _cameraData.y;
			_camera.z = _cameraData.z;

			_camera.rotationX = _cameraData.rotationX;
			_camera.rotationY = _cameraData.rotationY;
			_camera.rotationZ = _cameraData.rotationZ;
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
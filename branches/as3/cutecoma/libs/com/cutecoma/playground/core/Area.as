package com.cutecoma.playground.core
{
	import away3dlite.cameras.Camera3D;
	
	import com.cutecoma.game.core.Background;
	import com.cutecoma.game.core.Foreground;
	import com.cutecoma.game.core.IEngine3D;
	import com.cutecoma.playground.data.AreaData;
	import com.cutecoma.playground.data.CameraData;
	import com.sleepydesign.display.SDSprite;
	
	import flash.display.BitmapData;
	
	import org.osflash.signals.Signal;

	/**
	 *
	 * + [Area]
	 * 	- Foreground
	 *  - Map
	 * 	- Ground
	 * 	- Background
	 *
	 * @author katopz
	 *
	 */
	public class Area extends SDSprite
	{
		private var _engine3D:IEngine3D;

		private var _foreground:Foreground;

		public function get foreground():Foreground
		{
			return _foreground;
		}

		private var _background:Background;

		public function get background():Background
		{
			return _background;
		}

		private var _map:Map;

		public function get map():Map
		{
			return _map;
		}

		private var _ground:Ground;

		public function get ground():Ground
		{
			return _ground;
		}

		private var _path:String = "";

		private var _data:AreaData;

		public function get data():AreaData
		{
			return _data;
		}

		public var completeSignal:Signal = new Signal();

		public function Area(engine3D:IEngine3D, path:String = "", isEditable:Boolean = false)
		{
			_engine3D = engine3D;
			_path = path;

			// to stage
			_engine3D.contentLayer.addChild(this);

			// background
			_background = new Background();
			_background.path = path;
			addChild(_background);

			//map
			addChild(_map = new Map);

			// Ground
			_ground = new Ground(_engine3D);
			//ground.mouseSignal.add(onGroundClick);

			//update(areaData);
			addChild(_foreground = new Foreground());
		}

		public function updateBitmap(bitmapData:BitmapData):void
		{
			_map.updateBitmapData(bitmapData);
			_ground.updateBitmapData(bitmapData);
		}

		public function update(areaData:AreaData):void
		{
			if (_data == areaData)
				return;

			_data = areaData;

			_background.update(areaData);

			_map.update(areaData);
			_ground.updateBitmapData(_map.data.bitmapData);

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

			completeSignal.dispatch();
		}

		override public function destroy():void
		{
			// signals
			completeSignal.removeAll();

			// destroy
			_background.destroy();
			_foreground.destroy();
			_map.destroy();
			_ground.destroy();

			_background = null;
			_foreground = null;
			_map = null;
			_ground = null;

			_data = null;

			super.destroy();
		}
	}
}
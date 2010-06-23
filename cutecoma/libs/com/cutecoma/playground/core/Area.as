package com.cutecoma.playground.core
{
	import away3dlite.cameras.Camera3D;
	import away3dlite.events.MouseEvent3D;
	
	import com.cutecoma.game.core.BackGround;
	import com.cutecoma.game.core.IEngine3D;
	import com.cutecoma.playground.data.AreaData;
	import com.cutecoma.playground.data.CameraData;
	import com.sleepydesign.display.SDSprite;
	import com.sleepydesign.system.DebugUtil;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;

	public class Area extends SDSprite
	{
		private var _engine3D:IEngine3D;

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
			_engine3D = engine3D;
			
			// to stage
			_engine3D.contentLayer.addChild(this);

			// background
			background = new BackGround(areaData.background);
			addChild(background);

			//map
			addChild(map = new Map);
			//map.update(areaData);

			// Ground
			ground = new Ground(_engine3D);
			_engine3D.view3D.addChild(ground.plane.layer = new SDSprite);
			ground.plane.layer.addEventListener(MouseEvent.CLICK, onGroundClick);
				
			//ground.update(map.data);

			update(areaData);

			// TODO : remove this to area editor
			// plug event to engine
			_engine3D.view3D.mouseZeroMove = true;
			_engine3D.view3D.addEventListener(MouseEvent3D.MOUSE_DOWN, onSceneMouse);
			_engine3D.view3D.addEventListener(MouseEvent3D.MOUSE_MOVE, onSceneMouse);
			_engine3D.view3D.addEventListener(MouseEvent3D.MOUSE_UP, onSceneMouse);
		}
		
		private function onGroundClick(event:MouseEvent):void
		{
			DebugUtil.trace(event);
			
			var layer:SDSprite = event.target as SDSprite;
			/*
			var _startMousePos:Vector3D = currDragBody.getTransform().position.clone();
			
			var _matrix3D:Matrix3D = ground.getTransform();
			var _normal:Vector3D = _matrix3D.deltaTransformVector(Vector3D.Y_AXIS);
			
			var planeToDragOn:Vector3D = JMath3D.fromNormalAndPoint(_normal, new Vector3D(0, 0, -_startMousePos.z));
			
			var p:Vector3D = currDragBody.currentState.position;
			var bodyPoint:Vector3D = _startMousePos.subtract(p);
			
			dragConstraint = new JConstraintWorldPoint(currDragBody, bodyPoint, _startMousePos);
			*/
		}
		
		private var _isDrag:Boolean;

		private function onSceneMouse(event:MouseEvent3D):void
		{
			switch (event.type)
			{
				case MouseEvent3D.MOUSE_DOWN:
					//var _face:Face = event.face;
					//_face.material = new ColorMaterial(int(Math.random() * 0xFF0000));
					_isDrag = true;
					//_engine3D.scene3D.addEventListener(MouseEvent3D.MOUSE_MOVE, onSceneMouse);
					//_engine3D.scene3D.addEventListener(MouseEvent3D.MOUSE_UP, onSceneMouse);
					//_engine3D.scene3D.addEventListener(MouseEvent3D.MOUSE_OUT, onSceneMouse);
					break;
				//case MouseEvent3D.MOUSE_OUT:
				//	trace("MOUSE_OUT");
				case MouseEvent3D.MOUSE_UP:
					_isDrag = false;
					//_engine3D.scene3D.removeEventListener(MouseEvent3D.MOUSE_MOVE, onSceneMouse);
					//_engine3D.scene3D.removeEventListener(MouseEvent3D.MOUSE_UP, onSceneMouse);
					//_engine3D.scene3D.removeEventListener(MouseEvent3D.MOUSE_OUT, onSceneMouse);
					break;
				case MouseEvent3D.MOUSE_MOVE:
					if (_isDrag)
						mouseSignal.dispatch(event);
					break;
			}
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
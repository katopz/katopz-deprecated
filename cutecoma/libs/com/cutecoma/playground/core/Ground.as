package com.cutecoma.playground.core
{
	import away3dlite.cameras.Camera3D;
	import away3dlite.containers.View3D;
	import away3dlite.core.IDestroyable;
	import away3dlite.core.base.Face;
	import away3dlite.core.math.Plane3D;
	import away3dlite.materials.ColorMaterial;
	import away3dlite.materials.QuadWireframeMaterial;
	import away3dlite.primitives.Cube6;
	import away3dlite.primitives.Plane;
	
	import com.cutecoma.game.core.IEngine3D;
	import com.sleepydesign.system.DebugUtil;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import org.osflash.signals.Signal;

	/**
	 *
	 * Ground : Can be click and dispatch x,z position
	 *
	 * @author katopz
	 *
	 */
	public class Ground implements IDestroyable
	{
		// VIEW
		private var _engine3D:IEngine3D;
		private var _plane:Plane;

		public function get plane():Plane
		{
			return _plane;
		}

		private var _box:Cube6;

		public function get box():Cube6
		{
			return _box;
		}

		private var _isEditable:Boolean;

		public function get isEditable():Boolean
		{
			return _isEditable;
		}

		public function set isEditable(value:Boolean):void
		{
			_plane.visible = _isEditable = value;
		}
		
		public function Ground(engine3D:IEngine3D, isEditable:Boolean = false)
		{
			_engine3D = engine3D;
			_isEditable = isEditable;

			// debug box
			if(isEditable)
			{
				_engine3D.scene3D.addChild(_box = new Cube6(new QuadWireframeMaterial(0xFFFFFF, .75, 5), 100, 200, 100));
				_box.y = -_box.height * .5;
			}

			_engine3D.view3D.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			_engine3D.view3D.stage.addEventListener(MouseEvent.MOUSE_UP, onMouse);
			_engine3D.view3D.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouse);
		}

		//____________________________________________________________ MOUSE

		private function onMouse(event:MouseEvent):void
		{
			if (!_plane)
				return;
			
			var view:View3D = _engine3D.view3D;
			var camera:Camera3D = _engine3D.view3D.camera;

			// get position from plane
			var _normal:Vector3D = _plane.transform.matrix3D.deltaTransformVector(Vector3D.Y_AXIS);
			var _plane3D:Vector3D = Plane3D.fromNormalAndPoint(_normal, new Vector3D());
			var _ray:Vector3D = camera.lens.unProject(view.mouseX, view.mouseY, camera.screenMatrix3D.position.z);
			_ray = camera.transform.matrix3D.transformVector(_ray);

			// set target position
			var _target:Vector3D = Plane3D.getIntersectionLine(_plane3D, camera.position, _ray);

			// get face index by x,z position, simulate real face click
			var _faceIndex:int = getFaceIndexHit(_target.x, _target.z, _plane.width, _plane.height, _plane.segmentsW, _plane.segmentsH);

			// apply face material if face hit
			var _face:Face;
			var _point:Point;
			if (_faceIndex == -1)
				return;

			_face = _plane.faces[_faceIndex];
			_point = getPointFromIndex(_faceIndex, _plane.segmentsW);

			switch (event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					_isDrag = true;
					if (_faceIndex != -1)
						mouseSignal.dispatch(event, _target, _face, _point);
					break;
				case MouseEvent.MOUSE_UP:
					_isDrag = false;
					break;
				case MouseEvent.MOUSE_MOVE:
					if (_isDrag)
						mouseSignal.dispatch(event, _target, _face, _point);
					break;
			}
		}

		private var _isDrag:Boolean;

		public var mouseSignal:Signal = new Signal(MouseEvent, Vector3D, Face, Point);

		private function getFaceIndexHit(x:Number, y:Number, width:Number, height:Number, segmentsW:int, segmentsH:int):int
		{
			// hit test
			var _rect:Rectangle = new Rectangle(-width * .5, -height * .5, width, height);
			if (_rect.contains(x, y))
			{
				// get col, row and return as index
				var _point:Point = new Point(int(segmentsW * (x / width + .5)), int(segmentsH * (y / height + .5)));
				return _point.y * segmentsW + _point.x;
			}
			else
			{
				return -1;
			}
		}

		private function getPointFromIndex(index:int, size:uint):Point
		{
			return new Point(int(index % size), int(index / size));
		}

		//____________________________________________________________ UPDATE

		public function updateBitmapData(bitmapData:BitmapData):void
		{
			var w:uint = bitmapData.width;
			var h:uint = bitmapData.height;

			// destroy
			if (_plane)
				_plane.destroy();
			_plane = null;

			// new
			if(_isEditable)
			{
				// plane that can be draw on face
				_engine3D.scene3D.addChild(_plane = new Plane(new ColorMaterial(0xFFFFFF), Map.factorX * w, Map.factorZ * h, w, h));
				_plane.visible = true;
				
				// update size
				_box.width = _plane.width;
				_box.depth = _plane.height;
				_box.visible = true;
				_box.y = -_box.height * .5;
			}else{
				_engine3D.scene3D.addChild(_plane = new Plane(new ColorMaterial(0xFFFFFF), Map.factorX * w, Map.factorZ * h, 1, 1));
				_plane.visible = false;
			}

			

			// update material
			updateMaterial(bitmapData);
		}

		public function updateMaterial(bitmapData:BitmapData):void
		{
			var w:uint = bitmapData.width;
			var h:uint = bitmapData.height;

			var _getPixel:Function = bitmapData.getPixel;
			var _plane_faces:Vector.<Face> = _plane.faces;
			var _size:int = _plane_faces.length;
			for (var k:int = 0; k < _size; k++)
			{
				var i:int = int(k % w);
				var j:int = int(k / w);
				var color:Number = _getPixel(i, int(h - j - 1));
				
				var _face:Face = _plane_faces[k] as Face;
				if(_face && _face.material)
					_face.material.destroy();
				_face.material = new ColorMaterial(color);
			}
		}

		//____________________________________________________________ DESTROY

		/** @private */
		protected var _isDestroyed:Boolean;

		public function get destroyed():Boolean
		{
			return _isDestroyed;
		}

		public function destroy():void
		{
			if (_plane)
				_plane.destroy();
			_plane = null;

			if (_box)
				_box.destroy();
			_box = null;

			_engine3D = null;

			// event
			if (_engine3D.view3D)
			{
				if (_engine3D.view3D.stage)
				{
					_engine3D.view3D.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouse);
					_engine3D.view3D.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouse);
					_engine3D.view3D.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouse);
				}
			}

			// signals
			if (mouseSignal)
				mouseSignal.removeAll();
			mouseSignal = null;

			_isDestroyed = true;
		}
	}
}
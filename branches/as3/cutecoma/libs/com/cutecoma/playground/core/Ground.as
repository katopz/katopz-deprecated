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
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import org.osflash.signals.Signal;

	public class Ground implements IDestroyable
	{
		/** @private */
		protected var _isDestroyed:Boolean;
		
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

		// tile
		private var _debug:Boolean = false;

		public function Ground(engine3D:IEngine3D)
		{
			_engine3D = engine3D;
			
			// dewbug box
			_engine3D.scene3D.addChild(_box = new Cube6(new QuadWireframeMaterial(0xFFFFFF,.75,5),100,200,100));
			_box.visible = false;
			_box.y = -_box.height*.5;
			
		/*
		   
		   plane3D = new Plane3D(new Number3D(0, 1, 0), Number3D.ZERO);

		   if(mouseEnable)
		   engine3D.viewport.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseIsDown);

		   this.debug = debug;
		 */
			_engine3D.view3D.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			_engine3D.view3D.stage.addEventListener(MouseEvent.MOUSE_UP, onMouse);
			_engine3D.view3D.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouse);
		}

		//____________________________________________________________ CLICK

		/*
		private function onMouseIsDown(event:MouseEvent):void
		{
		   //if(!(event.target is Stage))return;
		   var camera:Camera3D = engine3D.camera;
		   var ray:Number3D = Number3D.add(camera.unproject(engine3D.viewport.containerSprite.mouseX, engine3D.viewport.containerSprite.mouseY), camera.position);

		   var cameraVertex3D	:Vertex3D = new Vertex3D(camera.x, camera.y, camera.z);
		   var rayVertex3D		:Vertex3D = new Vertex3D(ray.x, ray.y, ray.z);
		   var intersectPoint	:Vertex3D = plane3D.getIntersectionLine(cameraVertex3D, rayVertex3D);

		   dispatchEvent(new SDMouseEvent(SDMouseEvent.MOUSE_DOWN, {position:Position.parse(intersectPoint)}, event));
		}
		*/
		
		private function onMouse(event:MouseEvent):void
		{
			if(!_plane)
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
			var _point:Point
			if (_faceIndex != -1)
			{
				_face = _plane.faces[_faceIndex];
				_point = getPointFromIndex(_faceIndex, _plane.segmentsW);
			}
			
			switch (event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					_isDrag = true;
					mouseSignal.dispatch(event, _target, _face, _point);
					break;
				case MouseEvent.MOUSE_UP:
					_isDrag = false;
					//mouseSignal.dispatch(event, _target, _face, _point);
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

		public function updateBitmapData(bitmapData:BitmapData):void
		{
			var w:uint = bitmapData.width;
			var h:uint = bitmapData.height;

			// destroy
			if(_plane)
				_plane.destroy();
			_plane = null;
			
			// new
			_engine3D.scene3D.addChild(_plane = new Plane(new ColorMaterial(0xFFFFFF), Map.factorX*w, Map.factorZ*h,w, h));
			
			// update size
			_box.width = _plane.width;
			_box.depth = _plane.height;
			_box.visible = true;
			_box.y = -_box.height*.5;
			
			// update material
			updateMaterial(bitmapData);
		}
		
		public function updateMaterial(bitmapData:BitmapData):void
		{
			var w:uint = bitmapData.width;
			var h:uint = bitmapData.height;
			
			var _getPixel:Function = bitmapData.getPixel;
			for (var k:uint = 0; k < w * h; k++)
			{
				var i:int = int(k % w);
				var j:int = int(k / w);
				var color:Number = _getPixel(i,h-j-1);
				
				_plane.faces[k].material = new ColorMaterial(color);
			}
		}
		
		public function get destroyed():Boolean
		{
			return _isDestroyed;
		}
		
		public function destroy():void
		{
			if(_plane)
				_plane.destroy();
			_plane = null;
			
			if(_box)
				_box.destroy();
			_box = null;
			
			_engine3D = null;
			
			_isDestroyed = true;
		}
	}
}
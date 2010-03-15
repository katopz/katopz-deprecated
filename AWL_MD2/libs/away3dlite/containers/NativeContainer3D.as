package away3dlite.containers
{
	import away3dlite.arcane;
	import away3dlite.cameras.Camera3D;
	import away3dlite.core.base.Object3D;
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	use namespace arcane;

	public class NativeContainer3D extends Object3D
	{
		// target
		public var displayObject:DisplayObject;
		
		private var _transform_matrix3D:Matrix3D;
		
		/** @private */
		arcane override function project(camera:Camera3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			//if(!displayObject.parent && parent)
			//	parent.addChild(displayObject);
			
			/*
			_sceneMatrix3D.rawData = _transform_matrix3D.rawData;
			
			if (parentSceneMatrix3D)
				_sceneMatrix3D.append(parentSceneMatrix3D);
				
			_viewMatrix3D.rawData = _sceneMatrix3D.rawData;
			_viewMatrix3D.append(camera._screenMatrix3D);
			
			_screenZ = _viewMatrix3D.position.z;
			
			//perspective culling
			var persp:Number = camera.zoom / (1 + _screenZ / camera.focus);
			
			if (minPersp != maxPersp && (persp < minPersp || persp >= maxPersp))
				_perspCulling = true;
			else
				_perspCulling = false;
			
			// dirty
			updateDirty(_viewMatrix3D);
			*/
			super.project(camera, parentSceneMatrix3D);
			
			var Utils3D_projectVector:Function = Utils3D.projectVector;
			var _transform_matrix3D:Matrix3D = transform.matrix3D;
			var _position:Vector3D = displayObject.transform.matrix3D.position;
			
			_position = Utils3D_projectVector(_transform_matrix3D, _position);
			_position = Utils3D_projectVector(_viewMatrix3D, _position);
			
			//displayObject.transform.matrix3D = _viewMatrix3D.clone();
		}
		
		/*
		public override function set x(value:Number):void
		{
			super.x = value;
			_transform_matrix3D = transform.matrix3D.clone();
		}
		
		public override function set y(value:Number):void
		{
			super.y = value;
			_transform_matrix3D = transform.matrix3D.clone();
		}
		
		public override function set z(value:Number):void
		{
			super.z = value;
			_transform_matrix3D = transform.matrix3D.clone();
		}
		*/
		
		public function NativeContainer3D(displayObject:DisplayObject)
		{
			super();
			this.displayObject = displayObject;
			addChild(displayObject);
			displayObject.transform.matrix3D = new Matrix3D();
			//_transform_matrix3D = displayObject.transform.matrix3D.clone();
		}
	}
}
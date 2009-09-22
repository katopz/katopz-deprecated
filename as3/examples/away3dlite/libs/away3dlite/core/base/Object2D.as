package away3dlite.core.base
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix3D;
	import flash.geom.Transform;
	import flash.geom.Vector3D;

	use namespace arcane;

	public class Object2D extends Object3D
	{
		// link list
		public var nextParticle:Object2D;
		public var displayObject:DisplayObject;

		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			
			/*
			var __sceneMatrix3D:Matrix3D = transform.matrix3D.clone();
			__sceneMatrix3D.append(_viewMatrix3D);
				
			var __viewMatrix3D:Matrix3D = __sceneMatrix3D.clone();
			__viewMatrix3D.append(projectionMatrix3D);
			*/
			
			//displayObject.x = __sceneMatrix3D.position.x;
			//displayObject.x = _viewMatrix3D.position.x;
			//displayObject.y = _viewMatrix3D.position.y;
			//displayObject.z = _viewMatrix3D.position.z;
			
			// billboard
			rotationX = -parent.rotationX;
			rotationY = -parent.rotationY;
			rotationZ = -parent.rotationZ;
            
            /*
			// position only
			var _viewMatrix3D_position:Vector3D = sceneMatrix3D.position;
			var _position:Vector3D = transform.matrix3D.position;
			
			_position.x = _viewMatrix3D_position.x;
			_position.y = _viewMatrix3D_position.y;
			_position.z = _viewMatrix3D_position.z;
			*/
			
			/*
			sprite.x = this.screen.x;
			sprite.y = this.screen.y;
 
			var scale:Number = camera.focus * camera.zoom / (camera.zoom + screen.z);
			sprite.scaleX = sprite.scaleY = scale;
			*/
		}

		public function Object2D(displayObject:DisplayObject)
		{
			super();
			
			//this.displayObject = displayObject;
			
			if (displayObject)
				this.displayObject = addChild(displayObject);
			
		}
	}
}
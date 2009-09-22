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
			
			// billboard
			rotationY = -parent.rotationY;
            
			// position only
			//var _viewMatrix3D_position:Vector3D = _viewMatrix3D.position;
			//var _position:Vector3D = transform.matrix3D.position;
			
			//_position.x = _viewMatrix3D_position.x;
			//_position.y = _viewMatrix3D_position.y;
			//_position.z = _viewMatrix3D_position.z;
			
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
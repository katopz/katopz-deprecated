package away3dlite.containers
{
	import away3dlite.arcane;
	import away3dlite.core.base.Object3D;
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	use namespace arcane;

	public class Sprite2D extends Object3D
	{
		// link list
		public var nextParticle:Sprite2D;
		public var displayObject:DisplayObject;
		public var lookAtCamera:Boolean;
		
		private var displayObjectMatrix3D:Matrix3D;
		
		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			
			var _position:Vector3D = Utils3D.projectVector(_viewMatrix3D, displayObjectMatrix3D.position);
			_position.decrementBy(_sceneMatrix3D.position);
			
			displayObject.x = _position.x;
			displayObject.y = _position.y;
			displayObject.z = _position.z;
			
			// fake billboard
			rotationX = -parent.rotationX;
			rotationY = -parent.rotationY;
			rotationZ = -parent.rotationZ;
		}
		
		public function Sprite2D(displayObject:DisplayObject)
		{
			super();
			
			if (displayObject)
			{
				this.displayObject = addChild(displayObject);
				displayObject.transform.matrix3D = new Matrix3D();
				displayObjectMatrix3D = displayObject.transform.matrix3D.clone();
			}
			
			this.lookAtCamera = lookAtCamera; 
		}
	}
}
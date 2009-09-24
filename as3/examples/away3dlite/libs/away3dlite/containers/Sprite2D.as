package away3dlite.containers
{
	import away3dlite.arcane;
	import away3dlite.core.base.Object3D;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	use namespace arcane;

	public class Sprite2D extends Object3D
	{
		// target
		public var displayObject:DisplayObject;
		private var displayObjectPosition:Vector3D;
		
		// link list
		public var nextParticle:Sprite2D;
		
		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			// temp position
			var _position:Vector3D = transform.matrix3D.position.clone();
			
			// invert rotation
			var _temp:Shape = new Shape();
			
			_temp.rotationX = parent.rotationX;
			_temp.rotationY = parent.rotationY;
			_temp.rotationZ = parent.rotationZ;
			_temp.transform.matrix3D.invert();
			
			// billboard rotation
			transform.matrix3D = _temp.transform.matrix3D.clone();

			// billboard position
			position = _position.clone();
			
			// camera position
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			
			/* TODO : scale
			_position = Utils3D.projectVector(_viewMatrix3D, displayObjectPosition);
			_position.decrementBy(_sceneMatrix3D.position);
			
			displayObject.transform.matrix3D.position = _position.clone();
			*/
		}
		
		public function Sprite2D(displayObject:DisplayObject)
		{
			super();
			
			if (displayObject)
			{
				this.displayObject = addChild(displayObject);
				displayObject.transform.matrix3D = new Matrix3D();
				displayObjectPosition = displayObject.transform.matrix3D.position;
			}
		}
	}
}
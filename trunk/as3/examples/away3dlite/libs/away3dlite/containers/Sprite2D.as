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
		private var displayObjectMatrix3D:Matrix3D;
		
		// link list
		public var nextParticle:Sprite2D;
		
		// temp
		private var _position:Vector3D;
		private var _temp:Shape = new Shape();
		
		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			// temp position
			_position = new Vector3D(x, y, z);
			
			// temp rotation
			_temp.rotationX = parent.rotationX;
			_temp.rotationY = parent.rotationY;
			_temp.rotationZ = parent.rotationZ;
			
			// billboard rotation
			transform.matrix3D = _temp.transform.matrix3D.clone();
			transform.matrix3D.invert();
		
			// billboard position
			x = _position.x;
			y = _position.y;
			z = _position.z;
			
			// camera position
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			
			_position = Utils3D.projectVector(_viewMatrix3D, displayObjectMatrix3D.position);
			_position.decrementBy(_sceneMatrix3D.position);
			
			displayObject.x = _position.x;
			displayObject.y = _position.y;
			displayObject.z = _position.z;
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
		}
	}
}
package away3dlite.core.base
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	use namespace arcane;

	public class Particle extends Object3D
	{
		// link list
		public var nextParticle:Particle;
		public var clip:DisplayObject;

		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			
			// billboard
			clip.rotationY = -parent.rotationY;
			
			// position only
			var _viewMatrix3D_position:Vector3D = _viewMatrix3D.position;
			var _position:Vector3D = transform.matrix3D.position;
			
			_position.x = _viewMatrix3D_position.x;
			_position.y = _viewMatrix3D_position.y;
			_position.z = _viewMatrix3D_position.z;
		}

		public function Particle(clip:DisplayObject)
		{
			super();

			if (clip)
				this.clip = addChild(clip);
		}
	}
}
package away3dlite.core.base
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	
	import flash.display.Sprite;
	import flash.geom.Matrix3D;

	use namespace arcane;

	public class Particle extends Object3D
	{
		// link list
		public var nextParticle:Particle;
		public var clip:Sprite;

		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			
			// billboard
			clip.rotationY = -parent.rotationY;
			
			// position
			transform.matrix3D.position.x = _viewMatrix3D.position.x;
			transform.matrix3D.position.y = _viewMatrix3D.position.y;
			transform.matrix3D.position.z = _viewMatrix3D.position.z;
		}

		public function Particle(clip:Sprite)
		{
			super();

			if (clip)
				this.clip = addChild(clip) as Sprite;
		}
	}
}
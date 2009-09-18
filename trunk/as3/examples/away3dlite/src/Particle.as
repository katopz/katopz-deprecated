package away3dlite.core.base
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	
	use namespace arcane;
	
	public class Particle extends Object3D
	{
		// link list
		public var next: Particle;
		
		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			Utils3D.projectVector(_viewMatrix3D, transform.matrix3D);
		}
	}
}
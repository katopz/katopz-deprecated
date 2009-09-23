package away3dlite.core.base
{
	import away3dlite.arcane;
	import away3dlite.containers.*;
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix3D;
	import flash.geom.Transform;
	import flash.geom.Vector3D;

	use namespace arcane;

	public class Particle extends ObjectContainer3D
	{
		// link list
		public var nextParticle:Particle;
		public var displayObject:DisplayObject;

		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			
			var child:Object3D;
			
			for each (child in _children)
				child.project(projectionMatrix3D, _sceneMatrix3D);
		}
		
	    /**
	     * Creates a new <code>ObjectContainer3D</code> object.
	     * 
	     * @param	...childArray		An array of 3d objects to be added as children of the container on instatiation. Can contain an initialisation object
	     */
		public function Particle(...childArray)
		{
			super(childArray);
		}
	}
}
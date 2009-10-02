package away3dlite.containers
{
	import away3dlite.arcane;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.base.Particle;
	
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	use namespace arcane;
	
	/**
	 * Particles
	 * @author katopz
	 */
	public class Particles extends Object3D
	{
		// linklist
		private var firstParticle:Particle;
		private var lastParticle:Particle;
		
		public var lists:Array;
		
		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			
			// bypass
			var Utils3D_projectVector:Function = Utils3D.projectVector;
			var _transform_matrix3D:Matrix3D = transform.matrix3D;
			var _position:Vector3D;
			
			var particle:Particle = firstParticle;
			
			do{
				_position = Utils3D_projectVector(_transform_matrix3D, particle);
				particle.position = Utils3D_projectVector(_viewMatrix3D, _position);
			}while(particle = particle.next)
		}

		public function addParticle(particle:Particle):Particle
		{
			// add to lists
			if(!lists)
				lists = [];
			
			lists.push(particle);
			
			//link list
			if(!firstParticle)
				firstParticle = particle;
			
			if(lastParticle)
				lastParticle.next = particle;
			
			lastParticle = particle;

			return particle;
		}
		
		public function Particles()
		{
			
		}
	}
}
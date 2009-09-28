package away3dlite.containers
{
	import away3dlite.arcane;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.base.Particle;
	
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	use namespace arcane;

	public class Particles extends Object3D
	{
		private var _view:View3D;
		private var _zoom:Number;
		private var _focus:Number;
		
		//linklist
		private var firstParticle:Particle;
		private var lastParticle:Particle;
		
		public var lists:Vector.<Particle>;

		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			
			var particle:Particle = firstParticle;
			if(particle)
			do
			{
				particle.render(parentSceneMatrix3D, _screenZ, _zoom , _focus);
				particle = particle.next;
			}while(particle)
		}

		public function addParticle(particle:Particle):Particle
		{
			// add to lists
			if(!lists)
				lists = new Vector.<Particle>();
			
			lists.fixed = false;
			lists.push(particle);
			lists.fixed = true;
			
			//link list
			if(!firstParticle)
				firstParticle = particle;
			
			if(lastParticle)
				lastParticle.next = particle;
			
			lastParticle = particle;
			
			return particle;
		}
		
		public function Particles(view:View3D)
		{
			super();
			
			// TODO: update when dirty
			_view = view;
			_zoom = view.camera.zoom;
			_focus = view.camera.focus;
		}
	}
}
package away3dlite.containers
{
	import away3dlite.arcane;
	import away3dlite.cameras.Camera3D;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.base.Particle;
	
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	use namespace arcane;

	public class Particles extends Object3D
	{
		private var _view:View3D;
		
		//linklist
		public var firstParticle:Particle;
		public var lastParticle:Particle;
		
		/** @private */
		arcane var _vertices:Vector.<Number>;
		/** @private */
		arcane var _uvtData:Vector.<Number>;
		
		public var vertices:Vector.<Number>;
		
		private var _screenVertices:Vector.<Number>;
		
		public var lists:Array;
		
		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			
			var _position:Vector3D;
			var Utils3D_projectVector:Function = Utils3D.projectVector;
			var particle:Particle = firstParticle;
			var _zoom:Number = _view.camera.zoom;
			var _focus:Number = _view.camera.focus;
			var _transform_matrix3D:Matrix3D = transform.matrix3D;
			do
			{
				_position = Utils3D_projectVector(_transform_matrix3D, particle);
				_position = Utils3D_projectVector(_viewMatrix3D, _position);
				particle.render(_position, _zoom , _focus);
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
		
		public function Particles(view:View3D)
		{
			super();
			
			// TODO: update when dirty?
			_view = view;
		}
	}
}
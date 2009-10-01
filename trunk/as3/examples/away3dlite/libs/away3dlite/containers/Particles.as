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
		//public var firstParticle:Particle;
		//public var lastParticle:Particle;
		
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
			/*
			Utils3D.projectVectors(_viewMatrix3D, _vertices, _screenVertices, _uvtData);
			
			for each (var particle:Particle in lists)
			{
				var _position:Vector3D = Utils3D.projectVector(_viewMatrix3D, particle.original);
				particle.render(_position, int((_uvtData[particle.index*3+2])*1000000), _zoom , _focus);
			}
			*/
			
			Utils3D.projectVectors(_viewMatrix3D, _vertices, _screenVertices, _uvtData);
			
			var i:int = 0;
			for each (var particle:Particle in lists)
			{
				//var _position:Vector3D = Utils3D.projectVector(_viewMatrix3D, particle.original);
				particle.render
				(
					new Vector3D(_screenVertices[int(i++)], _screenVertices[int(i++)], particle.z),
					int((_uvtData[particle.index*3+2])*1000000), _zoom, _focus
				);
			}
			
			// sort
			//lists.sortOn("z", 18);
		}

		public function addParticle(particle:Particle):Particle
		{
			// add to lists
			if(!lists)
				lists = [];
			
			lists.push(particle);
			
			//link list
			/*
			if(!firstParticle)
				firstParticle = particle;
			
			if(lastParticle)
				lastParticle.next = particle;
			
			lastParticle = particle;
			*/
			
			// add position for project
			_vertices.fixed = false;
			_vertices.push(particle.x, particle.y, particle.z);
			_vertices.fixed = true;
			
			_uvtData.fixed = false;
			_uvtData.push(0, 0, 0);
			_uvtData.fixed = true;
			
			return particle;
		}
		
		public function Particles(view:View3D)
		{
			super();
			
			// TODO: update when dirty
			_view = view;
			_zoom = view.camera.zoom;
			_focus = view.camera.focus;
			
			_vertices = vertices = new Vector.<Number>();
			_uvtData = new Vector.<Number>();
			
			_screenVertices = new Vector.<Number>();
		}
	}
}
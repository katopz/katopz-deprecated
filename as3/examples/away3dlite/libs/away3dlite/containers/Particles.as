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
		
		public var vertices:Vector.<Number>;
		
		/** @private */
		arcane var _vertices:Vector.<Number>;
		/** @private */
		arcane var _uvtData:Vector.<Number>;
		
		private var _screenVertices:Vector.<Number>;
		
		public var lists:Vector.<Particle>;

		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			
			Utils3D.projectVectors(_viewMatrix3D, _vertices, _screenVertices, _uvtData);
			
			var i:int = 0;
			//for each (var particle:Particle in lists)
			var particle:Particle = firstParticle;
			if(particle)
			do
			{
				//particle.project(projectionMatrix3D, _sceneMatrix3D);
				particle = particle.render(_screenVertices[int(i++)], _screenVertices[int(i++)], _zoom / (1 + (_screenZ+particle.z) / _focus));
				//particle.scaleX = particle.scaleY = _movieClipSprite.scaling*zoom / (1 + _screenZ / focus);
				//var _screenZ:Number = _vertices[i];
				//particle.scaleX = particle.scaleY = _zoom / (1 + _screenZ / _focus);
				//i+=2;
				//particle.screenX = _screenVertices[i++];
				//particle.screenY = _screenVertices[i++];
				/*
				particle.width = particle.bitmapData.width; 
				particle.height = particle.bitmapData.height; 
				*/
				//particle = particle.next;
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
			
			// add position for project
			_vertices.fixed = false;
			_vertices.push(particle.x, particle.y, particle.z);
			_vertices.fixed = true;
			
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
			
			_vertices = vertices = new Vector.<Number>();
			_uvtData = new Vector.<Number>();
			
			_screenVertices = new Vector.<Number>();
		}
	}
}
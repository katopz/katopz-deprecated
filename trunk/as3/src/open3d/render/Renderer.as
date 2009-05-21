package open3d.render
{
	import __AS3__.vec.Vector;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	
	import open3d.objects.Mesh;
	import open3d.objects.Object3D;

	public class Renderer
	{
		private var canvas:Sprite;
		public var view:Shape;

		public var pProjection:PerspectiveProjection = new PerspectiveProjection();
		public var projectionMatrix3D:Matrix3D = pProjection.toMatrix3D();

		public var totalFace:int = 0;
		public var totalMesh:int = 0;
		
		public var world:Object3D = new Object3D();
		private var worldMatrix3D:Matrix3D = world.transform.matrix3D;

		private var _faces:Array;
		public function get faces():Array
		{
			return _faces;
		}

		private var _meshes:Vector.<Mesh>;
		public function get meshes():Vector.<Mesh>
		{
			return _meshes;
		}
				
		private var _isFaceZSort:Boolean;
		public function set isFaceZSort(value:Boolean):void
		{
			_isFaceZSort = value;
			for each (var mesh:Mesh in _meshes)
			{
				mesh.isFaceZSort = value;
			}
		}
		public function get isFaceZSort():Boolean
		{
			return _isFaceZSort;
		}
		
		private var _isMeshZSort:Boolean;
		public function set isMeshZSort(value:Boolean):void
		{
			_isMeshZSort = value;
		}
		public function get isMeshZSort():Boolean
		{
			return _isMeshZSort;
		}
		
		public function Renderer(canvas:Sprite)
		{
			this.canvas = canvas;

			view = new Shape();
			view.x = canvas.stage.stageWidth / 2;
			view.y = canvas.stage.stageHeight / 2;
			canvas.addChild(view);

			_meshes = new Vector.<Mesh>();
			
			isMeshZSort = true;
			isFaceZSort = true;
		}

		public function addChild(mesh:Mesh):void
		{
			_meshes.push(mesh);
			totalMesh++;
		}

		public function render():void
		{
			// dispose
			totalFace = 0;
			var _view_graphics:Graphics = view.graphics;
			_view_graphics.clear();
			
			var mesh:Mesh;
			for each (mesh in _meshes)
				mesh.updateTransform(projectionMatrix3D, worldMatrix3D);
				
			// z-sort mesh
			if(_isMeshZSort)
				_meshes.sort(zSort);
			
			// draw
			for each (mesh in _meshes)
			{
				_view_graphics.drawGraphicsData(mesh.graphicsData);
				totalFace+=mesh.totalFace;
			}
		}
		
		private function zSort(a:Mesh, b:Mesh):int
		{
			if (a.z > b.z)
				return 1;
			else if (a.z < b.z)
				return -1;
			return 0;
		}
	}
}
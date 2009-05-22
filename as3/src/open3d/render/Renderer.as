package open3d.render
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import open3d.objects.Mesh;
	import open3d.objects.Object3D;

	public class Renderer
	{
		private var canvas:Sprite;
		private var _view:Shape;
		public function get view():Shape
		{
			return _view;
		}

		private var projection:PerspectiveProjection;
		private var projectionMatrix3D:Matrix3D;

		public var totalFace:int = 0;
		public var totalMesh:int = 0;
		
		public var world:Object3D;
		private var worldMatrix3D:Matrix3D;

		private var _faces:Array;
		public function get faces():Array
		{
			return _faces;
		}

		private var _meshes:Array;
		public function get meshes():Array
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

			_view = new Shape();
			_view.x = canvas.stage.stageWidth / 2;
			_view.y = canvas.stage.stageHeight / 2;
			canvas.addChild(_view);
			
			projection = new PerspectiveProjection();
			projectionMatrix3D = projection.toMatrix3D();
			projection.projectionCenter = new Point(canvas.stage.stageWidth / 2,  canvas.stage.stageHeight / 2);
			
			world = new Object3D();
			worldMatrix3D = world.transform.matrix3D;
			
			_meshes = [];
			
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
			var _view_graphics:Graphics = _view.graphics;
			_view_graphics.clear();
			
			var mesh:Mesh;
			for each (mesh in _meshes)
				mesh.updateTransform(projectionMatrix3D, worldMatrix3D);
			
			// z-sort mesh
			if(_isMeshZSort)
				_meshes.sortOn("screenZ", 16);
			
			// draw
			for each (mesh in _meshes)
			{
				_view_graphics.drawGraphicsData(mesh.graphicsData);
				totalFace+=mesh.totalFace;
			}
		}
	}
}
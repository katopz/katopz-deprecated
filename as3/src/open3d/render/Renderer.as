package open3d.render
{
	import __AS3__.vec.Vector;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	
	import open3d.objects.Camera3D;
	import open3d.objects.Mesh;

	public class Renderer extends EventDispatcher
	{
		private var canvas:Sprite;
		public var view:Shape;

		private var projection:Matrix3D = (new PerspectiveProjection()).toMatrix3D();

		public var totalFace:int = 0;
		public var totalMesh:int = 0;

		private var _camera:Camera3D;
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
		
		public function get camera():Camera3D
		{
			return _camera;
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

			_camera = new Camera3D();

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
			
			// transfrom
			var cameraMatrix3D:Matrix3D = _camera.transform.matrix3D;
			var mesh:Mesh;
			for each (mesh in _meshes)
				mesh.updateTransform(projection, cameraMatrix3D);
				
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
		
		private function zSort(a:Mesh, b:Mesh):Number
		{
			if (a.z > b.z)
				return 1;
			else if (a.z < b.z)
				return -1;
			return 0;
		}
	}
}
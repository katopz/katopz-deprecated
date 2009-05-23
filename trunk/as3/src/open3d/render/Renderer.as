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
	
	/**
	 * Renderer
	 * 
	 * The default PerspectiveProjection object created on the root has the following values:
	 * 	• fieldOfView: 55 (but 53 it's look more precise 1:1 pixel)
	 * 	• perspectiveCenter: stagewidth/2, stageHeight/2
	 * 	• focalLength: stageWidth/ 2 * ( cos(fieldOfView/2) / sin(fieldOfView/2) )
	 * 
	 * @author katopz
	 */
	public class Renderer
	{
		public var totalFaces:int=0;
		
		private var canvas:Sprite;
		private var _view:Shape;
		public function get view():Shape
		{
			return _view;
		}

		private var projection:PerspectiveProjection;
		private var projectionMatrix3D:Matrix3D;

		public var world:Object3D;
		private var worldMatrix3D:Matrix3D;
		
		private var _childs:Array;
		public function get meshes():Array
		{
			return _childs;
		}
		
		public function get numChildren():int
		{
			return _childs.length;
		}
		
		private var _isFaceZSort:Boolean;
		public function set isFaceZSort(value:Boolean):void
		{
			_isFaceZSort = value;
			for each (var mesh:Mesh in _childs)
				mesh.isFaceZSort = value;
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
			projection.fieldOfView = 53;
			projection.projectionCenter = new Point(canvas.stage.stageWidth / 2,  canvas.stage.stageHeight / 2);
			projectionMatrix3D = projection.toMatrix3D();
			
			world = new Object3D();
			worldMatrix3D = world.transform.matrix3D;
			
			_childs = [];
			
			isMeshZSort = true;
			isFaceZSort = true;
		}

		public function addChild(object3D:Object3D):void
		{
			_childs.push(object3D);
		}
		
		public function removeChild(object3D:Object3D):void
		{
			_childs.splice(_childs.indexOf(object3D), 1);
		}
		
		public function render():void
		{
			// dispose
			totalFaces = 0;
			
			var _view_graphics:Graphics = _view.graphics;
			_view_graphics.clear();
			
			// TODO : traverse
			var child:Object3D;
			for each (child in _childs)
				child.project(projectionMatrix3D, worldMatrix3D);
			
			// z-sort mesh
			if(_isMeshZSort)
				_childs.sortOn("screenZ", 18);
			
			// draw
			for each (child in _childs)
			{
				_view_graphics.drawGraphicsData(child.graphicsData);
				
				if(child is Mesh)
					totalFaces+=Mesh(child).numFaces;
			}
		}
	}
}
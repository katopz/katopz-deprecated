package open3d.render
{
	import flash.display.*;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import open3d.objects.Mesh;
	import open3d.objects.Object3D;
	
	/**
	 * Renderer
	 * 
	 * The default PerspectiveProjection object created on the root has the following values:
	 * 	• fieldOfView: 55 (but 53 it's look more precise)
	 * 	• perspectiveCenter: stagewidth/2, stageHeight/2
	 * 	• focalLength: stageWidth/ 2 * ( cos(fieldOfView/2) / sin(fieldOfView/2) )
	 * 
	 * @author katopz
	 */
	public class Renderer
	{
		public var totalFaces:int=0;
		
		private var canvas:Sprite;
		
		// public var faster than get/set view
		public var view:Shape;
		private var _view:Shape;
		
		public var projection:PerspectiveProjection;
		private var _projection:PerspectiveProjection;
		private var _projectionMatrix3D:Matrix3D;

		public var world:Object3D;
		private var _worldMatrix3D:Matrix3D;
		
		// still need Array for sortOn(faster than Vector sort)
		private var _childs:Array;
		public function get childs():Array
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
			
			view = _view = new Shape();
			_view.x = canvas.stage.stageWidth / 2;
			_view.y = canvas.stage.stageHeight / 2;
			canvas.addChild(_view);
			
			projection = _projection = new PerspectiveProjection();
			_projection.fieldOfView = 53;
			_projection.projectionCenter = new Point(canvas.stage.stageWidth / 2,  canvas.stage.stageHeight / 2);
			_projectionMatrix3D = _projection.toMatrix3D();
			
			world = new Object3D();
			_worldMatrix3D = world.transform.matrix3D;
			
			_childs = [];
			
			isMeshZSort = true;
			isFaceZSort = true;
		}
		
		public function addChild(object3D:Object3D):void
		{
			if(!object3D)return;
			_childs.push(object3D);
			
			canvas.addChild(object3D);
		}
		
		public function removeChild(object3D:Object3D):void
		{
			if(!object3D)return;
			_childs.splice(_childs.indexOf(object3D), 1);
		}
		
		public function render():void
		{
			// dispose
			totalFaces = 0;
			
			var _view_graphics:Graphics = _view.graphics;
			_view_graphics.clear();
			
			// project children
			var child:Object3D;
			for each (child in _childs)
				child.project(_projectionMatrix3D, _worldMatrix3D);
			
			// z-sort Object3D
			if(_isMeshZSort)
				_childs.sortOn("screenZ", 18);
			
			// draw
			for each (child in _childs)
			{
				_view_graphics.drawGraphicsData(child.graphicsData);
				
				// count total faces in Mesh
				if(child is Mesh)
					totalFaces+=Mesh(child).numFaces;
			}
			
			/*
			
			// shoulde be faster draw which this way?
			var _drawGraphicsData:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
			for each (child in _childs)
			{
				for each (var graphicsData:IGraphicsData in child.graphicsData)
				{
					_drawGraphicsData.push(graphicsData);
				}
				
				// count total faces in Mesh
				if(child is Mesh)
					totalFaces+=Mesh(child).numFaces;
			}
			
			_view_graphics.drawGraphicsData(_drawGraphicsData);
			
			*/
		}
	}
}
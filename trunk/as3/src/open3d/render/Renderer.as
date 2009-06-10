package open3d.render
{
	import flash.display.*;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import open3d.materials.BitmapMaterial;
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
		public var totalFaces:int = 0;

		private var canvas:Sprite;

		// public var faster than get/set view
		public var view:Sprite;
		private var _view:Sprite;
		
		public var projection:PerspectiveProjection;
		private var _projection:PerspectiveProjection;
		private var _projectionMatrix3D:Matrix3D;

		public var world:Object3D;
		private var _worldMatrix3D:Matrix3D;

		// still need Array for sortOn(faster than Vector sort)
		public var childs:Array;
		private var _childs:Array;

		public function get numChildren():int
		{
			return _childs.length;
		}

		private var _isFaceDebug:Boolean;

		public function set isFaceDebug(value:Boolean):void
		{
			_isFaceDebug = value;
		}

		public function get isFaceDebug():Boolean
		{
			return _isFaceDebug;
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
		
		private var _type:uint = 1;

		public function set type(value:uint):void
		{
			_type = value;
		}

		public function get type():uint
		{
			return _type;
		}
		
		public function Renderer(canvas:Sprite)
		{
			this.canvas = canvas;

			view = _view = new Sprite();
			_view.x = canvas.stage.stageWidth / 2;
			_view.y = canvas.stage.stageHeight / 2;
			canvas.addChild(_view);
			
			projection = _projection = new PerspectiveProjection();
			_projection.fieldOfView = 53;
			_projection.projectionCenter = new Point(canvas.stage.stageWidth / 2, canvas.stage.stageHeight / 2);
			_projectionMatrix3D = _projection.toMatrix3D();

			world = new Object3D();
			_worldMatrix3D = world.transform.matrix3D;

			childs = _childs = [];

			isMeshZSort = true;
			isFaceZSort = true;
		}

		public function addChild(object3D:Object3D):void
		{
			if (!object3D)
				return;
				
			_childs.push(object3D);
		}

		public function removeChild(object3D:Object3D):void
		{
			if (!object3D)
				return;
				
			_childs.splice(_childs.indexOf(object3D), 1);
		}
		
		public function render():void
		{
			// dispose
			totalFaces = 0;
			
			// view
			var _view_graphics:Graphics = _view.graphics;
			_view_graphics.clear();
			
			// project children
			var child:Object3D;
			for each (child in _childs)
				child.project(_projectionMatrix3D, _worldMatrix3D);
			
			// z-sort Object3D
			if (_isMeshZSort)
				_childs.sortOn("screenZ", 18);
			
			// draw TODO : auto select render type
			var childNum:int = 0;
			for each (child in _childs)
			{
				if(_type==1)
				{
					// DRAW TYPE #1 drawGraphicsData
					_view_graphics.drawGraphicsData(child.graphicsData);
				}else{
					// DRAW TYPE #2 drawTriangles
					if(child.material is BitmapMaterial)
					{
						var _child_triangles:GraphicsTrianglePath = child.triangles;
						_view_graphics.beginBitmapFill(BitmapMaterial(child.material).texture);
	            		_view_graphics.drawTriangles(_child_triangles.vertices, _child_triangles.indices, _child_triangles.uvtData,  _child_triangles.culling);
	            		_view_graphics.endFill();
	    			}
	  			}
            	
				// Mesh only
				if (child is Mesh)
				{
					// debug current total face number
					totalFaces += int(Mesh(child).numFaces);
					
					// DRAW TYPE #3 drawPath 
					if(_isFaceDebug)
						Mesh(child).debugFace(view.mouseX, view.mouseY, _view_graphics);
				}
			}
			
			/*
			
			// shoulde be faster draw which this way? 
			// sadly "push" Vector is slower, also plenty of dot access
			
			var _drawGraphicsData:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
			for each (child in _childs)
			{
				for each (var graphicsData:IGraphicsData in child.graphicsData)
				{
					_drawGraphicsData.push(graphicsData);
				}

				// count total faces in Mesh
				if (child is Mesh)
					totalFaces += Mesh(child).numFaces;
			}

			_view_graphics.drawGraphicsData(_drawGraphicsData);
			
			*/
		}
		
		// do this when dirty
		public function update():void
		{
			_projectionMatrix3D = _projection.toMatrix3D();
		}
   	}
}
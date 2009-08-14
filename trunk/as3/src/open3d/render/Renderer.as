package open3d.render
{
	import flash.display.*;
	import flash.events.MouseEvent;
	
	import open3d.materials.BitmapMaterial;
	import open3d.objects.Camera3D;
	import open3d.objects.Mesh;
	import open3d.objects.Object3D;

	/**
	 * Renderer
	 *
	 * The default PerspectiveProjection object created on the root has the following values:
	 * 	• fieldOfView: 55
	 * 	• perspectiveCenter: stagewidth/2, stageHeight/2
	 * 	• focalLength: stageWidth/ 2 * ( cos(fieldOfView/2) / sin(fieldOfView/2) )
	 *
	 * @author katopz
	 */
	public class Renderer
	{
		public var totalFaces:int = 0;

		// public var faster than get/set viewPort
		public var viewPort:Sprite;
		private var _viewPort:Sprite;
		
		public var view:Object3D;
		
		private var _camera:Camera3D;
		public function set camera(value:Camera3D):void
		{
			_camera = value;
		}

		public function get camera():Camera3D
		{
			return _camera;
		}
		
		// still need Array for sortOn(faster than Vector sort)
		public var childs:Array;
		private var _childs:Array;

		public function get numChildren():int
		{
			if(_childs)
			{
				return _childs.length;
			}else{
				return 0;
			}
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
		
		private var _mouseEnable:Boolean = false;

		public function set mouseEnable(value:Boolean):void
		{
			_mouseEnable = value;
		}

		public function get mouseEnable():Boolean
		{
			return _mouseEnable;
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
		
		public function Renderer(camera:Camera3D, viewPort:Sprite)
		{
			this.camera = camera;
			
			this.viewPort =_viewPort = viewPort;
			_viewPort.x = _viewPort.stage.stageWidth / 2;
			_viewPort.y = _viewPort.stage.stageHeight / 2;
			
			this.view = camera.view;
			view.renderer = this;
			view.layer = _viewPort;
			
			childs = _childs = view.childs;

			isMeshZSort = true;
			isFaceZSort = true;
		}
		/*
		public function addChild(object3D:Object3D):void
		{
			if (!object3D)
				return;
				
			// default layer
			object3D.layer = object3D.layer?object3D.layer:_viewPort;
			view.addChild(object3D);
		}
		
		public function removeChild(object3D:Object3D):void
		{
			if (!object3D)
				return;
				
			_childs.splice(_childs.indexOf(object3D), 1);
		}
		*/
		public function render():void
		{
			// void
			if(!_childs)return;
			
			// dispose
			totalFaces = 0;
			
			var _graphics:Graphics;
			var child:Object3D;
			
			// clear all layer only once cause some child share same layer
			for each (child in _childs)
				child.clearGraphics();
			
			// child.project faster than project(child) ~4-7fps
			for each (child in _childs)
			{
				child.project(_camera);
				
				if(child.culled) continue;
				
				// graphics layer
				_graphics = child.graphicsLayer;
				
				// draw TODO : auto select render type
				if(_type==1)
				{
					// DRAW TYPE #1 drawGraphicsData
					_graphics.drawGraphicsData(child.graphicsData);
				}else{
					// DRAW TYPE #2 drawTriangles
					if(child.material is BitmapMaterial)
					{
						var _child_triangles:GraphicsTrianglePath = child.triangles;
						_graphics.beginBitmapFill(BitmapMaterial(child.material).texture);
	            		_graphics.drawTriangles(_child_triangles.vertices, _child_triangles.indices, _child_triangles.uvtData,  _child_triangles.culling);
	            		_graphics.endFill();
	    			}
	  			}
            	
				// Mesh only
				if (child is Mesh)
				{
					// debug current total face number
					totalFaces += int(Mesh(child).numFaces);
					
					// DRAW TYPE #3 drawPath 
					if(_isFaceDebug)
						Mesh(child).debugFace(viewPort.mouseX, viewPort.mouseY, _graphics);
					
					// interactive	
					if(_mouseEnable)
					{
						if(Mesh(child).hitTestPoint(viewPort.mouseX, viewPort.mouseY))
							child.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
					}
				}
			}
			
			// z-sort Object3D
			if (_isMeshZSort)
				_childs.sortOn("screenZ", 18);
			
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

			_graphics.drawGraphicsData(_drawGraphicsData);
			
			*/
		}
		
		// can be draw from external
		public function drawGraphicsData(graphicsData:Vector.<IGraphicsData>):void
		{
			_viewPort.graphics.drawGraphicsData(graphicsData);
		}
   	}
}
package open3d.objects
{
	import flash.display.*;
	import flash.geom.*;
	
	import open3d.materials.Material;
	import open3d.materials.shaders.IShader;
	import open3d.render.FrustumCuller;
	import open3d.render.Renderer;

	/**
	 * Object3D
	 * @author katopz
	 */
	public class Object3D extends Sprite
	{
		// call back
		public var renderer:Renderer;
		
		public var triangles:GraphicsTrianglePath;
		protected var _triangles:GraphicsTrianglePath;

		// public var faster than get/set view
		public var vin:Vector.<Number>;
		protected var _vin:Vector.<Number>;

		public var vout:Vector.<Number>;
		protected var _vout:Vector.<Number>;

		// use them if object has normals (OBJ, collada)
		protected var _vertexNormals:Vector.<Number>;

		protected var _material:Material;

		// internal
		private var _transform_matrix3D:Matrix3D;
		private var _vertices:Vector.<Number>;
		private var _uvtData:Vector.<Number>;

		// Z-Sort for Mesh
		public var screenZ:int = 0;
		
		// frustum culling
		public var frustumCuller:FrustumCuller;
		public var isFrustumCulling:Boolean = false;
		public var culled:Boolean = false;
		public var radius:Number = 0;

		public var childs:Array;
		private var _childs:Array;
		
		// Layer
		public var graphicsLayer:Graphics;
		private var _graphicsLayer:Graphics;
		private var _layer:Sprite;

		public function set layer(value:Sprite):void
		{
			_layer = value;
			graphicsLayer = _graphicsLayer = _layer.graphics;
		}

		public function get layer():Sprite
		{
			return _layer;
		}
		
		public function get position():Vector3D
		{
			if(parent is Object3D)
			{
				return Object3D(parent).position.add(transform.matrix3D.position);
			}else{
				return transform.matrix3D.position;
			}
		}

		// for async mesh
		protected var _ready:Boolean = false;

		public function Object3D():void
		{
			vin = _vin = new Vector.<Number>();
			setMatrix3D(new Matrix3D());
			_material = new Material();
			
			childs = _childs = [];
			
			// TODO : move frustumCuller to camera
			frustumCuller = new FrustumCuller();
		}
		
		public function setMatrix3D(matrix3D:Matrix3D):void
		{
			_transform_matrix3D = transform.matrix3D = matrix3D;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			
			var _child:Object3D;
			
			if (child is Object3D)
			{
				_child = Object3D(child);
				
				// default layer = parent layer
				if(layer && !_child.layer)
					_child.layer = layer;
					
				_childs.push(_child);
				
				// link to renderer
				if(parent is Object3D && Object3D(parent).renderer)
				{
					renderer = Object3D(parent).renderer;
					renderer.view.childs.push(_child);
					for each (var _innerChild:Object3D in _child.childs)
					{
						renderer.view.childs.push(_innerChild);
					}
				} 
			}
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			if (!child)return null;
			_childs.splice(_childs.indexOf(child), 1);
			
			return child;
		}
		
		/**
		 * must update once before project loop
		 */
		public function update():void
		{
			var _vin_length:int = _vin.length;
			
			// speed up
			_vin.fixed = true;
			_triangles.uvtData.fixed = true;
			_triangles.indices.fixed = true;

			// private use
			_vertices = _triangles.vertices;
			_uvtData = _triangles.uvtData;

			// public use
			triangles = _triangles;

			// dispose vout
			vout = _vout = new Vector.<Number>(_vin_length, true);
			
			// calculate normals for the shaders
			if (material is IShader)
 				IShader(material).calculateNormals(_vin, _triangles.indices, _uvtData, _vertexNormals);
			
			// no faces?, calculate screenZ from Object XYZ 
			if (_vin_length == 0)
				screenZ = x + y + z;
			
			_ready = true;
		}
		
		// Hierarchic
		public function updateTransform(object3D:Object3D):void
		{
			if(object3D && object3D.parent && object3D.parent is Object3D)
			{
				object3D.parent.transform.matrix3D.transformVectors(_vout, _vout);
				updateTransform(Object3D(object3D.parent));
			}
		}
		
		public function project(camera:Camera3D):void
		{
			// projection matrix
			var projectionMatrix3D:Matrix3D = camera.projection.toMatrix3D();

			// model matrix
			_transform_matrix3D.transformVectors(_vin, _vout);
			
			// view matrix
			if(parent)
				updateTransform(this);
				
			// project the normals
			if (material is IShader)
				_triangles.uvtData = IShader(material).getUVData(_transform_matrix3D.clone());

			// project
			Utils3D.projectVectors(projectionMatrix3D, _vout, _vertices, _uvtData);
			
			// frustum sphere culling
			// TODO : apply camera transfrom, move to camera frustum
			if(isFrustumCulling)
			{
				frustumCuller.setCamInternals(camera.angle, camera.ratio, radius*2, camera.projection.focalLength*4);
				frustumCuller.setCamDef(camera.transform.matrix3D.position, camera.left, camera.up);
				culled = (frustumCuller.sphereInFrustum(_transform_matrix3D.position, radius)==0);
			}
		}

		public function set material(value:Material):void
		{
			_material = value ? value : new Material();
			_material.triangles = _triangles;
			_material.update();
		}

		public function get material():Material
		{
			return _material;
		}

		public function get graphicsData():Vector.<IGraphicsData>
		{
			return _material.graphicsData;
		}

		public function clearGraphics():void
		{
			_graphicsLayer.clear();
		}

		// TODO : more friendly use
		public function getVertices(index:int):Vector3D
		{
			return new Vector3D(_vin[3 * index + 0], _vin[3 * index + 1], _vin[3 * index + 2]);
		}

		// TODO : more friendly use
		public function setVertices(index:int, axis:String, value:Number):void
		{
			if (axis == "x")
			{
				_vin[3 * index + 0] = value;
			}
			else if (axis == "y")
			{
				_vin[3 * index + 1] = value;
			}
			else if (axis == "z")
			{
				_vin[3 * index + 2] = value;
			}
		}
	}
}
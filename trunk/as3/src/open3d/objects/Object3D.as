package open3d.objects
{
	import flash.display.*;
	import flash.geom.*;

	import open3d.materials.Material;
	import open3d.materials.shaders.IShader;

	/**
	 * Object3D
	 * @author katopz
	 */
	public class Object3D extends Sprite
	{
		public var triangles:GraphicsTrianglePath;
		protected var _triangles:GraphicsTrianglePath;

		// public var faster than get/set view
		public var vin:Vector.<Number>;
		protected var _vin:Vector.<Number>;

		public var vout:Vector.<Number>;
		protected var _vout:Vector.<Number>;

		protected var _material:Material;

		// internal
		private var _transform_matrix3D:Matrix3D;
		private var _vertices:Vector.<Number>;
		private var _uvtData:Vector.<Number>;

		// Z-Sort for Mesh
		public var screenZ:Number = 0;

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

		// for async mesh
		protected var _ready:Boolean = false;

		public function Object3D():void
		{
			vin = _vin = new Vector.<Number>();
			_transform_matrix3D = transform.matrix3D = new Matrix3D();
			_material = new Material();
		}

		/**
		 * must update once before project loop
		 */
		public function update():void
		{
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
			vout = _vout = new Vector.<Number>(_vin.length, true);
			// calculate normals for the shaders
			if (material is IShader)
			{
				var shader:IShader = material as IShader;
				shader.calculateNormals(_vin, _triangles.indices);
			}
			// no faces?, calculate screenZ from Object XYZ 
			if (_vin.length == 0)
				screenZ = x + y + z;

			_ready = true;
		}

		public function project(camera:Camera3D):void
		{
			// can be optimize later
			var projectionMatrix3D:Matrix3D = camera.projection.toMatrix3D();

			// object3d
			_transform_matrix3D.transformVectors(_vin, _vout);

			// camera3d
			var cameraMatrix3D:Matrix3D = camera.matrix3D.clone();
			cameraMatrix3D.invert();
			cameraMatrix3D.transformVectors(_vout, _vout);

			// project the normals 
			if (material is IShader)
			{
				var shader:IShader = material as IShader;			
				var projectMatrix:Matrix3D = _transform_matrix3D.clone();
				 projectMatrix.position =new Vector3D(0,0,0);
				_triangles.uvtData = shader.getUVData(projectMatrix);
			}

			// project
			Utils3D.projectVectors(projectionMatrix3D, _vout, _vertices, _uvtData);
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
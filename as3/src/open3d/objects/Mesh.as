package open3d.objects
{
	import __AS3__.vec.Vector;
	
	import flash.display.GraphicsStroke;
	import flash.display.GraphicsTrianglePath;
	import flash.display.IGraphicsData;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;
	
	import open3d.geom.Face;
	import open3d.materials.Material;
	
	/**
	 * Mesh
	 * @author katopz
	 * 
	 */	
	public class Mesh extends Sprite
	{
		protected var vertices3D:Vector.<Number> = new Vector.<Number>();
		protected var triangles:GraphicsTrianglePath = new GraphicsTrianglePath(new Vector.<Number>(), new Vector.<int>(), new Vector.<Number>(), TriangleCulling.POSITIVE);

		public var _material:Material;

		protected var faces:Vector.<Face>;
		protected var vout:Vector.<Number>;
		
		public var totalFace:int = 0;
		
		private var _isFaceZSort:Boolean;
		private  var facesList:Array;
		
		public function set isFaceZSort(value:Boolean):void
		{
			_isFaceZSort = value;
		}
		public function get isFaceZSort():Boolean
		{
			return _isFaceZSort;
		}

		public function Mesh()
		{
			transform.matrix3D = new Matrix3D();
			isFaceZSort = true;
		}
		
		protected function buildFaces(material:Material):void
		{
			var _indices:Vector.<int> = triangles.indices;
			var _indices_length:int = _indices.length / 3;
			
			faces = new Vector.<Face>(_indices_length, true);
			facesList = [];
			
			var i0:Number, i1:Number, i2:Number;
			for (var i:int = 0; i < _indices_length; ++i)
			{
				var ix3:int = int(i*3);
				i0 = _indices[ix3 + 0];
				i1 = _indices[ix3 + 1];
				i2 = _indices[ix3 + 2];
				
				// Vector3D faster than Vector
				var index:Vector3D = new Vector3D(i0, i1, i2)
				var _face:Face = faces[i] = new Face(index, new Vector3D(3 * i0 + 2, 3 * i1 + 2, 3 * i2 + 2));
				facesList[i] = index;
			}
			
			this.material = material;
			this.material.update();
			
			vertices3D.fixed = true;
			triangles.uvtData.fixed = true;
			triangles.indices.fixed = true;
		}
		
		public function updateTransform(projection:Matrix3D, matrix3D:Matrix3D):void
		{
			vout = new Vector.<Number>(vertices3D.length, true);
			
			// local
			transform.matrix3D.transformVectors(vertices3D, vout);
				
			// global
			matrix3D.transformVectors(vout, vout);

			// project
			Utils3D.projectVectors(projection, vout, triangles.vertices, triangles.uvtData);

			// z-sort
			if (isFaceZSort)
			{
				var _vout:Vector.<Number> = vout;
				var _facesList:Array = facesList;
				
				// get last depth after projected
				for each (var _face:Face in faces)
					_face.update(vout);
				
				// sortOn (faster than Vector.sort)
				_facesList.sortOn("w", 16);
				
				// push back (faster than Vector concat)
				var _triangles_indices:Vector.<int> = triangles.indices = new Vector.<int>(_facesList.length * 3, true);
				var j:int = 0;
				for each(var face:Vector3D in _facesList)
				{
					_triangles_indices[j++] = face.x;
					_triangles_indices[j++] = face.y;
					_triangles_indices[j++] = face.z;
				}
				
				// debug
				totalFace = _facesList.length;
			}
		}
		
		public function set material(value:Material):void
		{
			_material = value;
			_material.triangles = triangles;
			_material.graphicsData = material.graphicsData;
		}
		
		public function get material():Material
		{
			return _material;
		}
		
		public function get graphicsData():Vector.<IGraphicsData>
		{
			return _material.graphicsData;
		}
		
		public function set stroke(value:GraphicsStroke):void
		{
			_material.stroke = value;
		}
		
		public function get stroke():GraphicsStroke
		{
			return _material.stroke;
		}
	}
}

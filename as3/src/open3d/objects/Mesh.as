package open3d.objects
{
	import __AS3__.vec.Vector;
	
	import flash.display.*;
	import flash.geom.*;
	
	import open3d.geom.Face;
	import open3d.materials.Material;
	
	/**
	 * Mesh
	 * @author katopz
	 */	
	public class Mesh extends Object3D
	{
		public var screenZ:Number = 0;
		
		// public var faster than get/set
		public var faces:Vector.<Face>;
		protected var _faces:Vector.<Face>;
		
		// still need Array for sortOn(faster than Vector sort)
		private var _faceIndexes:Array;
		
		public function get numFaces():int
		{
			return _faceIndexes?_faceIndexes.length:0;
		}
		
		protected var _culling:String = TriangleCulling.NEGATIVE;
		public function set culling(value:String):void
		{
			_culling = value;
			triangles.culling = _culling;
		}
		
		public function get culling():String
		{
			return _culling;
		}
		
		private var _isFaceZSort:Boolean = true;
		public function set isFaceZSort(value:Boolean):void
		{
			_isFaceZSort = value;
		}
		
		public function get isFaceZSort():Boolean
		{
			return _isFaceZSort;
		}
		
		private var _isDirty:Boolean = false;
		public function set isDirty(value:Boolean):void
		{
			_isDirty = value;
		}
		
		public function get isDirty():Boolean
		{
			return _isDirty;
		}
		
		public function Mesh()
		{
			triangles = new GraphicsTrianglePath(new Vector.<Number>(), new Vector.<int>(), new Vector.<Number>(), culling);
		}
		
		protected function buildFaces(material:Material):void
		{
			var _indices:Vector.<int> = triangles.indices;
			
			// numfaces
			var _indices_length:int = _indices.length / 3;
			
			_faces = new Vector.<Face>(_indices_length, true);
			_faceIndexes = [];
			
			var i0:Number, i1:Number, i2:Number;
			for (var i:int = 0; i < _indices_length; ++i)
			{
				// 3 point of face 
				var ix3:int = int(i*3);
				i0 = _indices[int(ix3 + 0)];
				i1 = _indices[int(ix3 + 1)];
				i2 = _indices[int(ix3 + 2)];
				
				// Vector3D faster than Vector
				var index:Vector3D = new Vector3D(i0, i1, i2);
				var _face:Face = _faces[i] = new Face(index, 3 * i0 + 2, 3 * i1 + 2, 3 * i2 + 2);
				
				// register face index for z-sort, make it seal in this class, faster than "dot access" like face.index
				_faceIndexes[i] = index;
			}
			
			this.material = material;
			
			isDirty = true;
			
			// for public call fadter than get/set
			faces = _faces;
			
			update();
		}
		
		override public function project(projectionMatrix3D:Matrix3D, matrix3D:Matrix3D):void
		{
			super.project(projectionMatrix3D, matrix3D);
			
			// z-sort, TODO : only sort when isDirty
			if (_isFaceZSort && _isDirty)
			{
				// get last depth after projected
				for each (var _face:Face in _faces)
					_face.calculateScreenZ(vout);
				
				// sortOn (faster than Vector.sort)
				_faceIndexes.sortOn("w", 18);
				
				var _faceIndexes_length:int = _faceIndexes.length;
				
				// push back (faster than Vector concat)
				var _triangles_indices:Vector.<int> = triangles.indices = new Vector.<int>(_faceIndexes_length * 3, true);
				var i:int = -1;
				for each(var face:Vector3D in _faceIndexes)
				{
					_triangles_indices[++i] = face.x;
					_triangles_indices[++i] = face.y;
					_triangles_indices[++i] = face.z;
				}
			}
			
			// faster than getRelativeMatrix3D, also support current render method
			if(_faceIndexes_length>0)
				screenZ = _faceIndexes[int(_faceIndexes_length*.5)].w;
		}
	}
}

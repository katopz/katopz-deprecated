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
		
		protected var faces:Vector.<Face>;
		private  var facesList:Array;
				
		public function get numFaces():int
		{
			return facesList?facesList.length:0;
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
			var _indices_length:int = _indices.length / 3;
			
			faces = new Vector.<Face>(_indices_length, true);
			facesList = [];
			
			var i0:Number, i1:Number, i2:Number;
			for (var i:int = 0; i < _indices_length; ++i)
			{
				var ix3:int = int(i*3);
				i0 = _indices[int(ix3 + 0)];
				i1 = _indices[int(ix3 + 1)];
				i2 = _indices[int(ix3 + 2)];
				
				// Vector3D faster than Vector
				var index:Vector3D = new Vector3D(i0, i1, i2);
				var _face:Face = faces[i] = new Face(index, new Vector3D(3 * i0 + 2, 3 * i1 + 2, 3 * i2 + 2));
				
				// register face index for z-sort
				facesList[i] = index;
			}
			
			this.material = material;
			this.material.update();
			
			isDirty = true;
			
			vin.fixed = true;
			triangles.uvtData.fixed = true;
			triangles.indices.fixed = true;
		}
		
		override public function project(projectionMatrix3D:Matrix3D, matrix3D:Matrix3D):void
		{
			super.project(projectionMatrix3D, matrix3D);
			
			// z-sort, TODO : sort when isDirty
			if (_isFaceZSort && _isDirty)
			{
				var _vout:Vector.<Number> = vout;
				var _facesList:Array = facesList;
				
				// get last depth after projected
				for each (var _face:Face in faces)
					_face.calculateScreenZ(vout);
				
				// sortOn (faster than Vector.sort)
				_facesList.sortOn("w", 18);
				
				var _facesList_length:int = _facesList.length;
				
				// push back (faster than Vector concat)
				var _triangles_indices:Vector.<int> = triangles.indices = new Vector.<int>(_facesList_length * 3, true);
				var j:int = 0;
				for each(var face:Vector3D in _facesList)
				{
					_triangles_indices[j++] = face.x;
					_triangles_indices[j++] = face.y;
					_triangles_indices[j++] = face.z;
				}
			}
			
			// faster than getRelativeMatrix3D, also support current render method
			if(_facesList_length>0)
				screenZ = facesList[int(_facesList_length*.5)].w;
		}
	}
}

package open3d.geom
{
	import __AS3__.vec.Vector;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import open3d.objects.Mesh;

	/**
	 * Face
	 * @author katopz
	 */
	public class Face
	{
		private var mesh:Mesh;
		
		// TODO : Vector3D?
		private var indice:Vector3D;
		
		private var i0:uint;
		private var i1:uint;
		private var i2:uint;
		
		private var j0:uint;
		private var j1:uint;
		private var j2:uint;
		
		private var index:uint;
		
		private var normal:Vector3D;
		
		public function Face(mesh:Mesh, indice:Vector3D, j0:uint, j1:uint, j2:uint)
		{
			this.indice = indice;
			this.mesh = mesh;
			
			// for faster access
			this.i0 = indice.x;
			this.i1 = indice.y;
			this.i2 = indice.z;

			this.j0 = j0;
			this.j1 = j1;
			this.j2 = j2;
		}

		public function calculateScreenZ(vout:Vector.<Number>):void
		{
			indice.w = vout[j0] + vout[j1] + vout[j2];
		}
		
		// 1st attempt add normal point to vertices, drop 30 -> 25fps 
		public function calculateNormal(vertices:Vector.<Number>, uvtData:Vector.<Number>):void
		{
			var i0:int = (i0 << 1) + i0, i1:int = (i1 << 1) + i1, i2:int = (i2 << 1) + i2;
			
			var k0:uint;
			var k1:uint;
			var k2:uint;
			
			// index for 2D projected
			index = 2 * vertices.length / 3;

			// N0 (x, y, z)

			// x 
			var x01:Number = vertices[i1] - vertices[i0], x02:Number = vertices[i2] - vertices[i0];
			k0 = vertices.length;
			vertices.push((vertices[i0++] + vertices[i1++] + vertices[i2++]) / 3);

			// y
			var y01:Number = vertices[i1] - vertices[i0], y02:Number = vertices[i2] - vertices[i0];
			k1 = vertices.length;
			vertices.push((vertices[i0++] + vertices[i1++] + vertices[i2++]) / 3);

			// z
			var z01:Number = vertices[i1] - vertices[i0], z02:Number = vertices[i2] - vertices[i0];
			k2 = vertices.length;
			vertices.push((vertices[i0++] + vertices[i1++] + vertices[i2++]) / 3);

			// cross product
			normal = new Vector3D(y02 * z01 - y01 * z02, z02 * x01 - z01 * x02, x02 * y01 - x01 * y02, 0);
			normal.normalize();

			uvtData.push(vertices[k0], vertices[k1], vertices[k2]);

			// N1 (x, y, z)
			vertices.push(vertices[k0] + normal.x * 100, vertices[k1] + normal.y * 100, vertices[k2] + normal.z * 100);
			uvtData.push(vertices[k2 + 1], vertices[k2 + 2], vertices[k2 + 3]);
		}
		
		// get path data from projected vertices
		public function getPathData(_vertices:Vector.<Number>):Vector.<Number>
		{
			var _pathData:Vector.<Number> = new Vector.<Number>(10, true);
			var i:int;
			
			// P0 (x,y)
			i = i0 << 1;
			_pathData[0] = _vertices[i];
			_pathData[1] = _vertices[i + 1];
			
			// P1 (x,y)
			i = i1 << 1;
			_pathData[2] = _vertices[i];
			_pathData[3] = _vertices[i + 1];

			// P2 (x,y)
			i = i2 << 1;
			_pathData[4] = _vertices[i];
			_pathData[5] = _vertices[i + 1];
			
			
			// N0 (x,y)
			_pathData[6] = _vertices[index];
			_pathData[7] = _vertices[index + 1];
			
			// N1 (x,y)
			_pathData[8] = _vertices[index + 2];
			_pathData[9] = _vertices[index + 3];
			
			return _pathData; 
		}
	}
}
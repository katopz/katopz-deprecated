package open3d.geom
{
	import __AS3__.vec.Vector;
	
	import flash.geom.Vector3D;

	/**
	 * Face : not a real face yet ;p
	 * @author katopz
	 */
	public class Face
	{
		// actually it's not Vector3D so...tobe remove
		private var indice:Vector3D;

		private var i0:uint;
		private var i1:uint;
		private var i2:uint;
		
		private var j0:uint;
		private var j1:uint;
		private var j2:uint;
		
		private var k0:uint;
		private var k1:uint;
		private var k2:uint;
		
		private var index:uint;
		
		public var normal:Vector3D;
		
		public function getN0(vin:Vector.<Number>):Vector3D
		{
			return new Vector3D(vin[k0], vin[k1], vin[k2]);
		}
		
		public function getN1(vin:Vector.<Number>):Vector3D
		{
			return new Vector3D(vin[k2+1], vin[k2+2], vin[k2+3]);
		}
		
		public function Face(indice:Vector3D, j0:uint, j1:uint, j2:uint)
		{
			this.indice = indice;
			
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
		
		// TODO : separate this from vin to test speed gain or not
		public function calculateNormal(vin:Vector.<Number>, uvtData:Vector.<Number>):void
		{
			var i0:int=(i0 << 1) + i0, i1:int=(i1 << 1) + i1, i2:int=(i2 << 1) + i2;
			
			// index for 2D projected
			index = 2*vin.length/3;
			
			// x 
			var x01:Number=vin[i1] - vin[i0], x02:Number=vin[i2] - vin[i0];
			k0 = vin.length;
			vin.push((vin[i0++] + vin[i1++] + vin[i2++]) / 3);
			
			// y
			var y01:Number=vin[i1] - vin[i0], y02:Number=vin[i2] - vin[i0];
			k1 = vin.length;
			vin.push((vin[i0++] + vin[i1++] + vin[i2++]) / 3);
			
			// z
			var z01:Number=vin[i1] - vin[i0], z02:Number=vin[i2] - vin[i0];
			k2 = vin.length;
			vin.push((vin[i0++] + vin[i1++] + vin[i2++]) / 3);
			
			// cross product
			normal = new Vector3D(y02 * z01 - y01 * z02, z02 * x01 - z01 * x02, x02 * y01 - x01 * y02, 0);
			normal.normalize();
			
			uvtData.push(vin[k0], vin[k1], vin[k2]);
			
			// n1 : x, y, z
			vin.push(vin[k0]+normal.x*100, vin[k1]+normal.y*100, vin[k2]+normal.z*100);
			uvtData.push(vin[k2+1], vin[k2+2], vin[k2+3]);
		}
		
		// get path data from vertices
		public function getPathData(_vertices:Vector.<Number>):Vector.<Number>
		{
			var _pathData:Vector.<Number> = new Vector.<Number>(10, true);
			var i:int;
			
			// P0
			i = i0 << 1;
			_pathData[0] = _vertices[i];
			_pathData[1] = _vertices[i + 1];
			
			// P1
			i = i1 << 1;
			_pathData[2] = _vertices[i];
			_pathData[3] = _vertices[i + 1];

			// P2
			i = i2 << 1;
			_pathData[4] = _vertices[i];
			_pathData[5] = _vertices[i + 1];
			
			// normal0
			_pathData[6] = _vertices[index];
			_pathData[7] = _vertices[index + 1];
			
			// normal1
			_pathData[8] = _vertices[index + 2];
			_pathData[9] = _vertices[index + 3];
			
			return _pathData; 
		}
	}
}
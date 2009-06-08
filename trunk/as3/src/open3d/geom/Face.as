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
		
		public function getPathData(_vertices:Vector.<Number>):Vector.<Number>
		{
			var _pathData:Vector.<Number> = new Vector.<Number>(6, true);
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
			
			return _pathData; 
		}
		
		/* TODO : make it work
		public function getNormal(_vertices:Vector.<Number>):Vector3D
		{
			var vs:Vector.<Number>=_vertices;
			var j:int = 0 ;
			
			var f:Face = this;
			
			var i0:int=(f.i0 << 1) + f.i0, i1:int=(f.i1 << 1) + f.i1, i2:int=(f.i2 << 1) + f.i2;
			var x01:Number=vs[i1] - vs[i0], x02:Number=vs[i2] - vs[i0];
			i0++;i1++;i2++;
			var y01:Number=vs[i1] - vs[i0], y02:Number=vs[i2] - vs[i0];
			i0++;i1++;i2++;
			var z01:Number=vs[i1] - vs[i0], z02:Number=vs[i2] - vs[i0];
			i0++;i1++;i2++;
			
			var normal:Vector3D = new Vector3D(y02 * z01 - y01 * z02, z02 * x01 - z01 * x02, x02 * y01 - x01 * y02, 0);
			//normal.normalize();
			//trace(normal)
			return normal;
		}
		*/
	}
}
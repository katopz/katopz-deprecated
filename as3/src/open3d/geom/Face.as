package open3d.geom
{
	import flash.geom.Vector3D;

	import open3d.objects.Mesh;

	/**
	 * Face
	 * @author katopz
	 */
	public class Face
	{
		// use for refer back to mesh
		private var mesh:Mesh;

		// use Vector3D here cause we need "w" for z-sort, to be replace if we find something better/faster
		private var indice:Vector3D;

		// for faster access
		private var i0:uint;
		private var i1:uint;
		private var i2:uint;

		// for z-sort
		private var j0:uint;
		private var j1:uint;
		private var j2:uint;

		// for later use
		public var v0:Vector3D;
		public var v1:Vector3D;
		public var v2:Vector3D;
		
		// The length, magnitude, of the current Vector3D object from the origin (0,0,0) to the object's x, y, and z coordinates.
		public var length:Number;
		
		public function Face(mesh:Mesh, indice:Vector3D, v0:Vector3D, v1:Vector3D, v2:Vector3D)
		{
			this.indice = indice;
			this.mesh = mesh;

			this.i0 = indice.x;
			this.i1 = indice.y;
			this.i2 = indice.z;

			this.j0 = 3 * i0 + 2;
			this.j1 = 3 * i1 + 2;
			this.j2 = 3 * i2 + 2;

			this.v0 = v0;
			this.v1 = v1;
			this.v2 = v2;
			
			length = (v0.length + v1.length + v2.length)/3;
		}

		public function calculateScreenZ(vout:Vector.<Number>):void
		{
			indice.w = vout[j0] + vout[j1] + vout[j2];
		}
		
		// get path data from projected vertices
		public function getPathData(projectedVerts:Vector.<Number>):Vector.<Number>
		{
			var _pathData:Vector.<Number> = new Vector.<Number>(10, true);
			var i:int;

			// P0 (x,y)
			i = i0 << 1;
			_pathData[0] = projectedVerts[i];
			_pathData[1] = projectedVerts[i + 1];

			// P1 (x,y)
			i = i1 << 1;
			_pathData[2] = projectedVerts[i];
			_pathData[3] = projectedVerts[i + 1];

			// P2 (x,y)
			i = i2 << 1;
			_pathData[4] = projectedVerts[i];
			_pathData[5] = projectedVerts[i + 1];

			return _pathData;
		}
	}
}
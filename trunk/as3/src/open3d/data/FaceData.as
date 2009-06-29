package open3d.data
{
	import flash.geom.Vector3D;
	
	/**
	 * Old Face Style, to be merge with new Face style
	 * @author katopz
	 */
	public class FaceData
	{
		public var a:int;
		public var b:int;
		public var c:int;

		public var v1:Vector3D;
		public var v2:Vector3D;
		public var v3:Vector3D;
		
		public var uvMap:Array;

		public function FaceData(a:Number, b:Number, c:Number, v1:Vector3D, v2:Vector3D, v3:Vector3D, uvMap:Array = null)
		{
			this.a = a;
			this.b = b;
			this.c = c;

			this.v1 = v1;
			this.v2 = v2;
			this.v3 = v3;

			this.uvMap = uvMap;
		}

		public function getNormal():Vector3D
		{
			// TODO : optimize
			var ab:Vector3D = new Vector3D(v2.x - v1.x, v2.y - v1.y, v2.z - v1.z);
			var ac:Vector3D = new Vector3D(v3.x - v1.x, v3.y - v1.y, v3.z - v1.z);
			var n:Vector3D = ac.crossProduct(ab);
			n.normalize();
			return n;
		}
	}
}

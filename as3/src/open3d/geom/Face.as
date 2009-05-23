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
		// actually it's not Vector3D but it's faster than Vector
		private var a:Vector3D;
		private var b:Vector3D;
		
		public function Face(a:Vector3D, b:Vector3D)
		{
			this.a = a;
			this.b = b;
		}
		
		public function calculateScreenZ(vout:Vector.<Number>):void
		{
			a.w = vout[b.x] + vout[b.y] + vout[b.z];
		}
	}
}

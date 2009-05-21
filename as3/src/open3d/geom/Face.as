package open3d.geom
{
	import __AS3__.vec.Vector;
	
	import flash.geom.Vector3D;
	
	/**
	 * Face
	 * @author katopz
	 * 
	 */	
	public class Face
	{
		// actually it's not Vector3D but we can use it, cause it's faster than Vector
		private var a:Vector3D;
		private var b:Vector3D;
		
		public function Face(a:Vector3D, b:Vector3D)
		{
			this.a = a;
			this.b = b;
		}
		
		public function update(vout:Vector.<Number>):void
		{
			a.w = vout[b.x] + vout[b.y] + vout[b.z];
		}
	}
}

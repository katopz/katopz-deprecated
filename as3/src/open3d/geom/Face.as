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
		// actually it's not suppose to use Vector3D here but it's faster than Vector and we can use "w" as depth
		private var indice:Vector3D;
		
		private var i0:uint;
		private var i1:uint;
		private var i2:uint;
		
		public function Face(indice:Vector3D, i0:uint, i1:uint, i2:uint)
		{
			this.indice = indice;
			this.i0 = i0;
			this.i1 = i1;
			this.i2 = i2;
		}
		
		public function calculateScreenZ(vout:Vector.<Number>):void
		{
			indice.w = vout[i0] + vout[i1] + vout[i2];
		}
	}
}
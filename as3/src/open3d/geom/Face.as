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
		private var indice:Vector3D;
		private var index:Vector3D;
		
		//public var vertices:Vector.<Vector3D>;
		
		public function Face(indice:Vector3D, index:Vector3D)
		{
			this.indice = indice;
			this.index = index;
		}
		
		public function calculateScreenZ(vout:Vector.<Number>):void
		{
			indice.w = vout[index.x] + vout[index.y] + vout[index.z];
		}
	}
}
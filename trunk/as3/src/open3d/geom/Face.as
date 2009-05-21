package open3d.geom
{
	import __AS3__.vec.Vector;
	
	/**
	 * Face
	 * @author katopz
	 * 
	 */	
	public class Face
	{
		private var a:Vertex;
		private var b:Vertex;
		private var vout:Vector.<Number>;
		
		public function Face(a:Vertex, b:Vertex)
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

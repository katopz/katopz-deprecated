package open3d.geom {

	import flash.geom.Vector3D;
	/**
	 * @author kris
	 */
	public class Vertex 
	{
		private var faceNormals : Vector.<Vector3D> = new Vector.<Vector3D>();
		public var normal:Vector3D =new Vector3D() ;
		public function addFaceNormal(faceNormal:Vector3D):void
		{
			faceNormals.push(faceNormal);
		
		}
		public function calculateNormal():Vector3D
		{
			var l : int = faceNormals.length;
			
			normal = new Vector3D();
			for (var i : int = 0;i < l; i++)
			{
				normal .x +=faceNormals[i].x;
				normal .y += faceNormals[i].y;
				normal .z += faceNormals[i].z;
				
			}
			normal .x /= l;
			normal .y /= l;
			normal .z /= l;
			
			return normal;
		}
	}
}

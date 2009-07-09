package  
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;		

	/**
	 * @author kris@neuroproductions.be
	 */
	public class Triangle 
	{
		
	
		
		public var uvData:Vector.<Number> = new Vector.<Number>(9)
		public var vertices : Vector.<Number> = new Vector.<Number>(9);
		public var verticesTrans : Vector.<Number> = new Vector.<Number>(9);
		
		public var screenZ : Number
		public var indices : Vector.<int> = new Vector.<int>(3);
		public var mat : String;

		
		
		
		
		public function project(m : Matrix3D) : void
		{	
			var a : Vector3D = 	m.transformVector(new Vector3D(vertices[0],vertices[1],vertices[2]))	
			var b : Vector3D = 	m.transformVector(new Vector3D(vertices[3],vertices[4],vertices[5]))	
			var c : Vector3D = 	m.transformVector(new Vector3D(vertices[6],vertices[7],vertices[8]))
			
			
			screenZ = a.z +b.z +c.z
			
		
			uvData[2] = a.z

			uvData[5] = b.z

			uvData[8] = c.z
			
			indices[0] = 0
			indices[1] = 1
			indices[2] = 2
		}
	}
}

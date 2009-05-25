package open3d.objects
{
	import open3d.materials.Material;
	
	/**
	 * Plane
	 * @author katopz
	 */	
	public class Plane extends Mesh
	{
		public function Plane(width:Number, height:Number, material:Material):void 
		{
			// vertices
			// a+---+b
			//  |	|
			//  |   | 
			// d+---+c
			//
			vin.push(-width/2, -height/2, 0);
			vin.push(+width/2, -height/2, 0);
			vin.push(+width/2, +height/2, 0);
			vin.push(-width/2, +height/2, 0);
			
			// With UV values alone, uvtData.length == vertices.length.
			// uvtData.push(0,0,t1, 1,0,t2, 1,1,t3, 0,1,t4);
			triangles.uvtData.push(0, 0, 1);
			triangles.uvtData.push(1, 0, 1);
			triangles.uvtData.push(1, 1, 1);
			triangles.uvtData.push(0, 1, 1);
			
			// The winding for a path is either positive (clockwise)
			//   ___
			// 0|  /|1
			//  | / |
			// 3|/__|2
			//
			triangles.indices.push(0, 1, 3);
			triangles.indices.push(1, 2, 3);
			
			buildFaces(material);
		}
	}
}
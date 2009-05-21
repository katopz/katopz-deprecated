package open3d.objects
{
	import open3d.materials.Material;
	
	/**
	 * Plane
	 * @author katopz
	 * 
	 */	
	public class Plane extends Mesh
	{
		public function Plane(width:Number, height:Number, material:Material):void 
		{
			vin.push(-width/2, 0, -width/2 );
			vin.push( width/2, 0, -width/2 );
			vin.push( width/2, 0,  height/2);
			vin.push(-width/2, 0,  height/2);
			
			triangles.uvtData.push(0,0,1);
			triangles.uvtData.push(1,0,1);
			triangles.uvtData.push(1,1,0);
			triangles.uvtData.push(0,1,1);
			
			triangles.indices.push(0,1,3);
			triangles.indices.push(1,2,3);
			
			buildFaces(material);
		}
	}
}
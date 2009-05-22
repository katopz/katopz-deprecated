package open3d.objects 
{
	import open3d.materials.Material;
	
	/**
	* @author senocular (Flash CS4 spinning globe example)
	* @link http://www.senocular.com/flash/source.php?id=1.201
	* @mod katopz
	*/
	public class Sphere extends Mesh
	{
		public function Sphere(radius:Number, parallels:int, meridians:int, material:Material):void 
		{
			if (parallels < 3) parallels = 3;
			if (meridians < 3) meridians = 3;
			meridians++; // texture edge meridian duplicated
			
			var parallelStops:int = parallels-1; // for determining u
			var meridianStops:int = meridians-1; // for determining v
			
			// local variables
			var r:Number; // radius
			var x:Number, y:Number, z:Number; // coordinates
			var p:int, pi:int, pa:Number; // parallel vars
			var m:int, mi:int, ma:Number; // meridian vars
			var u:Number, v:Number; // u, v of uvt
			var n:int = 0; // vertices index
			
			// horizontal
			for (p=0; p<parallels; p++)
			{
				v = p/parallelStops;
				pa = v*Math.PI - Math.PI/2;
				y = radius*Math.sin(pa);
				r = radius*Math.cos(pa);
				
				// vertical
				for (m=0; m<meridians; m++)
				{
					u = m/meridianStops;
					ma = u*Math.PI*2;
					x = r*Math.cos(ma);
					z = r*Math.sin(ma);
					
					// vertices
					vin.push(x,y,z);
					
					// triangles
					triangles.uvtData.push(u, v, 1);
					
					if (m != 0){ // not first meridian (texture edge)
						if (p != parallelStops){ // not last parallel (no next parallel to connect)
							triangles.indices.push(n, n+meridians, n+meridians-1);
							triangles.indices.push(n, n+meridians-1, n-1);
						}
					}
					n++;
				}
			}
						
			buildFaces(material);
		}
	}
}
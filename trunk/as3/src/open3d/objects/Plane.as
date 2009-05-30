package open3d.objects
{
	import open3d.materials.Material;

	/**
	 * Plane
	 * @author katopz
	 */
	public class Plane extends Mesh
	{
		public function Plane(width:Number, height:Number, material:Material = null, segmentW:uint = 1, segmentH:uint = 1)
		{
			segmentW++;
			segmentH++;

			var segmentW_1:int = (segmentW>1)?segmentW - 1:segmentW=1;
			var segmentH_1:int = (segmentH>1)?segmentH - 1:segmentH=1;
			
			var x:Number, y:Number, z:Number;
			var i:int, j:int, k:int = 0;
			var u:Number, v:Number;

			// horizontal
			for (i = 0; i < segmentW; ++i)
			{
				v = i / segmentW_1;
				y = -height / 2 + i * height / segmentW_1;
				
				// vertical
				for (j = 0; j < segmentH; ++j)
				{
					u = j / segmentH_1;
					x = -width / 2 + j * width / segmentH_1;
					z = 0;
					
					// vin
					// a+---+b
					//  |   | 
					// d+---+c
					//
					vin.push(x, y, z);

					// With UV values alone, uvtData.length == vertices.length.
					// uvtData.push(0,0,t1, 1,0,t2, 1,1,t3, 0,1,t4);
					triangles.uvtData.push(u, v, 1);
					
					// The winding for a path is either positive (clockwise)
					//   ___
					// 0|  /|1
					//  | / |
					// 3|/__|2
					//
					if (j > 0)
					{
						if (i < segmentW_1)
						{
							triangles.indices.push(k, k + segmentH, k + segmentH - 1);
							triangles.indices.push(k, k + segmentH - 1, k - 1);
						}
					}
					++k;
				}
			}
			buildFaces(material);
		}
	}
}
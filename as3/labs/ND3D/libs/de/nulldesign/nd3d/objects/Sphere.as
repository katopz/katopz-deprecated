package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.UV;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;	

	/**
	 * A sphere
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class Sphere extends Mesh 
	{
		public function Sphere(steps:uint, size:Number, mat:Material, hemisphereOnly:Boolean = false) 
		{
			createSphere(steps, size, mat, hemisphereOnly);
		}

		private function createSphere(steps:uint, size:Number, mat:Material, hemisphereOnly:Boolean):void
		{
			var v:Vertex;
			var col:Array = [];
			var row:Array;
			var i:Number;
			var j:Number;
			var hStep:Number;
			var curSize:Number;
			var vStep:Number;
			var x:Number;
			var y:Number;
			var z:Number;
			var hSteps:int = hemisphereOnly ? (steps / 2 + 1) : steps;
			
			for(i = 0;i < steps + 1; i++) 
			{
				
				row = [];
				hStep = (i / steps);
				z = size * Math.cos(hStep * Math.PI);
				curSize = size * Math.sin(hStep * Math.PI);
				
				for (j = 0;j < hSteps; j++) 
				{
					
					vStep = (2 * j / steps);
					x = curSize * Math.sin(vStep * Math.PI);
					y = curSize * Math.cos(vStep * Math.PI);
					
					if(!((i == 0 || i == steps) && j > 0)) 
					{
						v = new Vertex(x, y, z);
					}
					row.push(v);
				}
				
				col.push(row);
			}

			var v1:Vertex;
			var v2:Vertex;
			var v3:Vertex;
			var v4:Vertex;
			var uv1:UV;
			var uv2:UV;
			var uv3:UV;
			var uv4:UV;

			for(i = 0;i < col.length; i++) 
			{
				if(i > 0) 
				{
					for(j = 0;j < col[i].length; j++) 
					{

						if (j == 0) 
						{
							v2 = col[i][col[i].length - 1];
							v3 = col[i - 1][col[i].length - 1];
						} 
						else 
						{
							v2 = col[i][j - 1];
							v3 = col[i - 1][j - 1];
						}

						if(j == col[i].length) 
						{
							v1 = col[i][0];
							v4 = col[i - 1][0];
						} 
						else 
						{
							v1 = col[i][j];
							v4 = col[i - 1][j];
						}
						
						uv1 = new UV((j + 1) / col[j].length, i / col.length);
						uv2 = new UV(j / col[j].length, i / col.length);
						uv3 = new UV(j / col[j].length, (i - 1) / col.length);
						uv4 = new UV((j + 1) / col[j].length, (i - 1) / col.length);
						
						// flip uv coordianates, otherwise the texture is flipped
						uv1.u = 1 - uv1.u;
						uv2.u = 1 - uv2.u;
						uv3.u = 1 - uv3.u;
						uv4.u = 1 - uv4.u;
						
						// add faces
						if(hemisphereOnly)
						{
							if(i < col.length - 1 && j > 0) 
							{
								addFace(v1, v2, v3, mat, [uv1, uv2, uv3]);
							}
							
							if(i > 1 && j > 0) 
							{
								addFace(v1, v3, v4, mat, [uv1, uv3, uv4]);
							}
						}
						else
						{
							if(i < col.length - 1) 
							{
								addFace(v1, v2, v3, mat, [uv1, uv2, uv3]);
							}
							
							if(i > 1) 
							{
								addFace(v1, v3, v4, mat, [uv1, uv3, uv4]);
							}
						}
						
						
					}
				}
			}
		}
	}
}
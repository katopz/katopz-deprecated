package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.geom.UV;
	import de.nulldesign.nd3d.material.Material;
	
	/**
	 *  Hunan University of China(湖南大学)
	 * @author FlyingWind (戴意愿)  (falwujn@163.com)
	 * @link  http://colorfuldiary.blog.163.com
	 * 2009/06/04
	 * 
	 */
	public class CylindricalSurface extends Mesh
	{
		/**
		 * 
		 * @param	material: 
		 * @param	radius: 
		 * @param	center: 顶面中心
		 * @param	height: 高度
		 * @param	steps: detaillevel (radial direction)
		 * @param	plane: (1:x-y plane, 2:y-z plane, 3:z-x plane)
		 
		 */
		public function CylindricalSurface(material:Material, radius:Number, center:Vertex, height:Number, steps:Number = 1, plane:int = 1 )
		{
			super();
			if (plane<1 || plane >3) plane =1;
			createSurface(material, radius, center, height, steps, plane);
		}
		
		private function createSurface(material:Material, radius:Number, center:Vertex, height:Number, steps:Number, plane:int):void 
		{
			var ratio:Number = 1 /(6 * steps);
			var angle:Number = Math.PI / (3 * steps);//do not change it
			var ar:Array = [];//two demension array
			var uvs:Array = [];
			var heightSteps:Number = int(height / (2 * Math.PI * radius * ratio));
			var heightRatio:Number = 1 / heightSteps;
			
			var i:int;
			var j:int;
			//create Vertexs
			switch(plane) 
			{
				//x-y plane
				case 1:
											
					ar.push([]);
					uvs.push([]);
					for ( j = 0; j < 6 * steps; j++)
					{
						var xx:Number = radius * Math.cos(j * angle);
						var yy:Number = radius * Math.sin(j * angle);
						ar[0].push(new Vertex(xx, yy, 0));
						uvs[0].push(new UV(ratio * j, 0));
					}
					ar[0].push(Vertex(ar[0][0]).clone());
					uvs[0].push(UV(uvs[0][0]).clone());
					
					for (i = 1; i <= heightSteps; i++)
					{
						ar.push([]);
						uvs.push([]);
						for ( j = 0; j <= 6 * steps; j++)
						{
							ar[i].push(new Vertex(Vertex(ar[i - 1][j]).x, Vertex(ar[i - 1][j]).y, height * i * heightRatio));
							uvs[i].push(new UV(UV(uvs[i - 1][j]).u, i * heightRatio));
						}
					}					
					break ;
				//y-z planes
				case 2:
					ar.push([]);
					uvs.push([]);
					for ( j = 0; j < 6 * steps; j++)
					{
						var xx1:Number = radius * Math.cos(j * angle);
						var yy1:Number = radius * Math.sin(j * angle);
						ar[0].push(new Vertex(0, xx1, yy1));
						uvs[0].push(new UV(ratio * j, 0));
					}
					ar[0].push(Vertex(ar[0][0]).clone());
					uvs[0].push(UV(uvs[0][0]).clone());
					
					for (i = 1; i <= heightSteps; i++)
					{
						ar.push([]);
						uvs.push([]);
						for ( j = 0; j <= 6 * steps; j++)
						{
							ar[i].push(new Vertex(height * i * heightRatio,Vertex(ar[i - 1][j]).y, Vertex(ar[i - 1][j]).z));
							uvs[i].push(new UV(UV(uvs[i - 1][j]).u, i * heightRatio));
						}
					}
					break ;
				// z-x plane
				case 3:
						ar.push([]);
					uvs.push([]);
					for ( j = 0; j < 6 * steps; j++)
					{
						var xx2:Number = radius * Math.cos(j * angle);
						var yy2:Number = radius * Math.sin(j * angle);
						ar[0].push(new Vertex( yy2, 0, xx2));
						uvs[0].push(new UV(ratio * j, 0));
					}
					ar[0].push(Vertex(ar[0][0]).clone());
					uvs[0].push(UV(uvs[0][0]).clone());
					
					for (i = 1; i <= heightSteps; i++)
					{
						ar.push([]);
						uvs.push([]);
						for ( j = 0; j <= 6 * steps; j++)
						{
							ar[i].push(new Vertex(Vertex(ar[i - 1][j]).x, height * i * heightRatio, Vertex(ar[i - 1][j]).z));
							uvs[i].push(new UV(UV(uvs[i - 1][j]).u, i * heightRatio));
						}
					}
					break ;
				default: ;
			}
			
			//translation (if the center not the origin)
			if (center.x != 0 || center.y != 0 || center.z != 0) {
				for (var i0:int = 0; i0 <= heightSteps; i0++) 
				{
					for (var g:int = 0; g <= 6 * steps; g++) 
					{ 	 
						Vertex(ar[i0][g]).add(center);						
					}
				}
			}
			
			//add face
			for (i = 0; i < heightSteps; i++)
			{
				for (j = 0; j < 6 * steps; j++)
				{
					addFace(Vertex(ar[i][j]), Vertex(ar[i + 1][j]), Vertex(ar[i + 1][j + 1]), material, [UV(uvs[i][j]), UV(uvs[i + 1][j]), UV(uvs[i + 1][j + 1])]);
					addFace(Vertex(ar[i][j]), Vertex(ar[i + 1][j + 1]), Vertex(ar[i][j + 1]), material, [UV(uvs[i][j]), UV(uvs[i + 1][j + 1]), UV(uvs[i][j + 1])]);					
				}
			}
			
			//this.weldVertices();
			
		}
	}
	
}
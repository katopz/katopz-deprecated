package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.UV;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;
	
	
	/**
	 *  Hunan University of China(湖南大学)
	 * @author FlyingWind (戴意愿)  (falwujn@163.com)
	 * @link  http://colorfuldiary.blog.163.com
	 * 2009/06/04
	 */
	public class CircleFace extends Mesh
	{
		/**
		 * 
		 * @param	material: Material for circle surface
		 * @param	radius: radius of circle
		 * @param	center: the center of circle
		 * @param	steps: detaillevel (radial direction)
		 * @param	plane: (1:x-y plane, 2:y-z plane, 3:z-x plane)
		 
		 */
		public function CircleFace(material:Material, radius:Number, center:Vertex, steps:Number = 1, plane:int = 1 )
		{
			super();
			//if (steps < 3) steps = 3;
			if (plane<1 || plane >3) plane =1;
			createCircleFace(material, radius, steps, plane, center);
		}
		
		private function createCircleFace(material:Material, radius:Number, steps:Number, plane:int, center:Vertex):void 
		{
			var ratio:Number = radius / steps;
			var angle:Number = Math.PI / 3;//do not change it
			var ar:Array = [];//two demension array
			var uvs:Array = [];
			
			var i:int;
			var j:int;
			//create Vertexs
			switch(plane) 
			{
				//x-y plane
				case 1:
					for ( i = 1; i <= steps; i++)
					{
						ar.push([]);
						uvs.push([]);
						for ( j = 0; j < 6 * i; j++)
						{
							var xx:Number = i * ratio * Math.cos(j * angle / i);
							var yy:Number = i * ratio * Math.sin(j * angle / i);
							ar[i - 1].push(new Vertex(xx, yy, 0));
							uvs[i - 1].push(new UV( ((xx/ radius)/2)+0.5, ((yy / radius)/2)+0.5));
						}
						ar[i - 1].push(Vertex(ar[i - 1][0]).clone());
						uvs[i - 1].push(UV(uvs[i-1][0]).clone());
					}
					break ;
				//y-z planes
				case 2:
					for (i = 1; i <= steps; i++)
					{
						ar.push([]);
						uvs.push([]);
						for (j = 0; j < 6 * i; j++)
						{
							var xx1:Number = i * ratio * Math.cos(j * angle / i);
							var yy1:Number = i * ratio * Math.sin(j * angle / i);
							ar[i - 1].push(new Vertex(0, xx1, yy1));
							uvs[i - 1].push(new UV( ((xx1/ radius)/2)+0.5, ((yy1 / radius)/2)+0.5));
						}
						ar[i - 1].push(Vertex(ar[i - 1][0]).clone());
						uvs[i - 1].push(UV(uvs[i-1][0]).clone());						
					}
					break ;
				// z-x plane
				case 3:
					for ( i = 1; i <= steps; i++)
					{
						ar.push([]);
						uvs.push([]);
						for ( j = 0; j < 6 * i; j++)
						{
							var xx2:Number = i * ratio * Math.sin(j * angle / i);
							var yy2:Number = i * ratio * Math.cos(j * angle / i);
							ar[i - 1].push(new Vertex(xx2, 0, yy2));
							uvs[i - 1].push(new UV( ((xx2/ radius)/2)+0.5, ((yy2 / radius)/2)+0.5));
						}
						ar[i - 1].push(Vertex(ar[i - 1][0]).clone());
						uvs[i - 1].push(UV(uvs[i-1][0]).clone());
					}
					break ;
				default: ;
			}
			
			//translation (if the center not the origin)
			if (center.x != 0 || center.y != 0 || center.z != 0) {
				for (var i0:int = 0; i0 < steps; i0++) 
				{
					for (var g:int = 0; g <= 6 * (i0 +1); g++) 
					{ 	 
						Vertex(ar[i0][g]).add(center);
						
					}
				}
			}
			
			//add faces
			
			for (var k:int = 0; k < steps; k++)
			{
				var count:int = 0;//周期读数器（60度一个周期）用于修正顶点号，k>0时使用
				for (var q:int = 0; q < (k + 1) * 6;)
				{
					if (k == 0)
					{
						addFace(center, Vertex(ar[k][q]), Vertex(ar[k][q + 1]), material, [new UV(0.5, 0.5), UV(uvs[k][q]), UV(uvs[k][q + 1])]);
						q++;
					}else {
						var bf:int = k * count;//周期内部修正顶点辅助变量
						addFace(Vertex(ar[k - 1][bf]), Vertex(ar[k][q]), Vertex(ar[k][q + 1]), material,  [ UV(uvs[k - 1][bf]), UV(uvs[k][q]), UV(uvs[k][q + 1])]);
						q++;
						var temp:int = k;
						while (temp>0) {							
							addFace(Vertex(ar[k][q]), Vertex(ar[k - 1][bf + 1]), Vertex(ar[k - 1][bf]), material, [UV(uvs[k][q]), UV(uvs[k - 1][bf + 1]), UV(uvs[k - 1][bf])]);
							addFace(Vertex(ar[k][q]), Vertex(ar[k][q + 1]), Vertex(ar[k - 1][bf + 1]), material, [UV(uvs[k][q]), UV(uvs[k][q + 1]), UV(uvs[k - 1][bf + 1]) ]);
							q++;
							temp--;
							bf++;
						}
						count++;
						
					}
				}
				
			}
			//Welds vertices that are close together 
			//this.weldVertices();
			
		}
				
	}
	
}


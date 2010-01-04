/**
 * ...
 * @author Default
 * @version 0.1
 */

package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.UV;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;	

	public class Ribbon extends Mesh 
	{

		private var controlPoints:Array;
		public var speed:Number;
		public var width:Number;
		public var material:Material;

		public function Ribbon(speed:Number = 0.1, detailLevel:uint = 10, width:uint = 2, material:Material = null) 
		{
			super();
			
			this.speed = speed;
			this.material = material;
			this.width = width;
			
			controlPoints = [];
			for(var i:Number = 0;i < detailLevel; i++) 
			{
				controlPoints.push(new Vertex(0, 0, 0));
			}

			createRibbon();
		}

		public function continueTo(xPos:Number, yPos:Number, zPos:Number):void 
		{

			for(var i:Number = 0;i < controlPoints.length; i++) 
			{
				
				var controlVertex:Vertex = controlPoints[i];
				var previousVertex:Vertex = controlPoints[i - 1];
				
				//move controlpoint
				if(i == 0) 
				{
					controlVertex.x = xPos;
					controlVertex.y = yPos;
					controlVertex.z = zPos;
				} 
				else 
				{
					controlVertex.x += (previousVertex.x - controlVertex.x) * speed;
					controlVertex.y += (previousVertex.y - controlVertex.y) * speed;
					controlVertex.z += (previousVertex.z - controlVertex.z) * speed;
				}
				
				var v1:Vertex = vertexList[2 * i];
				var v2:Vertex = vertexList[2 * i + 1];
				
				v1.x = controlVertex.x + width;
				v1.y = controlVertex.y + width;
				v1.z = controlVertex.z + width;
				
				v2.x = controlVertex.x - width;
				v2.y = controlVertex.y - width;
				v2.z = controlVertex.z - width;
			}
		}

		private function createRibbon():void 
		{

			vertexList = [];
			
			for(var i:Number = 0;i < controlPoints.length; i++) 
			{
				
				var controlVertex:Vertex = controlPoints[i];
				
				var v1:Vertex = new Vertex(controlVertex.x, controlVertex.y, controlVertex.z);
				var v2:Vertex = new Vertex(controlVertex.x, controlVertex.y, controlVertex.z);
				
				vertexList.push(v1, v2);
				
				if(i > 0) 
				{

					var lastVIndex:uint = vertexList.length - 1;
					
					var uvStart:Number = i * (1 / controlPoints.length);
					var uvEnd:Number = (i + 1) * (1 / controlPoints.length);
					;
					
					var uv0:UV = new UV(0, uvStart);
					var uv1:UV = new UV(0, uvEnd);
					var uv2:UV = new UV(1, uvStart);
					var uv3:UV = new UV(1, uvEnd);

					var uvAr1:Array = [uv2, uv0, uv1];
					var uvAr2:Array = [uv2, uv1, uv3];
	
					addFace(vertexList[lastVIndex - 2], vertexList[lastVIndex - 3], vertexList[lastVIndex - 1], material, uvAr1);
					addFace(vertexList[lastVIndex - 2], vertexList[lastVIndex - 1], vertexList[lastVIndex], material, uvAr2);
				}
			}
		}
	}
}

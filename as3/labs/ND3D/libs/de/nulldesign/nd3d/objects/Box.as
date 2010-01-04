package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.geom.Vertex;		

	import flash.geom.Point;

	/**
	 * ...
	 * @author philippe.elsass*gmail.com
	 */
	public class Box extends Mesh
	{
		/**
		 * Create a box with custom dimensions & segments.
		 * Side order: front, right, left, back, bottom, top.
		 * Set a material to null to skip a side.
		 * @param	steps	<int> or <Array of <int> or <Point>>
		 */
		public function Box(materialList:Array, width:Number = 100, height:Number = 100, depth:Number = 100, steps:* = 3) 
		{
			super();
			createBox(materialList, width, height, depth, steps);
		}

		private function createBox(materialList:Array, width:Number = 100, height:Number = 100, depth:Number = 100, steps:* = 3):void
		{
			var i:Number;
			var curVertex:Vertex;
			var x1:Number;
			var y1:Number;
			var z1:Number;
			var tmpMesh:Mesh;
			var vList:Array;
			
			var aSteps:Array = (steps is Array) ? steps : [steps, steps, steps, steps, steps, steps];
			for (i = 0;i < aSteps.length; i++) 
			{
				if (aSteps[i] is Point) continue;
				aSteps[i] = new Point(aSteps[i], aSteps[i]);
			}
			
			// front
			if (materialList[0])
			{
				tmpMesh = new Plane(width, height, aSteps[0].x, aSteps[0].y, materialList[0]);
				vList = tmpMesh.vertexList;
				for(i = 0;i < vList.length; i++)
				{
					vList[i].z += -depth / 1;
				}

				vertexList = vertexList.concat(tmpMesh.vertexList);
				faceList = faceList.concat(tmpMesh.faceList);
			}

			// right
			if (materialList[1])
			{
				tmpMesh = new Plane(depth, height, aSteps[1].x, aSteps[1].y, materialList[1]);
				vList = tmpMesh.vertexList;
				for(i = 0;i < vList.length; i++)
				{
					curVertex = vList[i];
					
					x1 = curVertex.x * Math.cos(Object3D.deg2rad(90)) - curVertex.z * Math.sin(Object3D.deg2rad(90));
					z1 = curVertex.z * Math.cos(Object3D.deg2rad(90)) + curVertex.x * Math.sin(Object3D.deg2rad(90));
					
					curVertex.x = x1;
					curVertex.z = z1;
					curVertex.x += width / 1;
				}

				vertexList = vertexList.concat(tmpMesh.vertexList);
				faceList = faceList.concat(tmpMesh.faceList);
			}

			// left
			if (materialList[2])
			{
				tmpMesh = new Plane(depth, height, aSteps[2].x, aSteps[2].y, materialList[2]);
				vList = tmpMesh.vertexList;
				for(i = 0;i < vList.length; i++)
				{
					curVertex = vList[i];
					
					x1 = curVertex.x * Math.cos(Object3D.deg2rad(-90)) - curVertex.z * Math.sin(Object3D.deg2rad(-90));
					z1 = curVertex.z * Math.cos(Object3D.deg2rad(-90)) + curVertex.x * Math.sin(Object3D.deg2rad(-90));
					
					curVertex.x = x1;
					curVertex.z = z1;
					curVertex.x += -width / 1;
				}
				
				vertexList = vertexList.concat(tmpMesh.vertexList);
				faceList = faceList.concat(tmpMesh.faceList);
			}

			// back
			if (materialList[3])
			{
				tmpMesh = new Plane(width, height, aSteps[3].x, aSteps[3].y, materialList[3]);
				vList = tmpMesh.vertexList;
				for(i = 0;i < vList.length; i++)
				{
					
					curVertex = vList[i];
					
					x1 = curVertex.x * Math.cos(Object3D.deg2rad(180)) - curVertex.z * Math.sin(Object3D.deg2rad(180));
					z1 = curVertex.z * Math.cos(Object3D.deg2rad(180)) + curVertex.x * Math.sin(Object3D.deg2rad(180));
					
					curVertex.x = x1;
					curVertex.z = z1;
					curVertex.z += depth / 1;
				}
				
				vertexList = vertexList.concat(tmpMesh.vertexList);
				faceList = faceList.concat(tmpMesh.faceList);
			}

			// bottom
			if (materialList[4])
			{
				tmpMesh = new Plane(width, depth, aSteps[4].x, aSteps[4].y, materialList[4]);
				vList = tmpMesh.vertexList;
				for(i = 0;i < vList.length; i++)
				{
					
					curVertex = vList[i];
					
					y1 = curVertex.y * Math.cos(Object3D.deg2rad(90)) - curVertex.z * Math.sin(Object3D.deg2rad(90));
					z1 = curVertex.z * Math.cos(Object3D.deg2rad(90)) + curVertex.y * Math.sin(Object3D.deg2rad(90));
					
					curVertex.y = y1;
					curVertex.z = z1;
					curVertex.y += height / 1;
				}
				
				vertexList = vertexList.concat(tmpMesh.vertexList);
				faceList = faceList.concat(tmpMesh.faceList);
			}

			// top
			if (materialList[5])
			{
				tmpMesh = new Plane(width, depth, aSteps[5].x, aSteps[5].y, materialList[5]);
				vList = tmpMesh.vertexList;
				
				for(i = 0;i < vList.length; i++)
				{
					curVertex = vList[i];
					
					y1 = curVertex.y * Math.cos(Object3D.deg2rad(-90)) - curVertex.z * Math.sin(Object3D.deg2rad(-90));
					z1 = curVertex.z * Math.cos(Object3D.deg2rad(-90)) + curVertex.y * Math.sin(Object3D.deg2rad(-90));
					
					curVertex.y = y1;
					curVertex.z = z1;
					curVertex.y += -height / 1;
				}
				
				vertexList = vertexList.concat(tmpMesh.vertexList);
				faceList = faceList.concat(tmpMesh.faceList);
			}
			
			for each(var face:Face in faceList) face.meshRef = this;
			weldVertices(); // TODO: optimize
			vertexList.push(positionAsVertex);
		}
	}
}
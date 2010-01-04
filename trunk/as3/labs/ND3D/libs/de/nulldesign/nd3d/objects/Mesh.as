package de.nulldesign.nd3d.objects 
{
	import flash.utils.Dictionary;

	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.geom.UV;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Object3D;	
	
	/**
	 * Basic object for every 3d object that contains faces
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class Mesh extends Object3D 
	{
		public function Mesh() 
		{
			super();
		}
		/**
		 * Adds a new face to the mesh
		 * @param	first vertex
		 * @param	second vertex
		 * @param	third vertex
		 * @param	material
		 * @param	array containing exactly three UV coordinates
		 */
		public function addFace(v1:Vertex, v2:Vertex, v3:Vertex, material:Material = null, uvList:Array = null):void 
		{
			faceList.push(new Face(this, v1, v2, v3, material, uvList));
			if(!vertexInList(v1)) vertexList.push(v1);
			if(!vertexInList(v2)) vertexList.push(v2);
			if(!vertexInList(v3)) vertexList.push(v3);
		}
		/**
		 * Checks if a mesh already contains a vertex
		 * @param vertex to check
		 * @return
		 */
		public function vertexInList(v:Vertex):Boolean 
		{
			for(var i:Number = 0;i < vertexList.length; i++) 
			{
				if(vertexList[i] == v) 
				{
					return true;
				}
			}
			return false;
		}
		/**
		 * Welds vertices that are close together
		 * @param tolerance
		 */
		public function weldVertices(tolerance:Number = 1):void	
		{
			//trace("before: " + vertexList.length);

			var i:uint;
			var uniqueList:Dictionary = new Dictionary();
			var v:Vertex;
			var uniqueV:Vertex;
			var f:Face;
			
			// fill unique listing
			for(i = 0;i < vertexList.length; i++) 
			{
				v = vertexList[i];
				uniqueList[v] = v;
			}
			
			// step through vertices and find duplicates vertices
			for(i = 0;i < vertexList.length; i++) 
			{
				
				v = vertexList[i];
				
				for each(uniqueV in uniqueList) 
				{
					
					if(	Math.abs(v.x - uniqueV.x) <= tolerance && Math.abs(v.y - uniqueV.y) <= tolerance && Math.abs(v.z - uniqueV.z) <= tolerance) 
					{
						
						uniqueList[v] = uniqueV; // replace vertice with unique one
					}
				}
			}
			
			vertexList = [];
			
			for each(f in faceList)	
			{
				f.v1 = uniqueList[f.v1];
				f.v2 = uniqueList[f.v2];
				f.v3 = uniqueList[f.v3];
				
				if(!vertexInList(f.v1)) vertexList.push(f.v1);
				if(!vertexInList(f.v2)) vertexList.push(f.v2);
				if(!vertexInList(f.v3)) vertexList.push(f.v3);
			}
			
			//trace("after: " + vertexList.length);
		}

		/**
		 * Flips the normals of every face in the mesh
		 */
		public function flipNormals():void 
		{
			
			var curFace:Face;
			
			for(var i:Number = 0;i < faceList.length; i++) 
			{
				curFace = faceList[i];
				
				var tmpVertex:Vertex = curFace.v1;
				curFace.v1 = curFace.v2;
				curFace.v2 = tmpVertex;

				var tmpUV:UV = curFace.uvMap[0];
				curFace.uvMap[0] = curFace.uvMap[1];
				curFace.uvMap[1] = tmpUV;
				/*
				for (var j:uint = 0; j < curFace.uvMap.length; j++)
				{
					tmpUV = curFace.uvMap[j];
					tmpUV.u = 1 - tmpUV.u;
					//tmpUV.v = 1 - tmpUV.v;
				}*/
			}
		}

		/**
		 * Clones the mesh
		 * @return new cloned mesh
		 */
		public function clone():Mesh 
		{
			var m:Mesh = new Mesh();

			m.angleX = angleX;
			m.angleY = angleY;
			m.angleZ = angleZ;
			m.deltaAngleX = deltaAngleX;
			m.deltaAngleY = deltaAngleY;
			m.deltaAngleZ = deltaAngleZ;
			m.direction = direction.clone();
			m.quaternion = quaternion.copy();
			m.xPos = xPos;
			m.yPos = yPos;
			m.zPos = zPos;
			m.vertexList = [];
			m.faceList = [];
			
			for(var i:uint = 0;i < faceList.length; i++) 
			{
				var tmpFace:Face = faceList[i];
				
				var tmpV1:Vertex = tmpFace.v1.clone();
				var tmpV2:Vertex = tmpFace.v2.clone();
				var tmpV3:Vertex = tmpFace.v3.clone();
				
				if(!m.vertexInList(tmpV1)) 
				{
					m.vertexList.push(tmpV1);
				}
				if(!m.vertexInList(tmpV2)) 
				{
					m.vertexList.push(tmpV2);
				}
				if(!m.vertexInList(tmpV3)) 
				{
					m.vertexList.push(tmpV3);
				}

				//uv
				var tmpUVMap:Array = [];
				for(var j:uint = 0;j < tmpFace.uvMap.length; j++) 
				{
					var tmpUV:UV = tmpFace.uvMap[j];
					tmpUVMap.push(tmpUV.clone());
				}
				
				var newFace:Face = new Face(m, tmpV1, tmpV2, tmpV3, tmpFace.material.clone(), tmpUVMap);
				m.faceList.push(newFace);
			}

			return m;
		}
	}
}

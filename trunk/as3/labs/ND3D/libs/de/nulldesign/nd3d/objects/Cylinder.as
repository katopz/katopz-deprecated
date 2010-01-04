package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.geom.Face;
	
	/**
	 * ...
	 * @author FlyingWind (戴意愿)
	 * @link  http://colorfuldiary.blog.163.com
	 */
	public class Cylinder extends Mesh
	{
		/**
		 * 
		 * @param	materialList: list of materials for every face of the cylinder（side，top，bottom)
		 * @param	radius: Radius of cylinder
		 * @param	center:顶面中心
		 * @param	height:   
		 * @param	steps: detaillevel
		 * @param	axis:轴线方向 （1：z_axis, 2:x_axis, 3:y_axis);
		 */
		public function Cylinder(materialList:Array, radius:Number , center:Vertex, height:Number =100, steps:Number = 3, axis:int=1) 
		{
			super();
			if (axis<1 || axis>3) axis=1;
			createCylinder(materialList, radius, center, height,steps,axis);
		}
		
		private function createCylinder(materialList:Array, radius:Number, center:Vertex, height:Number, steps:Number, axis:int):void 
		{
	 
			var tempMesh :Mesh = new CylindricalSurface(materialList[0], radius, center, height, steps, axis);
			vertexList = vertexList.concat(tempMesh.vertexList);
			faceList = faceList.concat(tempMesh.faceList);			
			
			//top
			tempMesh = new CircleFace(materialList[1], radius, center, steps, axis);
			vertexList = vertexList.concat(tempMesh.vertexList);
			faceList = faceList.concat(tempMesh.faceList);
			
			//bottom
			var temp:Vertex;
			switch(axis) 
			{
				case 1://z_axis
					temp = new Vertex(0, 0, height);
					break;
				case 2://x_axis
					temp = new Vertex(height, 0, 0);
					break;
				case 3://y_axis
					temp = new Vertex(0, height, 0);
					break;
			}
			temp.add(center);
			tempMesh = new CircleFace(materialList[2], radius, temp, steps, axis);
			vertexList = vertexList.concat(tempMesh.vertexList);
			faceList = faceList.concat(tempMesh.faceList);
			
			// weldVertices();
	 
			/* for(var i:int = 0;i < faceList.length; i++)
			 {
				 var f:Face = faceList[i] as Face;
				 f.meshRef = this;
			 }
			 
			 vertexList.push(positionAsVertex);*/
			 
		}
		
	}
	
}
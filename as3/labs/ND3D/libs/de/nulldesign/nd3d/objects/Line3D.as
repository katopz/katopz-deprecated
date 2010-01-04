package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.Face;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.LineMaterial;
	import de.nulldesign.nd3d.material.Material;	

	/**
	 * Line3D, a simple 3d line between two vertices
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class Line3D extends Mesh 
	{
		public function Line3D(v0:Vertex, v1:Vertex, material:LineMaterial = null) 
		{
			super();
			
			vertexList.push(v0);
			vertexList.push(v1);
			
			material = material ? material : new LineMaterial(0xFFFFFF);
			
			positionAsVertex = v1;
			
			faceList.push(new Face(this, v0, v1, v1, material, null));
		}
	}
}

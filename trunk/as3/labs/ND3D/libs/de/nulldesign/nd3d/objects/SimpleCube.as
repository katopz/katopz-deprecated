package de.nulldesign.nd3d.objects 
{
	import de.nulldesign.nd3d.geom.UV;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;	

	/**
	 * A simple cube with 12 faces
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class SimpleCube extends Mesh
	{

		public function SimpleCube(material:Material, size:uint = 50) 
		{
			var v0:Vertex = new Vertex(-size, -size, -size);
			var v1:Vertex = new Vertex(size, -size, -size);
			var v2:Vertex = new Vertex(size, size, -size);
			var v3:Vertex = new Vertex(-size, size, -size);
			var v4:Vertex = new Vertex(-size, -size, size);
			var v5:Vertex = new Vertex(size, -size, size);
			var v6:Vertex = new Vertex(size, size, size);
			var v7:Vertex = new Vertex(-size, size, size);
			// front
			addFace(v0, v2, v1, material, [new UV(0, 0), new UV(1, 1), new UV(1, 0)]);
			addFace(v0, v3, v2, material, [new UV(0, 0), new UV(0, 1), new UV(1, 1)]);
			// top
			addFace(v0, v1, v5, material, [new UV(0, 0), new UV(1, 0), new UV(1, 1)]);
			addFace(v0, v5, v4, material, [new UV(0, 0), new UV(1, 1), new UV(0, 1)]);
			// back
			addFace(v4, v5, v6, material, [new UV(0, 0), new UV(0, 1), new UV(1, 1)]);
			addFace(v4, v6, v7, material, [new UV(0, 0), new UV(1, 1), new UV(1, 0)]);
			// bottom
			addFace(v3, v6, v2, material, [new UV(0, 0), new UV(1, 1), new UV(1, 0)]);
			addFace(v3, v7, v6, material, [new UV(0, 0), new UV(0, 1), new UV(1, 1)]);
			// right
			addFace(v1, v6, v5, material, [new UV(0, 0), new UV(1, 1), new UV(0, 1)]);
			addFace(v1, v2, v6, material, [new UV(0, 0), new UV(1, 0), new UV(1, 1)]);
			// left
			addFace(v4, v3, v0, material, [new UV(0, 0), new UV(1, 1), new UV(0, 1)]);
			addFace(v4, v7, v3, material, [new UV(0, 0), new UV(1, 0), new UV(1, 1)]);
		}
	}
}
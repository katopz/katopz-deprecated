package de.nulldesign.nd3d.geom 
{
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Object3D;	
	/**
	 * A face, the basic object of every 3D mesh. Every face has a reference to it's corresponding mesh (meshRef)
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class Face 
	{
		public var meshRef:Object3D;
		public var material:Material;
		public var v1:Vertex;
		public var v2:Vertex;
		public var v3:Vertex;
		public var vertexList:Array;
		public var uvMap:Array;
		/**
		 * Constructor of a Face
		 * @param	reference to the mesh
		 * @param	first vertex
		 * @param	second vertex
		 * @param	third vertex
		 * @param	material
		 * @param	UV map for bitmap textures
		 */
		public function Face(meshRef:Object3D, v1:Vertex, v2:Vertex, v3:Vertex, material:Material = null, uvMap:Array = null) 
		{
			this.meshRef = meshRef;
			this.v1 = v1;
			this.v2 = v2;
			this.v3 = v3;
			this.material = material;
			this.uvMap = uvMap;

			vertexList = [v1, v2, v3];
		}

		public function getNormal():Vertex
		{
			var ab:Vertex;
			var ac:Vertex;
			var n:Vertex;
			
			ab = new Vertex(v2.x - v1.x, v2.y - v1.y, v2.z - v1.z);
			ac = new Vertex(v3.x - v1.x, v3.y - v1.y, v3.z - v1.z);
			
			n = ac.cross(ab);
			n.normalize();
			return n;
		}
		
		public function toString():String 
		{
			return "Face: " + v1 + "/" + v2 + "/" + v3 + "\n";
		}
	}
}

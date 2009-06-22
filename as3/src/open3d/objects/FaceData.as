package open3d.objects
{
	import flash.geom.Vector3D;
	
	/**
	 * A face, the basic object of every 3D mesh. Every face has a reference to it's corresponding mesh (meshRef)
	 * @author Lars Gerckens (lars@nulldesign.de)
	 */
	public class FaceData
	{
		//public var meshRef:Object3D;
		//public var material:Material;
		
		public var a:int;
		public var b:int;
		public var c:int;
		
		public var v1:Vector3D;
		public var v2:Vector3D;
		public var v3:Vector3D;
		public var Vector3DList:Array;
		public var uvMap:Array;
		/**
		 * Constructor of a Face
		 * @param	reference to the mesh
		 * @param	first Vector3D
		 * @param	second Vector3D
		 * @param	third Vector3D
		 * @param	material
		 * @param	UV map for bitmap textures
		 */
		public function FaceData(a:Number,b:Number,c:Number,v1:Vector3D, v2:Vector3D, v3:Vector3D, uvMap:Array = null) 
		{
			this.a = a;
			this.b = b;
			this.c = c;
			//this.meshRef = meshRef;
			this.v1 = v1;
			this.v2 = v2;
			this.v3 = v3;
			//this.material = material;
			this.uvMap = uvMap;

			Vector3DList = [v1, v2, v3];
		}

		public function getNormal():Vector3D
		{
			var ab:Vector3D;
			var ac:Vector3D;
			var n:Vector3D;
			
			ab = new Vector3D(v2.x - v1.x, v2.y - v1.y, v2.z - v1.z);
			ac = new Vector3D(v3.x - v1.x, v3.y - v1.y, v3.z - v1.z);
			
			n = ac.crossProduct(ab);
			n.normalize();
			return n;
		}
		
		public function toString():String 
		{
			return "Face: " + v1 + "/" + v2 + "/" + v3 + "\n";
		}
	}
}

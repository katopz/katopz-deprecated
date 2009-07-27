package open3d.materials.shaders 
{

	import flash.display.BitmapData;
	import open3d.geom.Vertex;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.display.IGraphicsData;
	import open3d.objects.Light;
	import open3d.materials.BitmapMaterial;
	/**
	 * @author kris
	 */
	public class PhongMaterial extends BitmapMaterial implements IShader 
	{

		
	
		private var _light : Light;
		private var normals : Vector.<Vector3D>;
		private var vertices : Vector.<Vertex>;
		private var _verticesIn : Vector.<Number>;
		private var faceNormals : Vector.<Vector3D>;

		public function  PhongMaterial(light : Light,bitmapData : BitmapData) 
		{
			
			
			_light = light;
		
		
			
			
			
			super(bitmapData);
		}

	
		public 	function calculateNormals(verticesIn : Vector.<Number>,indices : Vector.<int>) : void 
		{
			if (faceNormals != null) return;
			
			_verticesIn =verticesIn;
			var trianglesLength : int = indices.length / 3;
			faceNormals = new Vector.<Vector3D>(trianglesLength, true);
			vertices = new Vector.<Vertex>(_verticesIn.length / 3, true);
			
			var vec1 : Vector3D = new Vector3D();
			var vec2 : Vector3D = new Vector3D();
			var vec3 : Vector3D = new Vector3D();
			var ind1 : int;
			var ind2 : int;
			var ind3 : int;
			for (var i : int = 0;i < trianglesLength; i++) 
			{
				
				ind1 = indices[i * 3] * 3	;		
				vec1.x =_verticesIn[ind1];	
				vec1.y = _verticesIn[ind1 + 1];
				vec1.z =_verticesIn[ind1 + 2];
				
				ind2 = indices[i * 3 + 1] * 3;
				vec2.x = _verticesIn[ind2];	
				vec2.y = _verticesIn[ind2 + 1];
				vec2.z = _verticesIn[ind2 + 2];
				
				
				ind3 = indices[i * 3 + 2] * 3;
				vec3.x = _verticesIn[ind3];	
				vec3.y = _verticesIn[ind3 + 1];
				vec3.z = _verticesIn[ind3 + 2];
				
				
				var faceNormal : Vector3D = calculateNormal(vec1, vec2, vec3);
			
				faceNormals[i] = faceNormal;
				
				vertices[ind1/3] = addNormal(vertices[ind1/3], faceNormal);
				vertices[ind2/3 ] = addNormal(vertices[ind2/3], faceNormal);
				vertices[ind3/3] = addNormal(vertices[ind3/3], faceNormal);
			}
			calculateVertexNormals();
		}

		private function addNormal(v : Vertex, faceNormal : Vector3D) : Vertex 
		{
			if (v == null) v = new Vertex();
		
			v.addFaceNormal(faceNormal);
			return v;
		}

		private function calculateVertexNormals() : void 
		{
			for (var i : int = 0;i < vertices.length; i++) 
			{	
				vertices[i].calculateNormal();
			}
		}

		public function calculateNormal(vec1 : Vector3D,vec2 : Vector3D,vec3 : Vector3D) : Vector3D 
		{
			var normal : Vector3D = new Vector3D();
			var dif1 : Vector3D = vec2.subtract(vec1);
			var dif2 : Vector3D = vec3.subtract(vec1);
			normal = dif1.crossProduct(dif2);
			//normal.z *=-1
			normal.normalize();
			return normal;
		}

		
		
		public function getUVData(m : Matrix3D) : Vector.<Number> 
		{
			var uvData : Vector.<Number> = new Vector.<Number>();
			var projectedNormal : Vector3D ;
			
			var texCoord : Point = new Point(); 
			// projecting vertex normals
		
			for (var i : int = 0;i < vertices.length; i++) 
			{
				
				projectedNormal =vertices[i].normal//getProjectedNormal(m);
				
				
				calculateTexCoord(texCoord, projectedNormal,false);
				uvData.push(texCoord.x, texCoord.y, 1);
			}
			
			return uvData;
		}

		
		
		public function calculateTexCoord(texCoord : Point, normal : Vector3D,doubleSided : Boolean = false ) : void 
		{
			var v : Vector3D = _light.direction;
			texCoord.x = v.x * normal.x + v.y * normal.y + v.z * normal.z;
			if (texCoord.x < 0) texCoord.x = (doubleSided) ? -texCoord.x : 0;
			v = _light.halfVector;
			texCoord.y = v.x * normal.x + v.y * normal.y + v.z * normal.z;
			if (texCoord.y < 0) texCoord.y = (doubleSided) ? -texCoord.y : 0;
		}

		
		
		
		
		

		override public function update() : void 
		{
			graphicsData = Vector.<IGraphicsData>([_graphicsBitmapFill, triangles]);
			graphicsData.fixed = true;
			super.update();
		}
	}
}
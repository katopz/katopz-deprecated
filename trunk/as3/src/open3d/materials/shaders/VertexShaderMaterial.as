package open3d.materials.shaders 
{
	import open3d.objects.Light;

	import flash.display.BitmapData;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * @author kris@neuroproductions.be
	 */
	public class VertexShaderMaterial extends ShaderMaterial implements IShader 
	{
		public function VertexShaderMaterial(light : Light,bitmapData : BitmapData)
		{
			super(light, bitmapData);
		}

		override public function calculateNormals(verticesIn : Vector.<Number>,indices : Vector.<int>) : void
		{
		
			super.calculateNormals(verticesIn, indices);
			calculateVertexNormals();
			
		}

		
		
		private function calculateVertexNormals() : void 
		{
			for (var i : int = 0;i < vertices.length; i++) 
			{	
				vertices[i].calculateNormal();
			}
		}

		override public function getUVData(m : Matrix3D) : Vector.<Number>
		{
			var uvData : Vector.<Number> = new Vector.<Number>();
			var projectedNormal : Vector3D ;
			
			var texCoord : Point = new Point(); 
			// projecting vertex normals

			for (var i : int = 0;i < vertices.length; i++) 
			{
				
				projectedNormal = vertices[i].normal//getProjectedNormal(m);

				
				calculateTexCoord(texCoord, projectedNormal, false);
				uvData.push(texCoord.x, texCoord.y, 1);
			}
			
			return uvData;
		}

		
		
		protected function calculateTexCoord(texCoord : Point, normal : Vector3D,doubleSided : Boolean = false ) : void 
		{
			
			
		/*	var v : Vector3D = _light.direction;
			texCoord.x = v.x * normal.x + v.y * normal.y + v.z * normal.z;
			if (texCoord.x < 0) texCoord.x = (doubleSided) ? -texCoord.x : 0;
			v = _light.halfVector;
			texCoord.y = v.x * normal.x + v.y * normal.y + v.z * normal.z;
			if (texCoord.y < 0) texCoord.y = (doubleSided) ? -texCoord.y : 0;*/
		}
	}
}

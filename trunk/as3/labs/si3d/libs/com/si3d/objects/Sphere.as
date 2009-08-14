package open3d.objects 
{
	import __AS3__.vec.Vector;
	
	import flash.geom.Vector3D;
	
	import open3d.materials.Material;
	
	/**
	* @author senocular (Flash CS4 spinning globe example)
	* @link http://www.senocular.com/flash/source.php?id=1.201 
	*/
	public class Sphere extends Mesh
	{
		public function Sphere(radius:Number, parallels:int, meridians:int, material:Material):void 
		{
			if (parallels < 3) parallels = 3;
			if (meridians < 3) meridians = 3;
			meridians++; // texture edge meridian duplicated
			
			var parallelStops:int = parallels-1; // for determining u
			var meridianStops:int = meridians-1; // for determining v
			
			// local variables
			var r:Number; // radius
			var x:Number, y:Number, z:Number; // coordinates
			var p:int, pi:int, pa:Number; // parallel vars
			var m:int, mi:int, ma:Number; // meridian vars
			var u:Number, v:Number; // u, v of uvt
			var n:int = 0; // vertices index
			
			// horizontal
			for (p=0; p<parallels; p++)
			{
				v = p/parallelStops;
				pa = v*Math.PI - Math.PI/2;
				y = radius*Math.sin(pa);
				r = radius*Math.cos(pa);
				
				// vertical
				for (m=0; m<meridians; m++)
				{
					u = m/meridianStops;
					ma = u*Math.PI*2;
					x = r*Math.cos(ma);
					z = r*Math.sin(ma);
					
					// vertices
					vertices3D.push(x,y,z);
					
					// triangles
					triangles.uvtData.push(u, v, 1);
					
					if (m != 0){ // not first meridian (texture edge)
						if (p != parallelStops){ // not last parallel (no next parallel to connect)
							triangles.indices.push(n, n+meridians, n+meridians-1);
							triangles.indices.push(n, n+meridians-1, n-1);
						}
					}
					n++;
				}
			}
			vertices3D.fixed = true;
			
			buildFaces(material);
		}
		
		override protected function buildFaces(material:Material):void
		{
			var _indices:Vector.<int> = triangles.indices;
			var _indices_length:int = _indices.length / 3;
			
			faces = new Vector.<Vector.<Vector3D>>(_indices_length, true);
			
			var i1:Number, i2:Number, i3:Number;
			for (var i:int = 0; i < _indices_length; ++i)
			{
				var _3i:int = int(3 * i);
				i1 = _indices[_3i];
				i2 = _indices[int(_3i + 1)];
				i3 = _indices[int(_3i + 2)];
				
				var _face:Vector.<Vector3D> = faces[i] = new Vector.<Vector3D>(2, true);
				_face[0] = new Vector3D(i1, i2, i3);
				_face[1] = new Vector3D(3 * i1 + 2, 3 * i2 + 2, 3 * i3 + 2);
			}
			
			this.material = material;
			this.material.update();
		}
	}
}
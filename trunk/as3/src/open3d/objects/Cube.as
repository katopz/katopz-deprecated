package open3d.objects
{
	import __AS3__.vec.Vector;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix3D;
	
	import open3d.materials.BitmapMaterial;
	import open3d.materials.Material;
	
	/**
	 * Cube
	 * @author katopz
	 */
	public class Cube extends Mesh
	{
		public function Cube(materials:Vector.<Material>, size:Number = 100, steps:Number = 1) 
		{
			create(materials, size, steps);
			material = new BitmapMaterial(new BitmapData(100,100,true,0xCC000000));
			buildFaces(material);
			//flex bug
			new Material;
			
			culling = "none";
		}

		private function create(materials:Vector.<Material>, size:Number = 100, steps:Number = 1):void
		{
			var matrix3D:Matrix3D = new Matrix3D();
			var planes:Vector.<Plane> = new Vector.<Plane>();
			
			// front
			var frontPlane:Plane = new Plane(size, size, materials[0], steps, steps);
			frontPlane.transform.matrix3D.appendTranslation(0,0,size/2)
			frontPlane.transform.matrix3D.transformVectors(frontPlane.vin, frontPlane.vin);
			planes.push(frontPlane);
			
			// right
			var rightPlane:Plane = new Plane(size, size, materials[1], steps, steps);
			rightPlane.x = size/2;
			rightPlane.rotationY = 90;
			rightPlane.transform.matrix3D.transformVectors(rightPlane.vin, rightPlane.vin);
			planes.push(rightPlane);
			
			// left
			var leftPlane:Plane = new Plane(size, size, materials[2], steps, steps);
			leftPlane.x = -size/2;
			leftPlane.rotationY = -90;
			leftPlane.transform.matrix3D.transformVectors(leftPlane.vin, leftPlane.vin);
			planes.push(leftPlane);
			
			// back
			var backPlane:Plane = new Plane(size, size, materials[3], steps, steps);
			backPlane.transform.matrix3D.appendTranslation(0,0,-size/2)
			backPlane.transform.matrix3D.transformVectors(backPlane.vin, backPlane.vin);
			
			planes.push(backPlane);
			
			// bottom
			var bottomPlane:Plane = new Plane(size, size, materials[4], steps, steps);
			bottomPlane.y = -size/2;
			bottomPlane.rotationX = -90;
			bottomPlane.transform.matrix3D.transformVectors(bottomPlane.vin, bottomPlane.vin);
			planes.push(bottomPlane);

			// top
			var topPlane:Plane = new Plane(size, size, materials[4], steps, steps);
			topPlane.y = size/2;
			topPlane.rotationX = 90;
			topPlane.transform.matrix3D.transformVectors(topPlane.vin, topPlane.vin);
			planes.push(topPlane);
			
			// merge
			for each (var _plane:Plane in planes)
			{
				_vin = _vin.concat(_plane.vin);
				_triangles.uvtData = _triangles.uvtData.concat(_plane.triangles.uvtData);
				
				for (var i:int=0;i<_plane.triangles.indices.length;i++)
				{
					_plane.triangles.indices[i]=_plane.triangles.indices[i]+_triangles.indices.length/3;
				}
				_triangles.indices = _triangles.indices.concat(_plane.triangles.indices);
			}
		}
	}
}
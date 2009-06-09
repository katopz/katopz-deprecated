package
{
	import flash.geom.Vector3D;
	
	import open3d.geom.Face;
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Line3D;
	import open3d.objects.Plane;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;
	
	[SWF(width=800, height=600, backgroundColor=0x666666, frameRate=30)]
	
	/**
	 * ExFaceNormal
	 * @author katopz
	 */	
	public class ExFaceNormal extends SimpleView
	{
		private var sphere:Sphere;
		private var plane:Plane;
		private var lines:Vector.<Line3D>;
		
		override protected function create():void
		{
			plane = new Plane(256, 128, new BitmapFileMaterial("assets/sea01.jpg"), 10, 10);
			renderer.addChild(plane);
			plane.scaleX = plane.scaleY = plane.scaleZ = 2;
			plane.y = 100;
			plane.rotationX = -45;
			
			sphere = new Sphere(100, 10, 10, new BitmapFileMaterial("assets/earth.jpg"));
			renderer.addChild(sphere);
			
			renderer.isMeshZSort = false;
			renderer.isFaceDebug = true;
			
			/*
			lines = new Vector.<Line3D>();
			for each(var face:Face in plane.faces)
			{
				var line:Line3D = new Line3D(Vector.<Vector3D>
				([
					face.getN0(plane.vin), face.getN1(plane.vin)
				]), 0xFF0000);
				
				renderer.addChild(line);
				lines.push(line);
			}
			lines.fixed = true;
			/*
		}
		
		override protected function draw():void
		{
			sphere.rotationY++;
			/*
			var i:uint = 0;
			for each(var face:Face in plane.faces)
			{
				var line:Line3D = lines[i++];
				renderer.removeChild(line);
				
				line = new Line3D(Vector.<Vector3D>
				([
					face.getN0(plane.vin), face.getN1(plane.vin)
				]), 0xFF0000);
			}
			*/
		}
	}
}
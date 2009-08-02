package
{
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Object3D;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExSphereFrustum
	 * @author katopz
	 */
	public class ExFrustumCulling extends SimpleView
	{
		private var sphere:Sphere;
		private var sphere2:Sphere;

		private var step:Number = 0;

		override protected function create():void
		{
			// Single Core = 40, Quad Core = 56
			var segment:uint = 40;

			sphere = new Sphere(100, segment, segment, new BitmapFileMaterial("assets/earth.jpg"));
			renderer.addChild(sphere);
			
			sphere2 = new Sphere(50, segment, segment, new BitmapFileMaterial("assets/earth.jpg"));
			renderer.addChild(sphere2);
			
			sphere.z = 500;
			sphere2.z = 500;
			
			// TODO : make defaukt as true
			sphere.isObjectCulling = true;
			sphere2.isObjectCulling = true;
		}

		override protected function draw():void
		{
			sphere.rotationY += 2;
			sphere2.rotationY -= 2;

			sphere2.x = 800 * Math.sin(step);
			sphere2.z = 800 * Math.cos(step);
			
			step += 0.1;
			
			//camera.rotationY = (mouseX - stage.stageWidth / 2) / 10;
			//camera.rotationX = -(mouseY - stage.stageHeight / 2) / 10;
			
			var numCulled:uint = 0;
			for each(var child:Object3D in renderer.childs)
			{
				if(child.culled)
					++numCulled;
			}
			
			debugText.appendText(", Culled : " + numCulled + ", x : "+ sphere2.x+ ", Right click for more option");
		}
	}
}
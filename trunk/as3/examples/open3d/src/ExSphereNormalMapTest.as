package
{
	import open3d.materials.shaders.NormalMapBuilder;
	import flash.display.Bitmap;
	import open3d.materials.shaders.PBBitmapShader;
	import open3d.materials.shaders.PhongColorMaterial;
	import open3d.objects.Light;
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	

	/**
	 * ExSphere
	 * @author katopz
	 */
	public class ExSphereNormalMapTest extends SimpleView
	{
		[Embed(source="assets/earth.jpg")]
		private var DiffMap : Class;
	
		[Embed(source="assets/normalMap.jpg")]
		private var NormalMap : Class;
		
		
		private var sphere:Sphere;
		private var sphere2:Sphere;

		private var step:Number = 0;
		private var light:Light
		private var mat1:PBBitmapShader
		override protected function create():void
		{
			// prep bitmapdata
			var dfBm:Bitmap =new DiffMap() as Bitmap;
			var normBm:Bitmap =new NormalMap() as Bitmap;
			// Single Core = 35, Quad Core = 56
			var segment:uint = 56;
			light = new Light();
			light.x = 20;
			light.y=20;
			mat1= new PBBitmapShader(light,dfBm.bitmapData);
			sphere = new Sphere(100, segment, segment,mat1);
			renderer.addChild(sphere);
			
			
			sphere2 = new Sphere(50, segment, segment, new PBBitmapShader(light,dfBm.bitmapData.clone(),normBm.bitmapData.clone()));
			renderer.addChild(sphere2);
		
			//renderer.world.rotationX = 30;
		}

		override protected function draw():void
		{
		
			//this.addChild(NormalMapBuilder.instance);
			
			sphere.rotationY += 2;
			sphere2.rotationY -= 2;
			light.x =  200 * Math.sin(step/5);
			light.y =  200 * Math.cos(step/5);
			sphere2.x = 200 * Math.sin(step);
			sphere2.z = 200 * Math.cos(step);

			step += 0.1;
			
			camera.rotationY = (600- stage.stageWidth / 2) / 10;
			camera.rotationX = -(280 - stage.stageHeight / 2) / 10;
		}
	}
}
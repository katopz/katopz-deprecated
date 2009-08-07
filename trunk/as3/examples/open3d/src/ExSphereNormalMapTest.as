package
{
	import flash.display.Sprite;

	import open3d.objects.Sphere;

	import open3d.materials.shaders.PBBitmapShader;
	import open3d.materials.shaders.PBTransparentShader;
	import open3d.objects.Light;
	
	import open3d.view.SimpleView;

	import flash.display.Bitmap;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExSphereNormalMapTest
	 * @author kris@neuroproductions.be
	 */
	public class ExSphereNormalMapTest extends SimpleView
	{
	
		
		[Embed(source="assets/top.jpg")]
		private var BackgroundMap : Class;
		
		
		[Embed(source="assets/earth.jpg")]
		private var DiffMap : Class;

		[Embed(source="assets/normalmap.jpg")]
		private var NormalMap : Class;

		
		private var sphere:Sphere;
		private var sphere2:Sphere;

		private var step : Number = 0;
		private var light : Light;
		private var mat1 : PBBitmapShader;

		
		override protected function create() : void
		{
			// prep bitmapdata
			var dfBm : Bitmap = new DiffMap() as Bitmap;
			var normBm : Bitmap = new NormalMap() as Bitmap;
			
			var back: Bitmap = new BackgroundMap() as Bitmap;
			
			// Single Core = 35, Quad Core = 56
			var segment:uint = 40;
			
			
			light = new Light();
			
		
		
			light.x = 0;
			light.y =0;
			
			
		
			/*sphere = new Sphere(100, segment, segment,  new PBTransparentShader(light, back.bitmapData.clone()));
			renderer.addChild(sphere);*/
 			var mat:PBBitmapShader = new PBBitmapShader(light, dfBm.bitmapData.clone(),normBm.bitmapData.clone());
 			mat.drawSprite.x = 400;
 			this.addChild(mat.drawSprite);
			sphere2 = new Sphere(150, segment, segment, mat);
			renderer.addChild(sphere2);
			renderer.addChild(light);
		}

		override protected function draw() : void
		{
		
			
			sphere2.rotationX += 2;
			sphere2.rotationY += 0;
			sphere2.rotationZ += 0;
			light.x = Math.cos(step) * Math.cos(step/2) * 300
			light.y = -Math.sin(step/2) * 300
			light.z =Math.sin(step) * Math.cos(step) * 300
			//sphere2.x = 200 * Math.sin(step);
			//sphere2.z =200 * Math.cos(step);

			step += 0.01;
			
			//camera.rotationY = (mouseX - stage.stageWidth / 2) / 10;
			//camera.rotationX = -(mouseY - stage.stageHeight / 2) / 10;
			
			
		}
	}
}
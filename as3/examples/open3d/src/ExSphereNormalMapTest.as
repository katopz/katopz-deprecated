package
{
	import flash.display.Sprite;

	import open3d.objects.Sphere;

	import open3d.materials.shaders.PBBitmapShader;
	import open3d.materials.shaders.PBTransparentShader;
	import open3d.objects.Light;
	
	import open3d.view.SimpleView;

	import flash.display.Bitmap;

	[SWF(width=800, height = 600, backgroundColor = 0x000000, frameRate = 30)]

	/**
	 * ExSphereNormalMapTest
	 * @author kris@neuroproductions.be
	 */
	public class ExSphereNormalMapTest extends SimpleView
	{
	
		
		[Embed(source="assets/stars.jpg")]
		private var BackgroundMap : Class;
		
		
		[Embed(source="assets/Earth2.jpg")]
		private var DiffMap : Class;

		[Embed(source="assets/normalmap.jpg")]
		private var NormalMap : Class;

[Embed(source="assets/moon.jpg")]
		private var DiffMap2 : Class;

		[Embed(source="assets/MoonNormal.jpg")]
		private var NormalMap2 : Class;
		
		private var sphere:Sphere;
		private var sphere2:Sphere;

		private var step : Number = 0;
		private var light : Light;
		
private var dfBack : Bitmap
		
		override protected function create() : void
		{
			// prep bitmapdata
			var dfBm : Bitmap = new DiffMap() as Bitmap;
			var normBm : Bitmap = new NormalMap() as Bitmap;
			
			var dfBm2 : Bitmap = new DiffMap2() as Bitmap;
			var normBm2 : Bitmap = new NormalMap2() as Bitmap;
			
			dfBack = new BackgroundMap() as Bitmap;
			dfBack.alpha =0.5
			this.addChildAt(dfBack,0)
			// Single Core = ?, Quad Core = ?
			var segment:uint = 41;
			
			
			light = new Light();
			
		
		
			light.x = 0;
			light.y =0;
			
			var mat2:PBBitmapShader = new PBBitmapShader(light, dfBm.bitmapData.clone(),normBm.bitmapData.clone());
 			
		
			sphere = new Sphere(100, segment, segment, mat2);
			renderer.view.addChild(sphere);
 			var mat:PBBitmapShader = new PBBitmapShader(light, dfBm2.bitmapData.clone(),normBm2.bitmapData.clone());
 			//mat.drawSprite.x = 400;
 			//this.addChild(mat.drawSprite);
			sphere2 = new Sphere(50, segment, segment, mat);
			renderer.view.addChild(sphere2);
			renderer.view.addChild(light);
		}

		override protected function draw() : void
		{
		
			dfBack.x =(-dfBack.width/2 + stage.stageWidth / 2)
			dfBack.y =(-dfBack.height/2 + stage.stageHeight / 2)
			sphere2.rotationX += 0;
			sphere2.rotationY -=5;
			sphere.rotationY += 5;
			light.x = Math.cos(step*5)* 150;
			light.y = Math.sin(step*5) *150;
			
			sphere2.x = 230 * Math.sin(step);
			sphere2.z =230 * Math.cos(step);

			step += 0.03;
			
			camera.rotationY = (mouseX - stage.stageWidth / 2) / 100;
			camera.rotationX = -(mouseY - stage.stageHeight / 2) / 100;
			
			
		}
	}
}
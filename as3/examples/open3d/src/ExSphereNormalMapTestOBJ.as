package
{
	import flash.filters.ShaderFilter;
	import flash.utils.ByteArray;
	import flash.display.Shader;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import open3d.materials.shaders.PBBitmapShader;
	import open3d.materials.shaders.PBTransparentShader;
	import open3d.objects.Light;
	import open3d.objects.OBJ;
	import open3d.view.SimpleView;

	import flash.display.Bitmap;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExSphereNormalMapTest
	 * @author kris@neuroproductions.be
	 */
	public class ExSphereNormalMapTestOBJ extends SimpleView
	{
	
		
		[Embed(source="assets/top.jpg")]
		private var BackgroundMap : Class;
		
		
		[Embed(source="assets/flesh_diffuse.jpg")]
		private var DiffMap : Class;

		[Embed(source="assets/flesh_normals.jpg")]
		private var NormalMap : Class;

		
		private var objTrans : OBJ;
		private var objShaded : OBJ;

		private var step : Number = 0;
		private var light : Light;
		private var mat1 : PBBitmapShader;

		
		override protected function create() : void
		{
			// prep bitmapdata
			var dfBm : Bitmap = new DiffMap() as Bitmap;
			var normBm : Bitmap = new NormalMap() as Bitmap;
			
			var back: Bitmap = new BackgroundMap() as Bitmap;
			
		
			
			
			light = new Light();
			
		
		
			light.x = 20;
			light.y = 20;
			var layer:Sprite =new Sprite();
			this.addChildAt(layer,1);
			
			objTrans = new OBJ("assets/flesh_creature.obj", new PBTransparentShader(light, back.bitmapData.clone()), 8);
			objTrans.rotationX = -90;
			objTrans .x = 200;
			objTrans.layer =layer;
			objShaded = new OBJ("assets/flesh_creature.obj", new PBBitmapShader(light, dfBm.bitmapData.clone(), normBm.bitmapData.clone()), 8);
			objShaded.rotationX = -90;
			objShaded .x = -200;
			renderer.addChild(objTrans);
			renderer.addChild(objShaded);
			renderer.addChild(light);
		}

		override protected function draw() : void
		{
		
			
			objShaded.rotationY += 2;
			objTrans.rotationY -= 2;
		
			light.x =  200 * Math.cos(step);
			light.z=  200 * Math.sin(step);

			step += 0.1;
			
			
		}
	}
}
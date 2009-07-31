package
{
	import flash.utils.ByteArray;
	import flash.display.Shader;
	import open3d.materials.shaders.NormalMaterial;
	import open3d.materials.BitmapFileMaterial;
	import flash.display.BlendMode;
	import open3d.materials.ColorMaterial;
	import open3d.view.Layer;
	import open3d.materials.shaders.FlatShader;
	import open3d.materials.shaders.PhongColorMaterial;
	import open3d.objects.Light;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;

	import flash.display.StageAlign;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * Test for a flash generated normal map
	 * @author kris@neuroproductions
	 */
	public class ExSphereNormalMapTest extends SimpleView
	{
		[Embed("../assets/pixelBender/NormalMapBlendMode.pbj", mimeType="application/octet-stream")]
		private var NormalShader:Class;	
			
			
		private var sphere : Sphere;
		private var sphere2 : Sphere;
		private var light : Light;
	

		override protected function create() : void
		{
			var shader:Shader = new Shader(new NormalShader() as ByteArray);
			
			this.x = 300;
			this.y = 300;
			
			// Single Core = 35, Quad Core = 56
			var segment : uint = 20;
			light = new Light();
			light.x = 1;
			
			var layer0:Layer = new Layer();
			addChild(layer0);

			var layer1:Layer = new Layer();
			layer1.blendShader = shader;
			addChild(layer1);
			
			sphere = new Sphere(100, segment, segment, new NormalMaterial(light));
			sphere.layer = layer0;
			renderer.addChild(sphere);

			sphere2 = new Sphere(100, segment, segment,  new BitmapFileMaterial("assets/normalmapTest.jpg"));
			sphere.layer = layer1;
			renderer.addChild(sphere2);
			
			
		}

		override protected function draw() : void
		{
			sphere.rotationY += 2;
			sphere2.rotationY += 2;

				
			
			
			
			camera.rotationY = (mouseX - stage.stageWidth / 2) / 10;
			camera.rotationX = -(mouseY - stage.stageHeight / 2) / 10;
		}
	}
}
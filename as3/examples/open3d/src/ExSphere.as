package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import open3d.materials.BitmapMaterial;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;
	
	[SWF(width=800, height=600, backgroundColor=0x666666, frameRate=30)]
	public class ExSphere extends SimpleView
	{
        [Embed(source = "assets/earth.jpg")]
        private var Texture		:Class;
		private var texture		:BitmapData = Bitmap(new Texture()).bitmapData;
		
		private var sphere:Sphere;
		private var sphere2:Sphere;
		
		private var step:Number=0;
		
		override protected function create():void
		{
			var segment:uint = 48;
			
			sphere = new Sphere(100, segment, segment, new BitmapMaterial(texture));
			renderer.addChild(sphere);
			
			sphere2 = new Sphere(50, segment, segment, new BitmapMaterial(texture));
			renderer.addChild(sphere2);
			
			isDebug = true;
			
			renderer.world.rotationX = 30;
		}
		
		override protected function draw():void
		{
			sphere.rotationY+=10;
			sphere2.rotationY-=10;
			
			sphere2.x = 200*Math.sin(step);
			sphere2.z = 200*Math.cos(step);
			
			step+=0.1;
		}
	}
}
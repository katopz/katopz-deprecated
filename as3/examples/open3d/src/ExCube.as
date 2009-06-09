package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import open3d.materials.BitmapMaterial;
	import open3d.objects.Cube;
	import open3d.view.SimpleView;
	
	[SWF(width=800, height=600, backgroundColor=0x666666, frameRate=30)]
	
	/**
	 * ExCube
	 * @author katopz
	 * 
	 */	
	public class ExCube extends SimpleView
	{
        [Embed(source = "assets/earth.jpg")]
        private var Texture		:Class;
		private var texture		:BitmapData = Bitmap(new Texture()).bitmapData;
		
		private var cube:Cube;
		
		override protected function create():void
		{
			cube = new Cube(100, new BitmapMaterial(texture));
			renderer.addChild(cube);
			cube.culling = "none";
		}
		
		override protected function draw():void
		{
			cube.rotationY++;
		}
	}
}
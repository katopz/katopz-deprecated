package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import open3d.materials.BitmapFileMaterial;
	import open3d.materials.BitmapMaterial;
	import open3d.objects.ASE;
	import open3d.view.SimpleView;
	
	[SWF(width=800, height=600, backgroundColor=0x666666, frameRate=30)]
	public class ExASE extends SimpleView
	{
		[Embed(source='assets/shuttle.ase', mimeType='application/octet-stream')]
		private var ShuttleModel:Class;
		
		[Embed(source='assets/shuttle.jpg')]
		private var ShuttleTexture:Class;
		private var shuttleTexture:BitmapData = Bitmap(new ShuttleTexture()).bitmapData;
		
		[Embed(source='assets/barge.ase', mimeType='application/octet-stream')]
		private var BargeModel:Class;
		
		private var shuttle:ASE;
		private var barge:ASE;
		
		private var step:Number=0;
		
		override protected function create():void 
		{
			// Embed image
			shuttle = new ASE(new ShuttleModel, new BitmapMaterial(shuttleTexture));
			renderer.addChild(shuttle);
			
			// File image
			barge = new ASE(new BargeModel, new BitmapFileMaterial("assets/barge.jpg"));
			renderer.addChild(barge);
		}
		
		override protected function draw():void
		{
			barge.rotationX++;
			barge.rotationY++;
			barge.rotationZ++;
			
			shuttle.rotationX++;
			shuttle.rotationY++;
			shuttle.rotationZ++;
			
			shuttle.x = 200*Math.sin(step);
			shuttle.z = 200*Math.cos(step);
			
			step+=0.01;
		}
	}
}
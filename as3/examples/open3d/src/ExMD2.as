package  
{
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.MD2;
	import open3d.view.SimpleView;
	
	[SWF(width=800, height=600, backgroundColor=0x666666, frameRate=30)]
	
	/**
	 * ExMD2
	 * @author katopz
	 * 
	 */	
	public class ExMD2 extends SimpleView
	{
		[Embed(source='assets/plane.md2', mimeType='application/octet-stream')]
		private var CatModel:Class;
		
		private var cat:MD2;
		private var step:Number = 0;
		
		override protected function create():void 
		{
			cat = new MD2(new CatModel, new BitmapFileMaterial("assets/pg.png"));
			renderer.addChild(cat);
			renderer.isFaceZSort = renderer.isMeshZSort = false;
			cat.culling = "none";
		}
		
		override protected function draw():void
		{
			cat.rotationY+=1;// = 180*Math.abs(Math.sin(step));
			//step+=.01;
		}
	}
}
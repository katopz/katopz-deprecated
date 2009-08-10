package
{
	import flash.display.Sprite;
	
	import open3d.materials.BitmapFileMaterial;
	import open3d.materials.Material;
	import open3d.objects.Cube;
	import open3d.view.SimpleView;

	[SWF(width=800,height=600,backgroundColor=0x666666,frameRate=30)]

	/**
	 * ExCube
	 * @author katopz
	 */
	public class ExCube extends SimpleView
	{
		private var cube:Cube;

		override protected function create():void
		{
			cube = new Cube(Vector.<Material>([
				new BitmapFileMaterial("assets/space1.jpg"),
				new BitmapFileMaterial("assets/space2.jpg"),
				new BitmapFileMaterial("assets/space3.jpg"),
				new BitmapFileMaterial("assets/space4.jpg"),
				new BitmapFileMaterial("assets/space3.jpg"),
				new BitmapFileMaterial("assets/space2.jpg")
				]));
			renderer.addChild(cube);
		}

		override protected function draw():void
		{
			var view:Sprite = renderer.view;
			view.rotationX = (mouseX - stage.stageWidth / 2) / 5;
			view.rotationZ = (mouseY - stage.stageHeight / 2) / 5;
			view.rotationY++;
		}
	}
}
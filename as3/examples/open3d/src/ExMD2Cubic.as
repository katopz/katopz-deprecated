package
{
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.MD2;
	import open3d.objects.Object3D;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExMD2Cubic
	 * @author katopz
	 */
	public class ExMD2Cubic extends SimpleView
	{
		override protected function create():void
		{
			var amount:uint = 3;
			var radius:uint = 80;
			var gap:uint = amount;

			for (var i:int = -amount / 2; i < amount / 2; ++i)
				for (var j:int = -amount / 2; j < amount / 2; ++j)
					for (var k:int = -amount / 2; k < amount / 2; ++k)
					{
						var md2:MD2 = new MD2("assets/pg.md2", new BitmapFileMaterial("assets/pg.png"));
						renderer.addChild(md2);
						md2.x = gap * radius * i;
						md2.y = gap * radius * j;
						md2.z = gap * radius * k;
					}

			renderer.world.rotationX = 30;
			renderer.world.z = 1000;
		}

		override protected function draw():void
		{
			var world:Object3D = renderer.world;
			world.rotationX = (mouseX - stage.stageWidth / 2) / 5;
			world.rotationZ = (mouseY - stage.stageHeight / 2) / 5;
			world.rotationY++;

			var _renderer_childs:Array = renderer.childs;

			for each (var md2:MD2 in _renderer_childs)
			{
				md2.updateFrame();
			}
			
			debugText.appendText(", ZSort : " + renderer.isMeshZSort + ", Right click for more option");
		}
	}
}
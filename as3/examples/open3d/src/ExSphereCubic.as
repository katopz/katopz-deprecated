package
{
	import flash.display.Sprite;
	
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExSphereCubic
	 * @author katopz
	 */
	public class ExSphereCubic extends SimpleView
	{
		override protected function create():void
		{
			var segment:uint = 10;
			var amount:uint = 4;
			var radius:uint = 25;
			var gap:uint = amount;

			var sphere:Sphere;
			for (var i:int = -amount / 2; i < amount / 2; ++i)
				for (var j:int = -amount / 2; j < amount / 2; ++j)
					for (var k:int = -amount / 2; k < amount / 2; ++k)
					{
						var bitmapFileMaterial:BitmapFileMaterial = new BitmapFileMaterial("assets/earth.jpg");
						sphere = new Sphere(radius, segment, segment, bitmapFileMaterial);
						renderer.addChild(sphere);
						sphere.x = gap * radius * i + gap * radius / 2;
						sphere.y = gap * radius * j + gap * radius / 2;
						sphere.z = gap * radius * k + gap * radius / 2;
					}

			renderer.view.rotationX = 30;
		}

		override protected function draw():void
		{
			var view:Sprite = renderer.view;
			view.rotationX = (mouseX - stage.stageWidth / 2) / 5;
			view.rotationZ = (mouseY - stage.stageHeight / 2) / 5;
			view.rotationY++;

			debugText.appendText(", ZSort : " + renderer.isMeshZSort + ", Right click for more option");
		}
	}
}
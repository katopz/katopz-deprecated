package
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import open3d.materials.BitmapFileMaterial;
	import open3d.materials.BitmapMaterial;
	import open3d.objects.ASE;
	import open3d.objects.Plane;
	import open3d.view.SimpleView;

	[SWF(width=800, height = 600, backgroundColor = 0x666666, frameRate = 30)]

	/**
	 * ExFakeReflect
	 * @author katopz
	 */

	public class ExFakeReflect extends SimpleView
	{
		[Embed(source='assets/shuttle.ase', mimeType = 'application/octet-stream')]
		private var ShuttleModel:Class;

		private var plane:Plane;
		private var shuttle:ASE;

		private var bmp:BitmapData;
		private var gd:Shape;

		override protected function create():void
		{
			shuttle = new ASE(new ShuttleModel, new BitmapFileMaterial("assets/shuttle.jpg"));
			shuttle.scaleX = shuttle.scaleY = shuttle.scaleZ = 4;
			shuttle.rotationX = -90;
			shuttle.rotationZ = 180;
			renderer.addChild(shuttle);

			bmp = new BitmapData(800, 600);
			gd = createGradient(800, 600);

			plane = new Plane(800, 600, new BitmapMaterial(bmp));

			plane.rotationX = -45;
			plane.y = 300;
			plane.culling = "none";

			renderer.addChild(plane);

			renderer.isMeshZSort = false;

			renderer.view.y = -100;

			isDebug = false;
		}

		private var blank:Rectangle = new Rectangle(0, 0, 800, 600);

		override protected function prerender():void
		{
			stat.visible = false;

			renderer.removeChild(plane);

			renderer.view.rotationX = 90 + 45;

			shuttle.scaleX = -shuttle.scaleX;

			shuttle.rotationY++;
			shuttle.rotationZ = (mouseX - stage.stageWidth / 2);
			shuttle.rotationX = (mouseY - stage.stageHeight / 2);

			renderer.isFaceZSort = false;
			renderer.render();

			bmp.fillRect(blank, 0xFFFFFF);

			bmp.draw(this);
			bmp.draw(gd);

			shuttle.scaleX = -shuttle.scaleX;

			renderer.view.rotationX = 0;

			renderer.addChild(plane);
			renderer.childs.reverse();

			stat.visible = true;

			renderer.isFaceZSort = true;
		}

		protected function createGradient(w:int, h:int):Shape
		{
			var gradMat:Matrix = new Matrix();
			gradMat.createGradientBox(w, h, Math.PI / 2);
			var gradient:Shape = new Shape();
			gradient.graphics.beginGradientFill("linear", [0xffffff, 0xffffff], [0, .75], [0, 255], gradMat);
			gradient.graphics.drawRect(0, 0, w, h);
			gradient.graphics.endFill();
			return gradient;
		}
	}
}
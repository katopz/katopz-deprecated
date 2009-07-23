package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
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
	 * ExFakeReflectFluidPlane
	 * @author katopz
	 *
	 */
	public class ExFakeReflectFluidPlane extends SimpleView
	{
		[Embed(source='assets/shuttle.ase', mimeType = 'application/octet-stream')]
		private var ShuttleModel:Class;

		[Embed(source="assets/sea01.jpg")]
		private var SeaTexture:Class;
		private var seaTextureBitmapData:BitmapData = Bitmap(new SeaTexture).bitmapData;

		private var plane:Plane;
		private var shuttle:ASE;

		private var bmp:BitmapData;
		private var gd:Shape;

		private var step:Number = 0;

		override protected function create():void
		{
			shuttle = new ASE(new ShuttleModel, new BitmapFileMaterial("assets/shuttle.jpg"));
			shuttle.scaleX = shuttle.scaleY = shuttle.scaleZ = 2;
			shuttle.rotationX = -90;
			shuttle.rotationZ = 180;
			renderer.addChild(shuttle);

			bmp = new BitmapData(800, 600);
			gd = createGradient(800, 600);

			var planeMaterial:BitmapMaterial = new BitmapMaterial(bmp);
			planeMaterial.isDebug = true;

			plane = new Plane(800, 600, planeMaterial, 10, 10);
			plane.scaleX = plane.scaleY = plane.scaleZ = 2;

			plane.rotationX = -45;
			plane.y = 300;

			renderer.addChild(plane);

			renderer.isMeshZSort = false;

			renderer.world.y = -100;
			renderer.world.z = 600;

			isDebug = false;
		}

		private var blank:Rectangle = new Rectangle(0, 0, 800, 600);

		override protected function prerender():void
		{

			for (var i:int = 0; i < plane.vin.length / 3; ++i)
			{
				plane.setVertices(i, "z", (i + 1) * 0.5 * Math.sin(step + i / 10));
				step += 0.0001;
			}

			//------------------------------------------------------------

			stat.visible = false;

			renderer.removeChild(plane);

			renderer.world.rotationX = 90 + 45;

			shuttle.scaleX = -shuttle.scaleX;

			shuttle.rotationY++;
			shuttle.rotationZ = (mouseX - stage.stageWidth / 2);
			shuttle.rotationX = (mouseY - stage.stageHeight / 2);

			renderer.isFaceZSort = false;
			renderer.render();

			bmp.fillRect(blank, 0xFFFFFF);

			bmp.draw(gd);
			bmp.draw(this, null, null, BlendMode.OVERLAY);

			shuttle.scaleX = -shuttle.scaleX;

			renderer.world.rotationX = 0;

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
			//gradient.graphics.beginGradientFill("linear", [0x79b9fc, 0xc1dfff], [0, .75], [0, 255], gradMat);
			gradient.graphics.beginBitmapFill(seaTextureBitmapData);
			gradient.graphics.drawRect(0, 0, w, h);
			gradient.graphics.endFill();
			return gradient;
		}
	}
}
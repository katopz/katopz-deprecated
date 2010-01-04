package 
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;

	import de.nulldesign.nd3d.material.BitmapMaterial;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.objects.SimpleCube;
	import de.nulldesign.nd3d.renderer.Renderer;	

	public class AdditiveCubes extends Sprite 
	{

		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;

		[Embed("assets/cube_texture.png")]
		private var MyTexture:Class;	

		public function AdditiveCubes() 
		{

			var m:Matrix = new Matrix();
			m.rotate(Math.PI / 2);
			graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0xFFFFFF], [100, 100], [125, 255], m);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			renderer = new Renderer(Sprite(addChild(new Sprite())));
			renderer.additiveMode = true;
			
			cam = new PointCamera(600, 400);
			cam.zOffset = 2000;
			
			renderList = [];
			
			// direct color transform
			var texture1:BitmapData = new MyTexture().bitmapData;
			texture1.colorTransform(texture1.rect, new ColorTransform(0.3, 0.5, 0.6, 1, 0, 0, 0, 0));
			var mat1:BitmapMaterial = new BitmapMaterial(texture1, false, false, true, true);
			
			// dynamic color transform
			var texture2:BitmapData = new MyTexture().bitmapData;
			var mat2:BitmapMaterial = new BitmapMaterial(texture2, false, false, true, true);
			mat2.colorTransform = new ColorTransform(1, 0.5, 1, 1, 0, 0, 0, 0);
			
			var texture3:BitmapData = new MyTexture().bitmapData;
			texture3.colorTransform(texture3.rect, new ColorTransform(1, 1, 0.5, 1, 0, 0, 0, 0));
			var texture4:BitmapData = new MyTexture().bitmapData;
			texture4.colorTransform(texture4.rect, new ColorTransform(0, 1, 1, 1, 0, 0, 0, 0));
			var texture5:BitmapData = new MyTexture().bitmapData;
			texture5.colorTransform(texture5.rect, new ColorTransform(1, 1, 0, 1, 0, 0, 0, 0));
			
			var c1:Mesh = new SimpleCube(mat1, 200);
			var c2:Mesh = new SimpleCube(mat2, 300);
			var c3:Mesh = new SimpleCube(new BitmapMaterial(texture3, false, false, true, true), 400);
			var c4:Mesh = new SimpleCube(new BitmapMaterial(texture4, false, false, true, true), 500);
			var c5:Mesh = new SimpleCube(new BitmapMaterial(texture5, false, false, true, true), 600);
			
			//renderList.push(c1, c2, c3, c4, c5);
			for(var i:int=0;i<40;++i)
			{
				renderList.push(new SimpleCube(mat1, 200));
			}
			
			addEventListener(Event.ENTER_FRAME, onRenderScene);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		}

		private function onKeyPress(evt:KeyboardEvent):void 
		{
			renderer.additiveMode = !renderer.additiveMode;
		}

		private function onRenderScene(evt:Event):void 
		{

			Mesh(renderList[0]).angleX += (mouseY - cam.vpY) * .0005;
			Mesh(renderList[0]).angleY += (mouseX - cam.vpX) * .0005;
			
			for(var i:uint = 1;i < renderList.length; i++) 
			{
				Mesh(renderList[i]).angleX += (Mesh(renderList[i - 1]).angleX - Mesh(renderList[i]).angleX) * 0.2;
				Mesh(renderList[i]).angleY += (Mesh(renderList[i - 1]).angleY - Mesh(renderList[i]).angleY) * 0.2;
			}
			
			renderer.render(renderList, cam);
		}
	}
}

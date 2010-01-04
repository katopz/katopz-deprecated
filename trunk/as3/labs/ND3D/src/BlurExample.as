package 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;

	import de.nulldesign.nd3d.material.BitmapMaterial;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.objects.SimpleCube;
	import de.nulldesign.nd3d.renderer.Renderer;	

	public class BlurExample extends Sprite 
	{

		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;

		[Embed("assets/cube_texture2.png")]
		private var MyTexture:Class;

		function BlurExample() 
		{
			
			var renderClip:Sprite = new Sprite();
			addChild(renderClip);
			
			var descriptionClip:Sprite = new Sprite();
			addChild(descriptionClip);
			
			renderer = new Renderer(renderClip);
			renderer.distanceBlur = 40;
			renderer.blurMode = true;
			
			cam = new PointCamera(600, 400);
			
			renderList = [];

			var texture:BitmapData = new MyTexture().bitmapData;
			texture.colorTransform(texture.rect, new ColorTransform(0.0, 1.0, 1.0, 0.5, 0, 0, 0, 0));
			var mat:BitmapMaterial = new BitmapMaterial(texture, false, false, true, true);
			
			for(var i:Number = 0;i < 3; i++) 
			{
				for(var j:Number = 0;j < 3; j++) 
				{
					for(var k:Number = 0;k < 3; k++) 
					{
						var m:Mesh = new SimpleCube(mat, 20);
						m.scale(1.5, 1.5, 1.5);
						m.xPos = -80 + i * 80;
						m.yPos = -80 + j * 80;
						m.zPos = -80 + k * 80;
						renderList.push(m);
					}
				}
			}

			var desc:Description = new Description("object blurmode enabled", m);
			descriptionClip.addChild(desc);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(Event.ENTER_FRAME, onRenderScene);
		}

		private function onMouseWheel(evt:MouseEvent):void 
		{
			cam.zOffset -= evt.delta * 10;
		}

		private function onRenderScene(evt:Event):void 
		{

			cam.angleX += (mouseY - cam.vpY) * .0005;
			cam.angleY += (mouseX - cam.vpX) * .0005;

			renderer.render(renderList, cam);
		}
	}
}

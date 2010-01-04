package 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;

	import de.nulldesign.nd3d.material.BitmapMaterial;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Cube;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.renderer.Renderer;	

	public class AdditiveExample extends Sprite 
	{

		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;

		[Embed("assets/cube_texture2.png")]
		private var MyTexture:Class;

		private var cube:Cube;
		private var cube2:Cube;
		private var cube3:Cube;
		private var cube4:Cube;

		function AdditiveExample() 
		{

			var renderClip:Sprite = new Sprite();
			addChild(renderClip);
			
			var descriptionClip:Sprite = new Sprite();
			addChild(descriptionClip);
			
			renderer = new Renderer(renderClip);
			//renderer.wireFrameMode = true;
			//renderer.dynamicLighting = true;
			renderer.additiveMode = true;
			
			cam = new PointCamera(600, 400);
			renderList = [];
			
			var tex:BitmapData = new MyTexture().bitmapData;
			
			// additive material 
			var mat:BitmapMaterial = new BitmapMaterial(tex, false, false, false, true);
			cube = new Cube([mat, mat, mat, mat, mat, mat], 100, 3);
			cube.xPos = -120;
			cube.yPos = -120;
			renderList.push(cube);
			
			// additive, doublesided material 
			var mat2:BitmapMaterial = new BitmapMaterial(tex, false, false, true, true);
			cube2 = new Cube([mat2, mat2, mat2, mat2, mat2, mat2], 100, 3);
			cube2.xPos = 120;
			cube2.yPos = -120;
			renderList.push(cube2);
			
			// normal, transparent material 
			var mat3:BitmapMaterial = new BitmapMaterial(tex);
			cube3 = new Cube([mat3, mat3, mat3, mat3, mat3, mat3], 100, 3);
			cube3.xPos = -120;
			cube3.yPos = 120;
			renderList.push(cube3);
			
			// normal, transparent material, normals flipped
			var mat4:BitmapMaterial = new BitmapMaterial(tex);
			cube4 = new Cube([mat4, mat4, mat4, mat4, mat4, mat4], 100, 3);
			cube4.flipNormals();
			cube4.xPos = 120;
			cube4.yPos = 120;
			renderList.push(cube4);

			var desc1:Description = new Description("additive material", cube);
			descriptionClip.addChild(desc1);
			
			var desc2:Description = new Description("additive, doublesided material ", cube2);
			descriptionClip.addChild(desc2);

			var desc3:Description = new Description("normal, transparent material ", cube3);
			descriptionClip.addChild(desc3);

			var desc4:Description = new Description("normal, transparent material, normals flipped", cube4);
			descriptionClip.addChild(desc4);
			
			addEventListener(Event.ENTER_FRAME, onRenderScene);
		}

		private function onRenderScene(evt:Event):void 
		{

			cam.angleX += (mouseY - cam.vpY) * .0005;
			cam.angleY += (mouseX - cam.vpX) * .0005;

			renderer.render(renderList, cam);
		}
	}
}

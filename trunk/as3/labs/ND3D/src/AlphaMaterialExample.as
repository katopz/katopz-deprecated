package 
{
	import de.nulldesign.nd3d.material.BitmapMaterial;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;

	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.objects.Sphere;
	import de.nulldesign.nd3d.renderer.Renderer;	

	public class AlphaMaterialExample extends Sprite 
	{

		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;

		[Embed("assets/doggy.jpg")]
		private var MyTexture:Class;	
		private var sphere:Sphere;
		private var sphere2:Sphere;
		private var sphere3:Sphere;
		private var sphere4:Sphere;

		private var desc1:Description;
		private var desc2:Description;
		private var desc3:Description;
		private var desc4:Description;

		function AlphaMaterialExample() 
		{

			var renderClip:Sprite = new Sprite();
			addChild(renderClip);
			
			var descriptionClip:Sprite = new Sprite();
			addChild(descriptionClip);
			
			renderer = new Renderer(renderClip);
			//renderer.wireFrameMode = true;
			renderer.dynamicLighting = true;
			//renderer.additiveMode = true;

			cam = new PointCamera(600, 400);
			renderList = [];
			
			var tex:BitmapData = new MyTexture().bitmapData;
			
			// note: each sphere has a custom container sprite
			
			// flat, single colored material, no lighting, custom filter
			var mat:Material = new Material(0xFFFFFF, 1);
			sphere = new Sphere(10, 100, mat);
			sphere.container = new Sprite();
			sphere.container.filters = [new GlowFilter(0x00ff00, 1, 15, 15)];
			sphere.xPos = -120;
			sphere.yPos = -120;
			renderList.push(sphere);
			
			// flat, single colored material, lighting enabled
			var mat2:Material = new Material(0xFFFFFF, 1, true);
			sphere2 = new Sphere(10, 100, mat2);
			sphere2.container = new Sprite();
			sphere2.xPos = 120;
			sphere2.yPos = -120;
			renderList.push(sphere2);
			
			// textured material, no lighting
			var mat3:BitmapMaterial = new BitmapMaterial(tex);
			sphere3 = new Sphere(10, 100, mat3);
			sphere3.container = new Sprite();
			sphere3.xPos = -120;
			sphere3.yPos = 120;
			renderList.push(sphere3);
			
			// alpha textured material, lighting enabled
			var mat4:BitmapMaterial = new BitmapMaterial(tex, false, true);
			mat4.alpha = 0.6;
			sphere4 = new Sphere(10, 100, mat4);
			sphere4.container = new Sprite();
			sphere4.xPos = 120;
			sphere4.yPos = 120;
			renderList.push(sphere4);
			
			desc1 = new Description("flat, single colored material, no lighting, custom filter", sphere);
			descriptionClip.addChild(desc1);
			
			desc2 = new Description("flat, single colored material, lighting enabled", sphere2);
			descriptionClip.addChild(desc2);

			desc3 = new Description("textured material, no lighting", sphere3);
			descriptionClip.addChild(desc3);

			desc4 = new Description("alpha textured material, lighting enabled", sphere4);
			descriptionClip.addChild(desc4);
			
			addEventListener(Event.ENTER_FRAME, onRenderScene);
		}

		private function onRenderScene(evt:Event):void 
		{

			cam.angleX += (mouseY - cam.vpY) * .0005;
			cam.angleY += (mouseX - cam.vpX) * .0005;
		
			sphere.angleX += 0.01;
			sphere.angleY += 0.01;
			
			sphere2.angleX += 0.012;
			sphere2.angleY += 0.012;
			
			sphere3.angleX += 0.013;
			sphere3.angleY += 0.013;
			
			sphere4.angleX += 0.014;
			sphere4.angleY += 0.014;
			
			renderer.render(renderList, cam);
		}
	}
}

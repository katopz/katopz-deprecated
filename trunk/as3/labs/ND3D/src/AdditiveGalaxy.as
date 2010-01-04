package  
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;

	import de.nulldesign.nd3d.material.BitmapMaterial;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.objects.Sphere;
	import de.nulldesign.nd3d.objects.Sprite3D;
	import de.nulldesign.nd3d.renderer.Renderer;	

	public class AdditiveGalaxy extends Sprite 
	{

		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;

		[Embed("assets/particle2.png")]
		private var ParticleTexture:Class;	

		[Embed("assets/space4.jpg")]
		private var StarFieldTexture:Class;	

		private var numParticles:uint = 400;
		private var particleMat:BitmapMaterial;

		public function AdditiveGalaxy() 
		{
			
			var drawStage:Sprite = new Sprite();
			addChild(drawStage);
			
			renderer = new Renderer(drawStage);
			renderer.additiveMode = true;
			cam = new PointCamera(600, 400);
			//cam.z = -100;
			//cam.y = -100;
			cam.angleX = 0.5;
			renderList = [];

			var tex:BitmapData = new StarFieldTexture().bitmapData;
			var tmpMat:BitmapMaterial = new BitmapMaterial(tex, true);
			var m:Mesh = new Sphere(10, 3000, tmpMat);
			m.flipNormals();
			renderList.push(m);
			
			for(var i:uint = 0;i < numParticles; i++) 
			{
				tex = new ParticleTexture().bitmapData;
				tex.colorTransform(tex.rect, new ColorTransform(Math.random(), Math.random(), 1, 1));
				particleMat = new BitmapMaterial(tex, false, false, false, true);				
				
				var s:Sprite3D = new Sprite3D(particleMat);
				//s.xPos = -100 + Math.random() * 200;
				//s.yPos = -200 + Math.random() * 400;
				s.zPos = 100 + Math.random() * 100;
				s.direction = new Vertex(1 + Math.random() * 2, 0, 0);
				s.scale(20, 20, 20);
				renderList.push(s);
			}
			
			addEventListener(Event.ENTER_FRAME, onRenderScene);
		}

		private function onRenderScene(evt:Event):void 
		{

			cam.angleX += (mouseY - cam.vpY) * .0005;
			cam.angleY += (mouseX - cam.vpX) * .0005;

			renderer.render(renderList, cam);
			
			var s:Sprite3D;
			var distSQ:Number;
			var dist:Number;
			var force:Number;
			var dx:Number;
			var dz:Number;
			
			for(var i:uint = 1;i < renderList.length; i++) 
			{

				s = renderList[i];
				
				dx = -s.xPos;
				dz = -s.zPos;
				
				distSQ = dx * dx + dz * dz;
				dist = Math.sqrt(distSQ);
				force = 1000 / distSQ;
				
				s.direction.x += force * dx / dist;
				s.direction.z += force * dz / dist;
				
				if(s.direction.length > 20) 
				{
					s.direction.length = 20;
				}
				
				s.xPos += s.direction.x;
				s.zPos += s.direction.z;

				// colorize
				/*
				var factor:Number = dist / 100;
				factor = Math.min(factor, 1);
				tex = s.material.texture;
				tex.colorTransform(tex.rect, new ColorTransform(factor - 0.0, 0.8 - factor, 1, 1));
				*/
			}
		}
	}
}

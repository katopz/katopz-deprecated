package 
{
	import flash.display.Sprite;
	import flash.events.Event;

	import de.nulldesign.nd3d.geom.CatmullRomCurve3D;
	import de.nulldesign.nd3d.geom.Vertex;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.renderer.Renderer;	

	public class CustomRendererExample extends Sprite 
	{

		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;
		private var testCurve:CatmullRomCurve3D;
		private var looper:Number = 0;

		public function CustomRendererExample() 
		{
			
			// simple linerenderer test

			renderer = new Renderer(this);
			cam = new PointCamera(600, 400);
			
			testCurve = new CatmullRomCurve3D();
			for(var i:uint = 0;i < 10; i++) 
			{
				testCurve.addCurveVertex(new Vertex((Math.random() + Math.random() * 500), (Math.random() + Math.random() * 500), (Math.random() + Math.random() * 500)));
			}
			testCurve.finalize(true);
			
			addEventListener(Event.ENTER_FRAME, onRenderScene);
		}

		private function onRenderScene(e:Event):void 
		{
			
			looper += 0.01;
			
			cam.angleX += (mouseY - cam.vpY) * .0005;
			cam.angleY += (mouseX - cam.vpX) * .0005;
			
			var m:Mesh = new Mesh();
			var v:Vertex;
			var v2:Vertex;
			var tEnd:Number = Math.sin(looper + Math.PI / 2) / 2 + 0.5;
			var col:uint;
			var scaleFactor:Number;
			
			renderList = [m];
			
			for(var t:Number = 0;t <= tEnd; t += 0.001) 
			{
				v = testCurve.getCurveAt(t);
				m.vertexList.push(v);
			}
			
			renderer.project(renderList, cam);
			
			graphics.clear();

			for(var i:uint = 2;i < m.vertexList.length; i++) 
			{
				v = m.vertexList[i - 1];
				v2 = m.vertexList[i];

				scaleFactor = v.scale * v2.scale;
				scaleFactor = Math.max(0, scaleFactor);
				scaleFactor = Math.min(1, scaleFactor);
				
				//col = ColorUtil.rgb2hex(255 * scaleFactor, 255 * scaleFactor, 255 * scaleFactor);
				col = 0xFFFFFF;

				graphics.lineStyle(v.scale * 10, col, 1);
				graphics.moveTo(v.screenX, v.screenY);
				graphics.lineTo(v2.screenX, v2.screenY);
			}
		}
	}
}
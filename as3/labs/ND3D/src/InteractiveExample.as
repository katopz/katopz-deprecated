package 
{
	import de.nulldesign.nd3d.events.Mouse3DEvent;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Cube;
	import de.nulldesign.nd3d.objects.Object3D;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.objects.Sphere;
	import de.nulldesign.nd3d.renderer.Renderer;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;

	public class InteractiveExample extends Sprite
	{
		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;
		private var text:TextField;

		public function InteractiveExample() 
		{
			renderer = new Renderer(this);
			renderer.dynamicLighting = true;
			
			cam = new PointCamera(600, 400);
			
			addEventListener(Event.ENTER_FRAME, onRenderScene);
			
			// materials can be interactive / clickable
			var matList:Array = [];
			var mat:Material = new Material(0xFF0000, 1);
			mat.isInteractive = true;
			matList.push(mat);
			matList.push(mat);
			
			mat = new Material(0x00FF00, 1);
			mat.isInteractive = true;
			matList.push(mat);
			matList.push(mat);
			
			mat = new Material(0x0000FF, 1);
			mat.isInteractive = false;
			matList.push(mat);
			matList.push(mat);
			
			var cube:Cube = new Cube(matList, 100, 3);
			cube.xPos = -150;
			renderList = [cube];
			
			// or whole objects
			var sphere:Sphere = new Sphere(10, 100, new Material(0xFFFFFF, 1.0, true));
			sphere.isInteractive = true;
			sphere.xPos = 200;
			renderList.push(sphere);
			
			renderer.addEventListener(Mouse3DEvent.MOUSE_CLICK, mouseClick);
			renderer.addEventListener(Mouse3DEvent.MOUSE_OVER, mouseOver);
			renderer.addEventListener(Mouse3DEvent.MOUSE_OUT, mouseOut);
			
			text = new TextField();
			text.textColor = 0xFFFFFF;
			text.width = 300;
			
			addChild(text);
		}

		private function mouseOut(e:Mouse3DEvent):void 
		{
			e.face.material.alpha = 1.0;
			text.text = "mouseOut: " + getTimer();
		}

		private function mouseOver(e:Mouse3DEvent):void 
		{
			e.face.material.alpha = 0.8;
			text.text = "mouseOver: " + getTimer();
		}

		private function mouseClick(e:Mouse3DEvent):void 
		{
			e.face.material.alpha = 0.5;
			text.text = "mouseClick: " + getTimer();
		}

		private function onRenderScene(evt:Event):void 
		{
			renderer.render(renderList, cam);

			(renderList[0] as Object3D).angleX += 0.01;
			(renderList[0] as Object3D).angleY += 0.01;
			
			(renderList[1] as Object3D).angleX += 0.01;
			(renderList[1] as Object3D).angleY += 0.01;
		}
	}
}
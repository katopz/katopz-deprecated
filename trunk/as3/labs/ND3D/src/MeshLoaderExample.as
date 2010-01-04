package 
{
	import de.nulldesign.nd3d.events.MeshEvent;
	import de.nulldesign.nd3d.utils.ASEParser;
	import de.nulldesign.nd3d.utils.MaterialDefaults;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.renderer.Renderer;
	import de.nulldesign.nd3d.utils.MeshLoader;	

	public class MeshLoaderExample extends Sprite 
	{

		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;
		private var meshLoader:MeshLoader;

		function MeshLoaderExample() 
		{

			renderer = new Renderer(this);
			renderer.dynamicLighting = true;
			renderer.ambientColor = 0x000000;
			renderer.ambientColorCorrection = 0.6; 
			// use this value if your mesh gehts to dark / bright

			cam = new PointCamera(600, 400);
			cam.zOffset = -100;
			
			renderList = [];
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(Event.ENTER_FRAME, onRenderScene);

			// minelayercorvette
			var textures:Array = [];
			textures.push("textures/page3.jpg");
			textures.push("textures/page1.jpg");
			textures.push("textures/page4.jpg");
			textures.push("textures/page0.jpg");
			textures.push("textures/page2.jpg");

			meshLoader = new MeshLoader(new ASEParser());
			meshLoader.addEventListener(MeshEvent.MESH_LOADED, onMeshLoaded);
			meshLoader.loadMesh("models/fighter.ASE", textures, new MaterialDefaults(true, true));
		}

		private function onMouseWheel(evt:MouseEvent):void 
		{
			cam.zOffset -= evt.delta * 5;
		}

		private function onMeshLoaded(evt:MeshEvent):void 
		{
			evt.mesh.scale(3, 3, 3);
			renderList.push(evt.mesh);
		}

		private function onRenderScene(evt:Event):void 
		{
			cam.angleX += (mouseY - cam.vpY) * .0005;
			cam.angleY += (mouseX - cam.vpX) * .0005;

			renderer.render(renderList, cam);
		}
	}
}

package 
{
	import de.nulldesign.nd3d.utils.ASEParser;
	import de.nulldesign.nd3d.utils.MaterialDefaults;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.ByteArray;

	import de.nulldesign.nd3d.events.MeshEvent;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.PointCamera;
	import de.nulldesign.nd3d.renderer.Renderer;
	import de.nulldesign.nd3d.utils.MeshLoader;	

	public class MeshEmbedExample extends Sprite 
	{

		[Embed(source='assets/monkey.ase', mimeType="application/octet-stream")]
		private const monkeyMeshData:Class;

		[Embed(source='assets/monkey.jpg', mimeType="application/octet-stream")]
		private const monkeyTexture:Class;

		[Embed(source='assets/hat.ase', mimeType="application/octet-stream")]
		private const hatMeshData:Class;

		[Embed(source='assets/hat.jpg', mimeType="application/octet-stream")]
		private const hatTexture:Class;

		private var cam:PointCamera;
		private var renderer:Renderer;
		private var renderList:Array;
		private var meshLoader:MeshLoader;

		function MeshEmbedExample() 
		{
			renderer = new Renderer(this);

			cam = new PointCamera(600, 400);
			cam.zOffset = -100;
			cam.y = -20;
			
			renderList = [];
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			addEventListener(Event.ENTER_FRAME, onRenderScene);

			// embedded monkey
			var textures:Array = [new monkeyTexture()];
			meshLoader = new MeshLoader(new ASEParser());
			meshLoader.addEventListener(MeshEvent.MESH_LOADED, onMeshLoaded);
			meshLoader.loadMeshBytes(new monkeyMeshData() as ByteArray, textures, new MaterialDefaults(false, true));
			
			textures = [new hatTexture()];
			meshLoader = new MeshLoader(new ASEParser());
			meshLoader.addEventListener(MeshEvent.MESH_LOADED, onMeshLoaded);
			meshLoader.loadMeshBytes(new hatMeshData() as ByteArray, textures, new MaterialDefaults(false, true));
		}

		private function onMouseWheel(evt:MouseEvent):void 
		{
			cam.zOffset -= evt.delta * 5;
		}

		private function onMeshLoaded(evt:MeshEvent):void 
		{
			evt.mesh.scale(20, 20, 20);
			if (evt.target == meshLoader) // FIX hat offset
				evt.mesh.yPos -= 4;
			
			evt.mesh.angleX = Math.PI;
			renderList.push(evt.mesh);
		}

		private function onRenderScene(evt:Event):void 
		{
			cam.angleX += ((mouseY / stage.stageHeight - 0.3) - cam.angleX) * 0.1;
			cam.angleY += (mouseX - cam.vpX) * .0005;

			renderer.render(renderList, cam);
		}
	}
}

package  
{
	import __AS3__.vec.Vector;
	
	import flash.events.MouseEvent;
	
	import open3d.materials.BitmapFileMaterial;
	import open3d.objects.Mesh;
	import open3d.objects.Object3D;
	import open3d.objects.Sphere;
	import open3d.view.SimpleView;
	
	[SWF(width=800, height=600, backgroundColor=0x666666, frameRate=30)]
	public class ExSphereSpeedTest extends SimpleView
	{
		override protected function create():void
		{
			// fake click
			onClick();
			
			// your turn
			stage.addEventListener(MouseEvent.CLICK, onClick);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, toggleZSort);
		}
		
		private function toggleZSort(event:MouseEvent):void
		{
			renderer.isFaceZSort = renderer.isMeshZSort = (mouseX>stage.stageWidth/2);
		}
		
		private function onClick(event:MouseEvent=null):void
		{
			var sphere:Sphere = new Sphere(100, 20, 20, new BitmapFileMaterial("assets/earth.jpg"));
			renderer.addChild(sphere);
			
			var _numChildren:int = renderer.numChildren;
			
			var i:int=0;
			for each (var mesh:Mesh in renderer.meshes)
			{
				mesh.x = _numChildren*50*Math.sin(2*Math.PI*i/_numChildren);
				mesh.y = _numChildren*50*Math.cos(2*Math.PI*i/_numChildren);
				i++;
			}
		}
		
		override protected function draw():void
		{
			var world:Object3D = renderer.world;
			world.x = (mouseX-stage.stageWidth/2)/10;
			world.y = (mouseY-stage.stageHeight/2)/10;
			
			if(renderer.view.height)
				world.z += ((renderer.view.height+renderer.numChildren*100)-world.z)/25;
			
			var meshes:Array = renderer.meshes;
			for each (var mesh:Mesh in meshes)
			{
				mesh.rotationX++;
				mesh.rotationY++;
				mesh.rotationZ++;
			}
			
			debugText.appendText(", Click to add more, move mouse left/right to toggle ZSort : " + renderer.isMeshZSort);
		}
	}
}
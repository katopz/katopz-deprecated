package
{
	import flash.display.*;
	import flash.events.*;
	
	import org.papervision3d.cameras.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.utils.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.objects.parsers.MDZ;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.render.*;
	import org.papervision3d.scenes.*;
	import org.papervision3d.view.*;

	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="800", height="600")]
	public class ExMDZ extends MovieClip
	{
		public var viewport:Viewport3D;
		public var scene:Scene3D;
		public var camera:Camera3D;
		public var renderer:BasicRenderEngine;

		public function ExMDZ()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage);
		}

		private function onStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);	
			init();
		}
		
		private function init():void
		{
			viewport = new Viewport3D(800, 600);
			addChild(viewport);

			renderer = new BasicRenderEngine();
			scene = new Scene3D();
			camera = new Camera3D();
			
			addEventListener(Event.ENTER_FRAME, loop);
			
			onInit();
		}
		
		private function onInit():void
		{
			scene.addChild(new Sphere);
			
			var _mdz:MDZ = new MDZ();
			_mdz.load("nemuvine.mdz");
			scene.addChild(_mdz);
		}

		private function loop(event:Event):void
		{
			renderer.renderScene(scene, camera, viewport);
		}
	}
}
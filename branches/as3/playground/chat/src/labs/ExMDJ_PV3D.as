package labs
{
	import flash.display.*;
	import flash.events.*;
	
	import org.papervision3d.objects.parsers.MDJ;
	import org.papervision3d.templates.PV3DTemplate;
	
	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="800", height="600")]
	public class ExMDJ_PV3D extends PV3DTemplate
	{
		private var _mdj:MDJ;
		
		override protected function onInit():void
		{
			_mdj = new MDJ(false);
			_mdj.path = "../../";
			_mdj.addEventListener(Event.COMPLETE, onComplete);
			_mdj.load("chars/man/model_1.mdj", null, 24, 10);
			
			_scene.addChild(_mdj);
			
			_camera.y = 500;
			_camera.lookAt(_mdj);
		}
		
		private function onComplete(event:Event):void
		{
			_mdj.removeEventListener(Event.COMPLETE, onComplete);
			_mdj.play("talk");
		}
		
		override protected function onPreRender():void
		{
			_mdj.rotationY++;
		}
	}
}
package
{
	import flash.display.*;
	import flash.events.*;
	
	import org.papervision3d.objects.parsers.MDJ;
	
	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="800", height="600")]
	public class ExMDJ extends PV3DTemplate
	{
		private var _mdj:MDJ;
		
		override protected function onInit():void
		{
			_mdj = new MDJ(false);
			_mdj.addEventListener(Event.COMPLETE, onComplete);
			_mdj.load("chars/man/model_1.mdj", null, 24, 10);
			
			scene.addChild(_mdj);
			
			camera.y = 500;
			camera.lookAt(_mdj);
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
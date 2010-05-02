package labs
{
	import flash.display.*;
	import flash.events.*;
	
	import org.papervision3d.objects.parsers.MDZ;

	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="800", height="600")]
	public class ExMDZ extends PV3DTemplate
	{
		private var _mdz:MDZ;

		override protected function onInit():void
		{
			_mdz = new MDZ(false);
			_mdz.addEventListener(Event.COMPLETE, onComplete);
			_mdz.load("chars/man/model_2.mdz", null, 24, 10);
			
			scene.addChild(_mdz);
			
			camera.y = 500;
			camera.lookAt(_mdz);
		}
		
		private function onComplete(event:Event):void
		{
			_mdz.removeEventListener(Event.COMPLETE, onComplete);
			_mdz.play("talk");
		}
		
		override protected function onPreRender():void
		{
			_mdz.rotationY++;
		}
	}
}
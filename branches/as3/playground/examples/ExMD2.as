package examples
{
	import flash.events.Event;
	
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.parsers.MD2;
	import org.papervision3d.view.BasicView;
	
	[SWF(width="640", height="480", backgroundColor="#000000", frameRate="30")]
	public class ExMD2 extends BasicView
	{
		private var md2:MD2;
		
		public function ExMD2() 
		{
			super();
			
			md2 = new MD2();
			md2.load("assets/cat.md2", new BitmapFileMaterial("soso:assets/soso.png"), 16, 4);
			scene.addChild(md2);
		}
		
		override protected function onRenderTick(event:Event=null):void
		{
			camera.lookAt(md2);
			renderer.renderScene(scene, camera, viewport);
		}
	}
}
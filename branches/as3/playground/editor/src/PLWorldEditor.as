package
{
	import com.cutecoma.playground.core.Engine3D;
	import com.cutecoma.playground.data.*;
	import com.cutecoma.playground.editors.WorldEditor;
	import com.sleepydesign.templates.ApplicationTemplate;

	import flash.net.registerClassAlias;

	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="480")]
	/**
	 *
	 * @author katopz
	 *
	 */
	public class PLWorldEditor extends ApplicationTemplate
	{
		private var _worldEditor:WorldEditor;
		private var _engine3D:Engine3D;

		public function PLWorldEditor()
		{
			registerClassAlias("com.cutecoma.playground.data.AreaData", AreaData);
			registerClassAlias("com.cutecoma.playground.data.MapData", MapData);
			registerClassAlias("com.cutecoma.playground.data.SceneData", SceneData);
			registerClassAlias("com.cutecoma.playground.data.ViewData", ViewData);
			registerClassAlias("com.cutecoma.playground.data.CameraData", CameraData);
		}

		override protected function onInit():void
		{
			_engine3D = new Engine3D();
			_engine3D.completeSignal.addOnce(onEngineInit);

			_contentLayer.addChild(_engine3D);
		}

		private function onEngineInit():void
		{
			_worldEditor = new WorldEditor(_engine3D);
			_worldEditor.areaPath = "../../areas/"

			// test
			_worldEditor.openArea("87.ara");
		}
	}
}
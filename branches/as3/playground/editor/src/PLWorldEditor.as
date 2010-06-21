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
		/**
		 * 	       [PlayGround]
		 * 	             |
		 * 	        [Engine3D]
		 *	             |
		 *	[Char]----[World]----[Area]
		 *	   |         |         |
		 *	[CharE]---[WorldE]---[AreaE]
		 */

		/*
		   TODO :

		   + editor
		   //- switch between area //reload other area -> destroy -> create
		   //- view FPS controller
		   - flood fill
		   //- import/export external bitmap as map
		   //- load and save as other id
		   - clean up
		   - MVC

		   + chat
		   - load MDJ and test path finder, speed, destroy, model pool
		   - test switch between area
		   - login via opensocial
		   - clean up
		   - MVC

		   + lite
		   - heightmap support, test with jiglib
		   - 2.5D Clip, animation controller
		   - infinite loop perlin noise fog, fire
		   - lenflare
		   - explode effect
		 */

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
			_engine3D.systemLayer = _systemLayer;
			_engine3D.contentLayer = _contentLayer;
			_engine3D.completeSignal.addOnce(onEngineInit);

			addChild(_engine3D);
		}

		private function onEngineInit():void
		{
			_worldEditor = new WorldEditor(_engine3D);

			// test
			_worldEditor.openArea("../../areas/87.ara");
		}
	}
}
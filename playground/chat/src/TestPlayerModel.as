package
{
	import away3dlite.animators.MovieMeshContainer3D;
	import away3dlite.core.utils.Debug;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Loader3D;
	import away3dlite.loaders.MDJ;
	import away3dlite.templates.BasicTemplate;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="800", height="600")]
	/**
	 * Example : MDJ load and play.
	 * @author katopz
	 */
	public class TestPlayerModel extends BasicTemplate
	{
		private var _model:MovieMeshContainer3D;

		override protected function onInit():void
		{
			// add desc
			title = "Click to toogle animation on/off |";

			// better view angle
			camera.y = -500;
			camera.lookAt(new Vector3D());

			// debug
			Debug.active = true;

			// parser
			var _mdj:MDJ = new MDJ();
			_mdj.meshPath = "../../";
			_mdj.texturePath = "../../";

			// load it
			var _loader3D:Loader3D = new Loader3D();
			_loader3D.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			_loader3D.loadGeometry("user.mdj", _mdj);
			scene.addChild(_loader3D);

			stage.addEventListener(MouseEvent.CLICK, onClick);
			
			alpha = .1;
		}

		private function onSuccess(event:Loader3DEvent):void
		{
			_model = event.target.handle as MovieMeshContainer3D;
			_model.play("talk");
		}

		private function onClick(event:Event):void
		{
			if (!_model)
				return;

			if (_model.currentLabel!="talk")
				_model.play("talk");
			else
				_model.play("walk");
		}

		override protected function onPreRender():void
		{
			scene.rotationY++;
		}
	}
}
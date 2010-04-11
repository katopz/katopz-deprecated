package
{
	import away3dlite.templates.BasicTemplate;
	
	import flash.utils.*;

	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]
	/**
	 * TODO
	 * 1. select model type man/woman
	 * 2. select more textures
	 * 3. pack back to new model pack
	 */
	public class CharactorEditor extends BasicTemplate
	{
		private var _EditorTool:EditorTool;
		
		override protected function onInit():void
		{
			view.mouseEnabled3D = false;

			// EditorTool
			_EditorTool = new EditorTool(this);
			_EditorTool.initXML("config.xml");

			// ModelPooling
			var _modelPool:ModelPool = new ModelPool(this);
			_modelPool.initXML("chars.xml");

			// binding
			ModelPool.signal.add(_EditorTool.activate);
			ModelPool.resetSignal.add(_EditorTool.reset);
		}

		override protected function onPreRender():void
		{
			camera.y = -200;
			
			//
			//if (_EditorTool.skinAnimation)
			//	_EditorTool.skinAnimation.update(getTimer() * 2 / 1000);
			
			scene.rotationY++;
		}
	}
}
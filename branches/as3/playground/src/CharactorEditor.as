package
{
	import away3dlite.templates.BasicTemplate;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]
	/**
	 * TODO
	 * 2. pack back to new model pack?
	 * 3. test external interface
	 */
	public class CharactorEditor extends BasicTemplate
	{
		private var _editorTool:EditorTool;

		override protected function onInit():void
		{
			view.mouseEnabled3D = false;

			// EditorTool
			_editorTool = new EditorTool(this);
			_editorTool.showAxis = true;
			_editorTool.initXML("config.xml");
		}

		override protected function onPreRender():void
		{
			camera.y = -200;
			scene.rotationY++;
		}
	}
}
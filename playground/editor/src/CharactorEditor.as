package
{
	import away3dlite.core.utils.Debug;
	import away3dlite.templates.BasicTemplate;
	
	import flash.display.Sprite;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]
	/**
	 * TODO
	 * 2. pack back to new model pack?
	 * 3. test external interface
	 */
	public class CharactorEditor extends Sprite
	{
		private var _editorTool:EditorTool;

		public function CharactorEditor()
		{
			// EditorTool
			Debug.active = true;
			addChild(_editorTool = new EditorTool());
			_editorTool.initXML("config.xml");
			alpha = .25
		}
	}
}
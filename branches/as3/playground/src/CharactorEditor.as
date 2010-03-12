package
{
	import away3dlite.templates.BasicTemplate;
	
	import flash.display.Bitmap;
	import flash.utils.*;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]
	/**
	 * TODO
	 * 1. load 5 prototype compressed model
	 * 2. create model tree
	 * 		Hair, Head, Shirt, Pant, Shoes
	 * 3. rebuild dae and compress + save
	 * 4. reload model for testing animation
	 */
	public class CharactorEditor extends BasicTemplate
	{
		override protected function onInit():void
		{
			view.mouseEnabled3D = false;
			
			// EditorTool
			var _EditorTool:EditorTool = new EditorTool(this);
			_EditorTool.initXML("config.xml");
			
			// ModelPooling
			var _modelPool:ModelPool = new ModelPool();
			_modelPool.initXML("chars.xml");
			
			// binding
			ModelPool.signal.add(_EditorTool.activate);
		}
	}
}
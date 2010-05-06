package
{
	import com.sleepydesign.components.SDDialog;
	
	import flash.display.Sprite;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]
	public class main extends Sprite
	{
		private var _currentEditor:*;
		
		private var _menu:SDDialog;

		public function main()
		{
			// menu
			_menu = new SDDialog(<question><![CDATA[Select Editor]]>
								<answer src="as:onSelectEditor('WorldEditor')"><![CDATA[World]]></answer>
								<answer src="as:onSelectEditor('Character')"><![CDATA[Character]]></answer>
							</question>, this);
			_menu.align = "";
			addChild(_menu);
		}
		
		public function onSelectEditor(editorType:String):void
		{
			_menu.visible = false;
			switch(editorType)
			{
				case "World":
				addChild(_currentEditor = new PLWorldEditor());
				break;
				case "Character":
				addChild(_currentEditor = new PLCharacterEditor());
				break;
			}
		}
	}
}